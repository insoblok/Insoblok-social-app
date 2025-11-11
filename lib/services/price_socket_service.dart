import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceUpdate {
  const PriceUpdate({required this.symbol, required this.price});
  final String symbol;
  final double price;
}

class PriceSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final StreamController<PriceUpdate> _controller =
      StreamController<PriceUpdate>.broadcast();
  bool enableLogs = false;
  Timer? _fallbackTimer;
  bool _receivedAnyTick = false;
  _Backend _backend = _Backend.binance;
  bool? _isUsIpCached;
  DateTime? _geoCheckedAt;

  List<String> _currentSymbols = const [];
  String _currentQuote = 'USDT';
  bool _disposed = false;

  Stream<PriceUpdate> get updates => _controller.stream;

  Future<void> connect(List<String> symbols, {String fiat = 'USD'}) async {
    if (_disposed) return;
    final normalized =
        {for (final s in symbols) s.trim().toUpperCase()}.toList();
    if (normalized.isEmpty) {
      await _teardown();
      return;
    }

    final quote = _mapFiatToQuote(fiat);
    // Choose initial backend by geolocation to avoid .com on US IPs.
    final initialBackend = await _chooseInitialBackend();
    final initialUrl = _buildBinanceCombinedStreamUrl(
      normalized,
      quote,
      us: initialBackend == _Backend.binanceUs,
    );

    // Reconnect only if stream config changed.
    if (_channel != null &&
        _currentQuote == quote &&
        _listsEqualIgnoreOrder(_currentSymbols, normalized)) {
      return;
    }

    await _teardown();
    _currentSymbols = normalized;
    _currentQuote = quote;

    // Prefer global .com; some assets are missing on .us (e.g., XRP, BNB).
    if (enableLogs) {
      final dbg = normalized.join(',');
      _log('Connecting WS for [$dbg] quote=$quote');
    }
    try {
      _backend = initialBackend;
      _channel = WebSocketChannel.connect(Uri.parse(initialUrl));
      _subscription = _channel!.stream.listen(
        _onMessage,
        onError: (_) => _handleWsError(normalized, quote),
        onDone: () => _handleWsError(normalized, quote),
        cancelOnError: true,
      );
    } catch (_) {
      // fallback to the alternative Binance host first, then CoinCap
      final useUs = initialBackend != _Backend.binanceUs;
      final fallback = _buildBinanceCombinedStreamUrl(normalized, quote, us: useUs);
      try {
        _backend = useUs ? _Backend.binanceUs : _Backend.binance;
        _channel = WebSocketChannel.connect(Uri.parse(fallback));
        _subscription = _channel!.stream.listen(
          _onMessage,
          onError: (_) => _handleWsError(normalized, quote),
          onDone: () => _handleWsError(normalized, quote),
          cancelOnError: true,
        );
      } catch (_) {
        await _switchToCoinCap(normalized);
      }
    }

    // Seed immediate prices so UI doesn't show 0.00 while waiting for first tick.
    unawaited(_seedInitialPrices(normalized, quote));

    // If no tick arrives quickly (e.g., geoblocked), auto-fallback to CoinCap.
    _receivedAnyTick = false;
    _fallbackTimer?.cancel();
    _fallbackTimer = Timer(const Duration(seconds: 4), () async {
      if (_disposed || _receivedAnyTick) return;
      if (enableLogs) _log('No ticks received, switching to CoinCap');
      await _switchToCoinCap(normalized);
    });
  }

  Future<void> disconnect() async {
    await _teardown();
  }

  Future<void> dispose() async {
    _disposed = true;
    await _teardown();
    await _controller.close();
  }

  // ----- internals -----

  void _onMessage(dynamic message) {
    try {
      final payload = json.decode(message as String);
      final data = payload['data'];
      if (data is! Map<String, dynamic>) return;
      final pair = data['s'] as String?; // e.g., BTCUSDT
      final last = data['c']; // string price
      if (pair == null || last == null) return;
      final price = double.tryParse(last.toString());
      if (price == null) return;
      final base = pair.toUpperCase().replaceAll(_currentQuote.toUpperCase(), '');
      if (enableLogs) {
        _log('tick $base $_currentQuote $price');
      }
      _receivedAnyTick = true;
      _controller.add(PriceUpdate(symbol: base, price: price));
    } catch (_) {
      // ignore parsing errors
    }
  }

  Future<void> _teardown() async {
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    final syms = _currentSymbols;
    final quote = _currentQuote;
    Future<void>.delayed(const Duration(seconds: 3), () {
      if (_disposed) return;
      connect(syms, fiat: quote); // reuse quote mapping
    });
  }

  String _mapFiatToQuote(String fiat) {
    final f = (fiat).toUpperCase();
    if (f == 'USD' || f == 'USDT') return 'USDT';
    if (f == 'EUR') return 'EUR';
    return 'USDT';
  }

  String _buildBinanceCombinedStreamUrl(List<String> symbols, String quote, {bool us = false}) {
    final streams = symbols
        .map((s) => '${s.toLowerCase()}${quote.toLowerCase()}@ticker')
        .join('/');
    final host = us ? 'binance.us' : 'binance.com';
    return 'wss://stream.$host:9443/stream?streams=$streams';
  }

  Future<_Backend> _chooseInitialBackend() async {
    // Cache geolocation result for a few hours to avoid frequent calls.
    final now = DateTime.now();
    if (_isUsIpCached != null &&
        _geoCheckedAt != null &&
        now.difference(_geoCheckedAt!).inHours < 6) {
      if (enableLogs) _log('Geo cached: isUS=${_isUsIpCached!}');
      return _isUsIpCached! ? _Backend.binanceUs : _Backend.binance;
    }
    final isUs = await _detectUsIp();
    _isUsIpCached = isUs;
    _geoCheckedAt = now;
    if (enableLogs) _log('Geo detected: isUS=$isUs');
    return isUs ? _Backend.binanceUs : _Backend.binance;
  }

  Future<bool> _detectUsIp() async {
    try {
      // Try ipinfo.io first
      final uri1 = Uri.parse('https://ipinfo.io/json');
      final r1 = await http.get(uri1).timeout(const Duration(seconds: 6));
      if (r1.statusCode == 200) {
        final m = json.decode(r1.body);
        final cc = (m is Map ? m['country'] : null)?.toString().toUpperCase();
        if (enableLogs) _log('ipinfo.io country=$cc');
        if (cc == 'US') return true;
        if (cc != null && cc.isNotEmpty) return false;
      }
    } catch (_) {}
    try {
      // Fallback ipapi.co (lightweight endpoints)
      final uri2 = Uri.parse('https://ipapi.co/country/');
      final r2 = await http.get(uri2).timeout(const Duration(seconds: 6));
      if (r2.statusCode == 200) {
        final cc = r2.body.trim().toUpperCase();
        if (enableLogs) _log('ipapi.co country=$cc');
        return cc == 'US';
      }
    } catch (_) {}
    // Unknown => keep default (.com)
    return false;
  }

  bool _listsEqualIgnoreOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    final aa = [...a]..sort();
    final bb = [...b]..sort();
    for (int i = 0; i < aa.length; i++) {
      if (aa[i] != bb[i]) return false;
    }
    return true;
  }

  Future<void> _seedInitialPrices(List<String> symbols, String quote) async {
    if (_disposed) return;
    final pairs = symbols.map((s) => '"${s.toUpperCase()}$quote"').join(',');
    final query = '[${pairs}]';

    Future<bool> _tryHost(String host) async {
      final uri = Uri.parse('https://api.$host/api/v3/ticker/price?symbols=$query');
      if (enableLogs) {
        _log('Seed snapshot: $uri');
      }
      try {
        final resp = await http.get(uri).timeout(const Duration(seconds: 7));
        if (resp.statusCode != 200) return false;
        final data = json.decode(resp.body);
        if (data is List) {
          for (final m in data) {
            final sym = (m['symbol'] ?? '').toString();
            final priceStr = (m['price'] ?? '').toString();
            final price = double.tryParse(priceStr);
            if (sym.isEmpty || price == null) continue;
            final base = sym.toUpperCase().replaceAll(quote.toUpperCase(), '');
            if (enableLogs) {
              _log('seed $base $price');
            }
            _controller.add(PriceUpdate(symbol: base, price: price));
          }
          return true;
        }
      } catch (_) {
        return false;
      }
      return false;
    }

    // Prefer the currently selected backend first
    final preferUs = _backend == _Backend.binanceUs;
    final firstHost = preferUs ? 'binance.us' : 'binance.com';
    final secondHost = preferUs ? 'binance.com' : 'binance.us';

    var ok = await _tryHost(firstHost);
    if (!ok) {
      ok = await _tryHost(secondHost);
      if (!ok) {
        await _seedCoinCap(symbols);
      }
    }
  }

  void _log(String msg) {
    // Keep logs terse to avoid flooding
    // ignore: avoid_print
    print('[PriceSocket] $msg');
  }

  Future<void> _handleWsError(List<String> symbols, String quote) async {
    if (_disposed) return;
    if (enableLogs) _log('WS closed/error on $_backend, trying fallback');
    if (_backend == _Backend.binance) {
      // try binance.us
      try {
        await _teardown();
        final fb = _buildBinanceCombinedStreamUrl(symbols, quote, us: true);
        _backend = _Backend.binanceUs;
        _channel = WebSocketChannel.connect(Uri.parse(fb));
        _subscription = _channel!.stream.listen(
          _onMessage,
          onError: (_) => _handleWsError(symbols, quote),
          onDone: () => _handleWsError(symbols, quote),
          cancelOnError: true,
        );
        return;
      } catch (_) {
        // fall through
      }
    }
    await _switchToCoinCap(symbols);
  }

  Future<void> _switchToCoinCap(List<String> symbols) async {
    if (_disposed) return;
    await _teardown();
    _backend = _Backend.coincap;
    final ids = _mapSymbolsToCoinCapIds(symbols);
    if (ids.isEmpty) return;
    final assets = ids.values.toSet().join(',');
    final url = 'wss://ws.coincap.io/prices?assets=$assets';
    if (enableLogs) _log('Connecting CoinCap WS: $assets');
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _subscription = _channel!.stream.listen(
      (message) => _onCoinCapMessage(message, ids),
      onError: (_) => _scheduleReconnect(),
      onDone: _scheduleReconnect,
      cancelOnError: true,
    );
    // also seed from coincap REST if binance snapshot failed
    await _seedCoinCap(symbols);
  }

  void _onCoinCapMessage(dynamic message, Map<String, String> idToSymbol) {
    try {
      final data = json.decode(message as String);
      if (data is! Map) return;
      data.forEach((k, v) {
        final id = k.toString();
        final sym = idToSymbol[id];
        if (sym == null) return;
        final price = double.tryParse(v.toString());
        if (price == null) return;
        if (enableLogs) _log('tick $sym USD $price (CoinCap)');
        _controller.add(PriceUpdate(symbol: sym, price: price));
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _seedCoinCap(List<String> symbols) async {
    final ids = _mapSymbolsToCoinCapIds(symbols); // id -> symbol
    if (ids.isEmpty) return;
    final query = ids.keys.toSet().join(','); // CoinCap expects asset IDs
    final uri = Uri.parse('https://api.coincap.io/v2/assets?ids=$query');
    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 7));
      if (resp.statusCode != 200) return;
      final body = json.decode(resp.body);
      final list = body['data'];
      if (list is List) {
        for (final m in list) {
          final id = (m['id'] ?? '').toString();
          final sym = ids[id];
          final price = double.tryParse((m['priceUsd'] ?? '').toString());
          if (sym == null || price == null) continue;
          if (enableLogs) _log('seed $sym $price (CoinCap)');
          _controller.add(PriceUpdate(symbol: sym, price: price));
        }
      }
    } catch (_) {
      // ignore
    }
  }

  Map<String, String> _mapSymbolsToCoinCapIds(List<String> symbols) {
    const map = {
      'BTC': 'bitcoin',
      'ETH': 'ethereum',
      'SOL': 'solana',
      'BNB': 'binance-coin',
      'XRP': 'ripple',
      'DOGE': 'dogecoin',
      'USDT': 'tether',
      'USDC': 'usd-coin',
      'ADA': 'cardano',
      'DOT': 'polkadot',
      'MATIC': 'polygon',
      'AVAX': 'avalanche',
      'LINK': 'chainlink',
      'LTC': 'litecoin'
    };
    final out = <String, String>{};
    for (final s in symbols) {
      final id = map[s.toUpperCase()];
      if (id != null) out[id] = s.toUpperCase();
    }
    // return id -> symbol mapping
    return out.map((key, value) => MapEntry(key, value));
  }
}

enum _Backend { binance, binanceUs, coincap }

