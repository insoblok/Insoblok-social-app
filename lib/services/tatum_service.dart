import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class TatumService {
  TatumService({http.Client? httpClient})
    : client = httpClient ?? http.Client();

  final String apiKey = ApiConfig.tatumApiKey;
  final String tatumBaseUrl = ApiConfig.tatumBaseUrl;
  final String tatumCardanoBaseUrl = ApiConfig.tatumCardanoBaseUrl;

  final http.Client client;

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'accept': 'application/json',
    'x-api-key': apiKey,
  };

  /// Quick check that key is valid/authorized (v3 version endpoint is fine).
  Future<bool> testTatumApiKey() async {
    try {
      final uri = Uri.parse('$tatumBaseUrl/v3/tatum/version');
      final resp = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) return true;

      _logHttpError('testTatumApiKey', resp);
      return false;
    } on Exception catch (e) {
      print('❌ testTatumApiKey error: $e');
      return false;
    }
  }

  /// Hardened Tatum price fetch:
  /// 1) Normalize base URL
  /// 2) Try POST /v4/data/rate/symbol (batch)
  /// 3) If 404/405, fall back to GET /v4/data/rate/symbol?symbol=... (per symbol)
  Future<Map<String, double>> getTokenPricesFromTatum(
    List<String> symbols,
  ) async {
    final Map<String, double> out = {};
    if (symbols.isEmpty) return out;

    // --- 1) normalize base URL (no trailing slash, no '/v4')
    final base = tatumBaseUrl
        .replaceAll(RegExp(r'/+$'), '')
        .replaceAll(RegExp(r'/v4$'), '');
    final postUri = Uri.parse('$base/v4/data/rate/symbol');

    // de-dup + UPPERCASE
    final unique = {for (final s in symbols) s.trim().toUpperCase()}.toList();

    // --- 2) try BATCH POST first
    try {
      final body = jsonEncode({'symbols': unique, 'basePair': 'USD'});
      print('➡️ Tatum POST: $postUri');
      final resp = await client
          .post(postUri, headers: headers, body: body)
          .timeout(const Duration(seconds: 12));

      if (resp.statusCode == 200) {
        final decoded = json.decode(resp.body);
        final dynamic items =
            decoded is Map<String, dynamic>
                ? (decoded['rates'] ?? decoded)
                : decoded;

        if (items is List) {
          for (final r in items) {
            if (r is Map<String, dynamic>) {
              final sym =
                  (r['symbol'] ?? r['baseSymbol'] ?? '')
                      .toString()
                      .toUpperCase();
              final val = r['value'] ?? r['rate'] ?? r['price'];
              if (sym.isNotEmpty && val is num) out[sym] = val.toDouble();
            }
          }
        }
        if (out.isNotEmpty) return out; // success
      } else {
        print('❌ POST /v4/data/rate/symbol ${resp.statusCode}: ${resp.body}');
        // Only fall back on 404/405/501-ish method/path issues
        if (resp.statusCode != 404 &&
            resp.statusCode != 405 &&
            resp.statusCode != 501) {
          return out; // other error -> let caller try CoinGecko
        }
      }
    } catch (e) {
      print('❌ Batch POST failed: $e');
      // continue to GET fallback
    }

    // --- 3) GET fallback (one request per symbol)
    // docs: GET /v4/data/rate/symbol?symbol=BTC&basePair=USD
    // We'll do them sequentially for simplicity; parallelize if you want.
    for (final sym in unique) {
      final getUri = Uri.parse(
        '$base/v4/data/rate/symbol?symbol=$sym&basePair=USD',
      );
      try {
        print('➡️ Tatum GET: $getUri');
        final r = await client
            .get(getUri, headers: headers)
            .timeout(const Duration(seconds: 10));
        if (r.statusCode == 200) {
          final d = json.decode(r.body);

          // Expect: {"value":"12345.6789","basePair":"USD","timestamp":...,"source":"...","symbol":"BTC"}
          num? parsed;
          if (d is Map<String, dynamic>) {
            final raw = d['value'] ?? d['rate'] ?? d['price'];
            if (raw is num) {
              parsed = raw;
            } else if (raw is String) {
              parsed = num.tryParse(raw); // <-- handle string values
            }
          }

          if (parsed != null) {
            out[sym] = parsed.toDouble();
            print('✅ $sym = ${out[sym]} USD');
          } else {
            print('⚠️ Could not parse value for $sym: ${r.body}');
          }
        } else {
          print('⚠️ GET $sym ${r.statusCode}: ${r.body}');
        }
      } catch (e) {
        print('⚠️ GET $sym failed: $e');
      }
      await Future.delayed(
        const Duration(milliseconds: 120),
      ); // rate-limit friendly
    }

    print('⚠️ return out:  $out');
    return out;
  }

  /// Free fallback: CoinGecko simple price (symbol → id map).
  Future<Map<String, double>> getTokenPricesFromCoinGecko(
    List<String> symbols,
  ) async {
    final Map<String, double> out = {};
    if (symbols.isEmpty) return out;

    const Map<String, String> cgIds = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'USDT': 'tether',
      'BNB': 'binancecoin',
      'SOL': 'solana',
      'ADA': 'cardano',
      'XRP': 'ripple',
      'DOT': 'polkadot',
      'DOGE': 'dogecoin',
      'MATIC': 'matic-network',
      'LTC': 'litecoin',
      'LINK': 'chainlink',
      'UNI': 'uniswap',
      'AVAX': 'avalanche-2',
      'ATOM': 'cosmos',
    };

    final normalized =
        {for (final s in symbols) s.trim().toUpperCase()}.toList();
    final ids = <String>[];
    for (final s in normalized) {
      final id = cgIds[s];
      if (id != null) ids.add(id);
    }
    if (ids.isEmpty) return out;

    final uri = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=${ids.join(',')}&vs_currencies=usd',
    );

    try {
      final resp = await client.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;
        for (final s in normalized) {
          final id = cgIds[s];
          final usd = data[id]?['usd'];
          if (usd is num) {
            out[s] = usd.toDouble();
            print('✅ CoinGecko $s: \$${out[s]!.toStringAsFixed(6)}');
          }
        }
      } else {
        _logHttpError('getTokenPricesFromCoinGecko', resp);
      }
    } on Exception catch (e) {
      print('❌ CoinGecko failed: $e');
    }
    return out;
  }

  /// Simple mock to keep UI moving when providers fail.
  Map<String, double> getMockPrices(List<String> symbols) {
    final Map<String, double> base = const {
      'BTC': 45123.45,
      'ETH': 3245.67,
      'USDT': 1.0,
      'BNB': 567.89,
      'SOL': 123.45,
      'XRP': 0.5678,
      'ADA': 0.4567,
    };

    final int seed = DateTime.now().millisecond;
    final Map<String, double> out = {};
    for (final s in symbols) {
      final sym = s.toUpperCase();
      final basePrice = base[sym] ?? 1.0;
      final variation = ((seed % 100) - 50) / 1000.0; // ±5%
      out[sym] = basePrice * (1 + variation);
    }
    print('📊 Using mock data with variations');
    return out;
  }

  /// Public API: Tatum → CoinGecko → Mock
  Future<Map<String, double>> getTokenPrices(List<String> symbols) async {
    print('🚀 Fetching prices for: ${symbols.join(', ')}');

    Map<String, double> prices = {};
    final bool tatumOk = await testTatumApiKey();

    if (tatumOk) {
      prices = await getTokenPricesFromTatum(symbols);
    } else {
      print('⚠️ Tatum key invalid/missing entitlements — using fallbacks');
    }

    // Fill missing via CoinGecko
    final missing =
        symbols
            .map((s) => s.toUpperCase())
            .where((s) => !prices.containsKey(s))
            .toList();
    if (missing.isNotEmpty) {
      final cg = await getTokenPricesFromCoinGecko(missing);
      prices.addAll(cg);
    }

    // Final fallback
    if (prices.isEmpty) {
      prices = getMockPrices(symbols);
    }

    print('🎯 Final prices retrieved: ${prices.length} tokens');
    return prices;
  }

  /// Get list of supported networks/chains from Tatum API
  /// Returns a list of network information including chain names, IDs, and testnet flags
  Future<List<Map<String, dynamic>>> getSupportedNetworks() async {
    // Normalize base URL
    final base = tatumBaseUrl
        .replaceAll(RegExp(r'/+$'), '')
        .replaceAll(RegExp(r'/v4$'), '')
        .replaceAll(RegExp(r'/v3$'), '');

    // Try multiple possible endpoints
    final endpoints = [
      '$base/v3/blockchain/currencies',
      '$base/v3/blockchain/chain',
      '$base/v4/blockchain/chain',
      '$base/v3/blockchain/info',
    ];

    for (final endpoint in endpoints) {
      try {
        final uri = Uri.parse(endpoint);
        print('➡️ Tatum GET supported networks: $uri');
        final resp = await client
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 10));

        if (resp.statusCode == 200) {
          final decoded = json.decode(resp.body);

          // Handle different response formats
          List<Map<String, dynamic>> networks = [];

          if (decoded is List) {
            networks = decoded.cast<Map<String, dynamic>>();
          } else if (decoded is Map<String, dynamic>) {
            // If response is wrapped in an object
            if (decoded.containsKey('chains') && decoded['chains'] is List) {
              networks =
                  (decoded['chains'] as List).cast<Map<String, dynamic>>();
            } else if (decoded.containsKey('data') && decoded['data'] is List) {
              networks = (decoded['data'] as List).cast<Map<String, dynamic>>();
            } else if (decoded.containsKey('currencies') &&
                decoded['currencies'] is List) {
              networks =
                  (decoded['currencies'] as List).cast<Map<String, dynamic>>();
            } else {
              // Single network object
              networks = [decoded];
            }
          }

          if (networks.isNotEmpty) {
            print(
              '✅ Retrieved ${networks.length} supported networks from Tatum (endpoint: $endpoint)',
            );
            return networks;
          }
        } else if (resp.statusCode != 404) {
          // Log non-404 errors but continue trying other endpoints
          _logHttpError('getSupportedNetworks', resp);
        }
      } on Exception catch (e) {
        print('⚠️ getSupportedNetworks error for $endpoint: $e');
        // Continue to next endpoint
      }
    }

    // If all endpoints failed, return empty list
    print('❌ All endpoints failed for getSupportedNetworks');
    return [];
  }

  Future<dynamic> getNetworkList() async {
    try {
      final uri = Uri.parse('$tatumCardanoBaseUrl/network/list');
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      print('response: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load network list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Get token information from Tatum API
  /// [chain] - The blockchain chain (e.g., 'ethereum-mainnet', 'base-mainnet')
  /// [tokenAddress] - Token contract address or 'native' for native tokens (required by API)
  /// Returns empty map if the endpoint is not available or fails
  Future<Map<String, dynamic>> getTokens({
    String chain = 'ethereum-mainnet',
    String tokenAddress = 'native',
  }) async {
    try {
      // Normalize base URL
      final base = tatumBaseUrl
          .replaceAll(RegExp(r'/+$'), '')
          .replaceAll(RegExp(r'/v4$'), '')
          .replaceAll(RegExp(r'/v3$'), '');

      // Use the regular tokens endpoint (not /popular which requires timeframe)
      final uri = Uri.parse('$base/v4/data/tokens').replace(
        queryParameters: {'chain': chain, 'tokenAddress': tokenAddress},
      );

      print('➡️ Tatum GET tokens: $uri');
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      print('response of tokens: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        // Log error but return empty map for non-critical endpoint
        if (response.statusCode != 404) {
          _logHttpError('getTokens', response);
        }
        print('⚠️ getTokens returned ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('⚠️ getTokens error (non-critical): $e');
      // Return empty map instead of throwing - this is not critical
      return {};
    }
  }

  /// Get popular tokens from Tatum API
  /// [chain] - The blockchain chain (e.g., 'ethereum-mainnet', 'base-mainnet')
  /// [timeframe] - Timeframe for popularity (5m, 15m, 1h, 3h, 6h, 1d). Defaults to '1d'
  /// Returns empty map if the endpoint is not available or fails
  Future<Map<String, dynamic>> getPopularTokens({
    String chain = 'ethereum-mainnet',
    String timeframe = '1d',
  }) async {
    try {
      // Normalize base URL
      final base = tatumBaseUrl
          .replaceAll(RegExp(r'/+$'), '')
          .replaceAll(RegExp(r'/v4$'), '')
          .replaceAll(RegExp(r'/v3$'), '');

      // Validate timeframe
      const validTimeframes = ['5m', '15m', '1h', '3h', '6h', '1d'];
      final validTimeframe =
          validTimeframes.contains(timeframe) ? timeframe : '1d';

      // Use the popular tokens endpoint with required timeframe parameter
      final uri = Uri.parse(
        '$base/v4/data/tokens/popular',
      ).replace(queryParameters: {'chain': chain, 'timeframe': validTimeframe});

      print('➡️ Tatum GET popular tokens: $uri');
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      print('response of popular tokens: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        // Log error but return empty map for non-critical endpoint
        if (response.statusCode != 404) {
          _logHttpError('getPopularTokens', response);
        }
        print('⚠️ getPopularTokens returned ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('⚠️ getPopularTokens error (non-critical): $e');
      // Return empty map instead of throwing - this is not critical
      return {};
    }
  }

  void dispose() {
    client.close();
  }

  void _logHttpError(String where, http.Response resp) {
    final snippet =
        resp.body.length > 400 ? '${resp.body.substring(0, 400)}…' : resp.body;
    print('❌ $where error ${resp.statusCode}: $snippet');
  }
}
