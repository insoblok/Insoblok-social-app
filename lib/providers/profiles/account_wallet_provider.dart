import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insoblok/pages/profiles/profiles.dart';
import 'package:insoblok/widgets/TokenListProviderWrapper.dart';
import 'package:insoblok/widgets/token_list_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/providers/profiles/wallet_import_confirm_provider.dart';
import 'package:insoblok/services/tatum_service.dart';

class AccountWalletProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    // Defer notifyListeners to avoid calling during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  var _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  var _dotIndex = 0;
  int get dotIndex => _dotIndex;
  set dotIndex(int i) {
    _dotIndex = i;
    notifyListeners();
  }

  final List<Widget> pages = const [
    Center(child: AccountWalletHomePage()),
    TokenListProviderWrapper(),
    // Center(child: WalletFavoritesPage()),
    Center(child: WalletActivitiesPage()),
    Center(child: WalletNotificationsPage()),
  ];

  late ReownService reownService;

  final List<TransferModel> _transfers = [];

  final List<TastescoreModel> _scores = [];
  List<TastescoreModel> get scores =>
      _scores..sort((b, a) => a.timestamp!.difference(b.timestamp!).inSeconds);

  List<double> get transferXpToInsoValues =>
      transferService.getXpToInsoBalance(_transfers);

  List<double> get transferInsoToUsdtValues =>
      transferService.getInsoToUsdtBalance(_transfers);

  double get balanceInso =>
      transferXpToInsoValues[1] - transferInsoToUsdtValues[0];
  double get balanceUsdt => transferInsoToUsdtValues[1];

  List<String> get networkNames =>
      kWalletTokenList.map((one) => one["chain"].toString()).toList();

  List<Map<String, dynamic>> enabledNetworks = [
    kWalletTokenList[0],
    kWalletTokenList[1],
    kWalletTokenList[3],
    kWalletTokenList[4],
  ];
  setEnabledNetworks(List<Map<String, dynamic>> nets) {
    enabledNetworks = nets;
    notifyListeners();
  }

  Future<void> loadImportedTokens() async {
    try {
      final user = AuthHelper.user;
      if (user == null) return;

      final favoriteTokens = user.favoriteTokens ?? [];
      if (favoriteTokens.isEmpty) return;

      // Load custom tokens from SharedPreferences
      final customTokens = await WalletImportConfirmProvider.getCustomTokens();

      // Create a map of existing enabled networks by their chain
      final existingNetworksMap = <String, Map<String, dynamic>>{};
      for (var network in enabledNetworks) {
        final chainKey = network["chain"].toString();
        existingNetworksMap[chainKey] = network;
      }

      // Add custom tokens to enabledNetworks if they're in favorites
      for (var customToken in customTokens) {
        final tokenId =
            "custom:${customToken["chain"]}:${customToken["token_address"]}";
        if (favoriteTokens.contains(tokenId)) {
          final chain = customToken["chain"].toString();
          final tokenAddress = customToken["token_address"]?.toString() ?? "";

          // Create a unique identifier for this custom token
          final uniqueKey = "${chain}_custom_${tokenAddress}";

          // Check if this custom token is already in enabledNetworks
          bool alreadyExists = false;
          for (var network in enabledNetworks) {
            if (network["isCustom"] == true &&
                network["chain"] == chain &&
                network["token_address"] == tokenAddress) {
              alreadyExists = true;
              break;
            }
          }

          if (!alreadyExists) {
            enabledNetworks.add({
              ...customToken,
              "chain": chain, // Keep original chain for balance lookups
              "isCustom": true, // Mark as custom token
              "customKey": uniqueKey, // Unique identifier
            });
          }
        }
      }

      // Add regular tokens from kWalletTokenList that are in favorites
      for (var token in kWalletTokenList) {
        final coingeckoId = token["coingecko_id"]?.toString();
        if (coingeckoId != null && favoriteTokens.contains(coingeckoId)) {
          final chain = token["chain"].toString();
          // Only add if not already in enabledNetworks
          if (!existingNetworksMap.containsKey(chain)) {
            enabledNetworks.add(token);
            existingNetworksMap[chain] = token;
          }
        }
      }

      notifyListeners();
    } catch (e) {
      logger.e('Error loading imported tokens: $e');
    }
  }

  String get networkString =>
      enabledNetworks.length == 1
          ? enabledNetworks[0]["displayName"]
          : "Networks";

  Map<String, double> tokenValues = {};

  double totalBalance = 0;

  void getAvailableXP() {
    final values = transferService.getXpToInsoBalance(_transfers);
    availableXP = totalScore - values[0];
  }

  List<Map<String, dynamic>> get filteredTransactions {
    if (enabledNetworks.isEmpty) return [];
    // return transactions?.where((txn) {
    //   return enabledNetworks.any((network) =>
    //       network['chain'] == txn['chain']);
    // }).toList() ?? [];
    final filtered =
        transactions?.where((txn) {
          return enabledNetworks.any((network) {
            if (txn["chain"] != null) {
              return network['chain'] == txn['chain'];
            } else {
              return (txn["from_token_network"] == network["chain"] ||
                  txn["to_token_network"] == network["chain"]);
            }
          });
        }).toList() ??
        [];
    return filtered;
  }

  final Web3Service _web3Service = locator<Web3Service>();
  final AuthService authService = AuthService();

  Map<String, double>? get allBalances => _web3Service.allBalances;
  Map<String, double>? get allPrices => _web3Service.allPrices;
  Map<String, double>? get allChanges => _web3Service.allChanges;
  List<Map<String, dynamic>>? get transactions =>
      _web3Service.transactions ?? [];

  Map<String, dynamic> tokenDetails = {};

  Future<void> getTokenDetails(String coingecko_id) async {
    if (isBusy) {
      logger.d("is busy. returning...");
      return;
    }
    clearErrors();
    setBusy(true);
    await runBusyFuture(() async {
      final response = await _web3Service.getTokenDetails(coingecko_id);
      tokenDetails = response;
      notifyListeners();
    }());

    setBusy(false);
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [
    _web3Service,
    authService,
  ];

  // This method can be called to refresh imported tokens
  // It's automatically called in init, but can also be called manually
  // when returning from import page
  Future<void> refreshImportedTokens() async {
    await loadImportedTokens();
    // Refresh prices for imported tokens
    await _fetchPricesForImportedTokens();
  }

  /// Fetch prices for imported/custom tokens using CoinGecko
  Future<void> _fetchPricesForImportedTokens() async {
    try {
      // Collect all coingecko_ids from enabled networks
      final List<String> coingeckoIds = [];
      final Map<String, String> idToChainMap =
          {}; // Map coingecko_id to chain key

      for (var token in enabledNetworks) {
        final coingeckoId = token["coingecko_id"]?.toString() ?? '';
        final chain = token["chain"]?.toString() ?? '';
        final shortName = token["short_name"]?.toString() ?? '';

        if (coingeckoId.isNotEmpty &&
            coingeckoId != 'inso_xp' &&
            coingeckoId != 'insoblok' &&
            coingeckoId != 'sepolia') {
          coingeckoIds.add(coingeckoId);
          idToChainMap[coingeckoId] = chain;
        } else if (shortName.isNotEmpty && chain.isNotEmpty) {
          // For tokens without coingecko_id, try using short_name
          // But we need to be careful not to fetch prices for native chains
          if (![
            'xp',
            'insoblok',
            'ethereum',
            'sepolia',
          ].contains(chain.toLowerCase())) {
            coingeckoIds.add(shortName);
            idToChainMap[shortName] = chain;
          }
        }
      }

      if (coingeckoIds.isEmpty) return;

      // Fetch prices using Tatum service (which uses CoinGecko as fallback)
      final prices = await _tatumService.getTokenPrices(coingeckoIds);

      // Update allPrices with fetched prices
      if (allPrices != null) {
        prices.forEach((symbol, price) {
          // Find the chain key for this symbol
          String? chainKey;
          for (var entry in idToChainMap.entries) {
            if (entry.key.toLowerCase() == symbol.toLowerCase()) {
              chainKey = entry.value;
              break;
            }
          }

          if (chainKey != null && price > 0) {
            allPrices![chainKey] = price;
            logger.d(
              'Fetched price for $chainKey ($symbol): \$${price.toStringAsFixed(2)}',
            );
          }
        });
      }
    } catch (e) {
      logger.e('Error fetching prices for imported tokens: $e');
    }
  }

  /// Get price for a token by coingecko_id or symbol
  double? _getPriceForToken(String identifier, String fallbackSymbol) {
    if (allPrices == null) return null;

    // First try direct lookup by identifier
    if (allPrices!.containsKey(identifier.toLowerCase())) {
      return allPrices![identifier.toLowerCase()];
    }

    // Try to find by matching chain in enabledNetworks
    for (var token in enabledNetworks) {
      final coingeckoId = token["coingecko_id"]?.toString() ?? '';
      final shortName = token["short_name"]?.toString() ?? '';
      final chain = token["chain"]?.toString() ?? '';

      if ((coingeckoId.toLowerCase() == identifier.toLowerCase() ||
              shortName.toLowerCase() == identifier.toLowerCase() ||
              (fallbackSymbol.isNotEmpty &&
                  shortName.toLowerCase() == fallbackSymbol.toLowerCase())) &&
          allPrices!.containsKey(chain)) {
        return allPrices![chain];
      }
    }

    return null;
  }

  CryptoService cryptoService = locator<CryptoService>();

  String? get address => cryptoService.privateKey?.address.hex;

  final TatumService _tatumService = TatumService();

  List<Map<String, dynamic>> _supportedNetworks = [];
  List<Map<String, dynamic>> get supportedNetworks => _supportedNetworks;

  List<Map<String, dynamic>> _popularTokens = [];
  List<Map<String, dynamic>> get popularTokens => _popularTokens;

  // Static reference for easy access from other providers
  static AccountWalletProvider? _instance;
  static bool _isDisposed = false;

  static AccountWalletProvider? get instance {
    // Return null if instance is disposed
    if (_isDisposed || _instance == null) {
      return null;
    }
    return _instance;
  }

  AccountWalletProvider() {
    _instance = this;
    _isDisposed = false;
  }

  @override
  void dispose() {
    // Mark as disposed and clear singleton instance if it's this instance
    if (_instance == this) {
      _isDisposed = true;
      _instance = null;
    }
    super.dispose();
  }

  bool _isLoadingSupportedNetworks = false;
  bool get isLoadingSupportedNetworks => _isLoadingSupportedNetworks;

  Future<void> getSupportedNetworks() async {
    if (_isLoadingSupportedNetworks) return;

    _isLoadingSupportedNetworks = true;
    notifyListeners();

    try {
      _supportedNetworks = await _tatumService.getSupportedNetworks();
      // Try to get popular tokens data for ethereum-mainnet
      final popularTokensData = await _tatumService.getPopularTokens(
        chain: 'ethereum-mainnet',
      );
      if (popularTokensData.isNotEmpty) {
        // Parse and store popular tokens with icons
        await _parseAndStorePopularTokens(popularTokensData);

        logger.d(
          'Popular tokens data retrieved: ${_popularTokens.length} tokens',
        );
      }

      notifyListeners();
    } catch (e) {
      logger.e('Error fetching supported networks: $e');
      setError(e);
    } finally {
      _isLoadingSupportedNetworks = false;
      notifyListeners();
    }
  }

  /// Parse and store popular tokens from Tatum API response
  Future<void> _parseAndStorePopularTokens(
    Map<String, dynamic> popularTokensData,
  ) async {
    _popularTokens.clear();

    try {
      // Handle different response formats
      List<dynamic> tokensList = [];

      if (popularTokensData.containsKey('data') &&
          popularTokensData['data'] is List) {
        tokensList = popularTokensData['data'] as List<dynamic>;
      } else if (popularTokensData.containsKey('tokens') &&
          popularTokensData['tokens'] is List) {
        tokensList = popularTokensData['tokens'] as List<dynamic>;
      } else if (popularTokensData.containsKey('items') &&
          popularTokensData['items'] is List) {
        tokensList = popularTokensData['items'] as List<dynamic>;
      }

      // First pass: collect all tokens with basic info
      final List<Map<String, dynamic>> tokensToProcess = [];
      for (var token in tokensList) {
        if (token is Map<String, dynamic>) {
          final tokenName = (token['name'] ?? token['symbol'] ?? '').toString();
          final tokenSymbol =
              (token['symbol'] ?? token['name'] ?? '').toString();
          final coingeckoId =
              (token['coingeckoId'] ?? token['coingecko_id'] ?? '').toString();

          // Get icon from Tatum response first
          String iconUrl =
              (token['logo'] ?? token['image'] ?? token['icon'] ?? '')
                  .toString();

          tokensToProcess.add({
            'tokenName': tokenName,
            'tokenSymbol': tokenSymbol,
            'coingeckoId': coingeckoId,
            'iconUrl': iconUrl,
            'tokenAddress':
                (token['address'] ?? token['tokenAddress'] ?? '').toString(),
            'decimals':
                (token['decimals'] is int) ? token['decimals'] as int : 18,
          });
        }
      }

      // Second pass: fetch missing icons in parallel
      final List<Future<void>> iconFutures = [];
      for (var tokenData in tokensToProcess) {
        final currentIconUrl = tokenData['iconUrl'].toString();
        if (currentIconUrl.isEmpty) {
          final coingeckoId = tokenData['coingeckoId'].toString();
          final symbol = tokenData['tokenSymbol'].toString();
          final tokenName = tokenData['tokenName'].toString();

          if (coingeckoId.isNotEmpty) {
            iconFutures.add(
              _getTokenIconFromCoinGecko(coingeckoId, symbol)
                  .then((icon) {
                    if (icon.isNotEmpty) {
                      tokenData['iconUrl'] = icon;
                      logger.d(
                        '✅ Fetched icon for $tokenName ($symbol): $icon',
                      );
                    } else {
                      logger.w(
                        '⚠️ No icon found for $tokenName ($symbol) with coingeckoId: $coingeckoId',
                      );
                    }
                  })
                  .catchError((e) {
                    logger.e(
                      '❌ Error fetching icon for $tokenName ($symbol): $e',
                    );
                  }),
            );
          } else if (symbol.isNotEmpty) {
            iconFutures.add(
              _getTokenIconBySymbol(symbol)
                  .then((icon) {
                    if (icon.isNotEmpty) {
                      tokenData['iconUrl'] = icon;
                      logger.d(
                        '✅ Fetched icon for $tokenName ($symbol) by symbol: $icon',
                      );
                    } else {
                      logger.w(
                        '⚠️ No icon found for $tokenName ($symbol) by symbol search',
                      );
                    }
                  })
                  .catchError((e) {
                    logger.e(
                      '❌ Error fetching icon for $tokenName ($symbol) by symbol: $e',
                    );
                  }),
            );
          } else {
            logger.w('⚠️ No coingeckoId or symbol for token: $tokenName');
          }
        } else {
          final tokenName = tokenData['tokenName'].toString();
          logger.d('ℹ️ Token $tokenName already has icon: $currentIconUrl');
        }
      }

      // Wait for all icon fetches to complete
      logger.d('🔄 Fetching icons for ${iconFutures.length} tokens...');
      await Future.wait(iconFutures);
      logger.d('✅ Icon fetching completed');

      // Third pass: build final token list
      int tokensWithIcons = 0;
      for (var tokenData in tokensToProcess) {
        final iconUrl = tokenData['iconUrl'].toString();
        if (iconUrl.isNotEmpty) {
          tokensWithIcons++;
        }
        _popularTokens.add(<String, dynamic>{
          'chain': 'ethereum',
          'name': tokenData['tokenName'].toString(),
          'short_name': tokenData['tokenSymbol'].toString(),
          'displayName': tokenData['tokenName'].toString(),
          'token_address': tokenData['tokenAddress'].toString(),
          'icon': iconUrl,
          'decimals': tokenData['decimals'] as int,
          'coingecko_id': tokenData['coingeckoId'].toString(),
          'test': false,
        });
      }

      logger.d(
        '✅ Parsed ${_popularTokens.length} popular tokens, ${tokensWithIcons} with icons',
      );
      notifyListeners();
    } catch (e) {
      logger.e('Error parsing popular tokens: $e');
    }
  }

  /// Get token icon URL from CoinGecko using coingecko_id
  Future<String> _getTokenIconFromCoinGecko(
    String coingeckoId,
    String symbol,
  ) async {
    try {
      if (coingeckoId.isEmpty) return '';

      // First, try to get from CoinGecko API
      final response = await _web3Service.getTokenDetails(coingeckoId);
      if (response.isNotEmpty) {
        // CoinGecko API returns 'image' field with full URL
        if (response.containsKey('image')) {
          final imageUrl = response['image']?.toString() ?? '';
          if (imageUrl.isNotEmpty) {
            // Ensure we use the small version for better performance
            if (imageUrl.contains('/large/')) {
              return imageUrl.replaceAll('/large/', '/small/');
            } else if (imageUrl.contains('/small/')) {
              return imageUrl;
            } else if (imageUrl.contains('assets.coingecko.com')) {
              // Already a CoinGecko URL, return as is
              return imageUrl;
            }
            // If it's a CoinGecko URL but doesn't have /large/ or /small/, add /small/
            if (imageUrl.contains('assets.coingecko.com/coins/images/')) {
              // Extract the path and ensure it uses /small/
              final uri = Uri.parse(imageUrl);
              final pathParts = uri.path.split('/');
              if (pathParts.length >= 4 &&
                  pathParts[3] != 'small' &&
                  pathParts[3] != 'large') {
                // Insert 'small' before the filename
                final newPath =
                    '/${pathParts.sublist(1, 3).join('/')}/small/${pathParts.last}';
                return '${uri.scheme}://${uri.host}$newPath';
              }
            }
            return imageUrl;
          }
        }
      }

      // Fallback: Try searching by symbol if API call didn't work
      if (symbol.isNotEmpty) {
        return await _getTokenIconBySymbol(symbol);
      }
    } catch (e) {
      logger.d('Error fetching icon for $coingeckoId: $e');
      // Fallback to symbol search on error
      if (symbol.isNotEmpty) {
        return await _getTokenIconBySymbol(symbol);
      }
    }
    return '';
  }

  /// Get token icon by searching CoinGecko with symbol
  Future<String> _getTokenIconBySymbol(String symbol) async {
    try {
      if (symbol.isEmpty) return '';

      // Use CoinGecko search API
      final searchUrl = 'https://api.coingecko.com/api/v3/search?query=$symbol';
      final response = await _tatumService.client
          .get(Uri.parse(searchUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic> && decoded.containsKey('coins')) {
          final coins = decoded['coins'] as List;
          if (coins.isNotEmpty) {
            // Find the best match (exact symbol match first)
            Map<String, dynamic>? bestMatch;
            for (var coin in coins) {
              if (coin is Map<String, dynamic>) {
                final coinSymbol =
                    (coin['symbol'] ?? '').toString().toLowerCase();
                if (coinSymbol == symbol.toLowerCase()) {
                  bestMatch = coin;
                  break;
                }
              }
            }

            // If no exact match, use the first one
            bestMatch ??= coins.first as Map<String, dynamic>;

            // CoinGecko search API returns 'thumb' (small) and 'large' URLs directly
            final thumb = bestMatch['thumb']?.toString() ?? '';
            final large = bestMatch['large']?.toString() ?? '';

            // Prefer thumb (small) or convert large to small
            if (thumb.isNotEmpty) {
              return thumb;
            } else if (large.isNotEmpty) {
              // Convert large to small version
              return large.replaceAll('/large/', '/small/');
            }

            // If no direct URLs, try to get coin ID and fetch details
            final coinId = bestMatch['id']?.toString() ?? '';
            if (coinId.isNotEmpty) {
              return await _getTokenIconFromCoinGecko(coinId, symbol);
            }
          }
        }
      }
    } catch (e) {
      logger.d('Error searching icon for $symbol: $e');
    }
    return '';
  }

  int get totalScore {
    var result = 0;

    for (var score in scores) {
      result += (score.bonus ?? 0);
    }
    return result;
  }

  double availableXP = 0;

  // int get availableXP {
  //   return totalScore - transferXpToInsoValues[0].toInt();
  //   // return 5000;
  // }

  bool _isLoadingScore = false;
  bool get isLoadingScore => _isLoadingScore;
  set isLoadingScore(bool f) {
    _isLoadingScore = f;
    notifyListeners();
  }

  bool _isInitLoading = false;
  bool get isInitLoading => _isInitLoading;
  set isInitLoading(bool f) {
    _isInitLoading = f;
    notifyListeners();
  }

  final Set<Map<String, dynamic>> _selectedItems = {};
  Set<Map<String, dynamic>> get selectedItems => _selectedItems;

  final Map<String, Map<String, dynamic>> chartRanges = {
    "1H": {"interval": "1m", "limit": 61},
    "1D": {"interval": "15m", "limit": 97},
    "1W": {"interval": "1h", "limit": 169},
    "1M": {"interval": "4h", "limit": 200},
    "3M": {"interval": "12h", "limit": 200},
  };

  List<Map<String, dynamic>> get chartRangesList =>
      chartRanges.entries.map<Map<String, dynamic>>((entry) {
        return {
          "label": entry.key,
          "interval": entry.value["interval"],
          "limit": entry.value["limit"],
        };
      }).toList();

  String _selectedChartRange = "1H";
  String get selectedChartRange => _selectedChartRange;
  set selectedChartRange(String s) {
    _selectedChartRange = s;
    notifyListeners();
  }

  final Map<String, String> priceData = {
    "1H": "Price data for 1 Hour",
    "1D": "Price data for 1 Day",
    "1W": "Price data for 1 Week",
    "1M": "Price data for 1 Month",
    "3M": "Price data for 3 Months",
  };

  void selectChartRange(String tab) {
    _selectedChartRange = tab;
    notifyListeners();
  }

  bool showingMarketData = true;

  void toggleShowMarketData() {
    showingMarketData = !showingMarketData;
    notifyListeners();
  }

  String get currentChartData => priceData[_selectedChartRange] ?? "No data";

  void toggleSelection(Map<String, dynamic> item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    reownService = locator<ReownService>();
    setBusy(true);

    // Load imported tokens first
    await loadImportedTokens();
    await getSupportedNetworks();
    print('Supported networks: ${supportedNetworks.length}');
    print(
      'Supported networks: ${supportedNetworks.map((e) => e["chain"]).toList()}',
    );
    await Future.wait([
      _web3Service.getChainBalances(address!),

      _web3Service.getPrices(),
      _web3Service.getTransactions(address!),
      getTransfers(),
      getUserScore(),
    ]);

    // Fetch prices for imported/custom tokens using CoinGecko
    await _fetchPricesForImportedTokens();

    getAvailableXP();
    totalBalance = 0;
    allBalances!.forEach((token, balance) {
      final price = allPrices![token];
      if (price != null) {
        final value = balance * price;
        tokenValues[token] = value;
        totalBalance += value;
      }
    });

    // Also calculate values for custom tokens
    for (var token in enabledNetworks) {
      if (token["isCustom"] == true) {
        final chain = token["chain"]?.toString() ?? '';
        final coingeckoId = token["coingecko_id"]?.toString() ?? '';
        final shortName = token["short_name"]?.toString() ?? '';

        // Try to get price using coingecko_id or short_name
        double? price;
        if (coingeckoId.isNotEmpty) {
          // Look for price by coingecko_id in allPrices
          // We might have stored it with a different key
          price = _getPriceForToken(coingeckoId, shortName);
        } else if (shortName.isNotEmpty) {
          price = _getPriceForToken(shortName, '');
        }

        if (price != null && price > 0) {
          final balance = allBalances?[chain] ?? 0.0;
          final value = balance * price;
          // Store price in allPrices if not already there
          if (allPrices != null && !allPrices!.containsKey(chain)) {
            allPrices![chain] = price;
          }
          tokenValues[chain] = value;
          totalBalance += value;
        }
      }
    }
    // transactions = await getTransactions(cryptoService.privateKey!.address.hex);
    notifyListeners();
    allBalances!["xp"] = availableXP;

    // Log balances and prices for debugging
    final ethBalance = allBalances!["ethereum"] ?? 0;
    final usdtBalance = allBalances!["usdt"] ?? 0;
    final xrpBalance = allBalances!["xrp"] ?? 0;
    logger.d("ETH Balance: $ethBalance ETH");
    logger.d("ETH Price: ${allPrices!["ethereum"] ?? 0} USD");
    logger.d("ETH Value: ${tokenValues["ethereum"] ?? 0} USD");
    logger.d("USDT Balance: $usdtBalance USDT");
    logger.d("USDT Price: ${allPrices!["usdt"] ?? 0} USD");
    logger.d("USDT Value: ${tokenValues["usdt"] ?? 0} USD");
    logger.d("XRP Balance: $xrpBalance XRP");
    logger.d("XRP Price: ${allPrices!["xrp"] ?? 0} USD");
    logger.d("XRP Value: ${tokenValues["xrp"] ?? 0} USD");

    setBusy(false);
  }

  Future<void> getTransfers() async {
    isInitLoading = true;
    try {
      _transfers.clear();
      var t = await transferService.getTransfers(user!.id!);
      _transfers.addAll(t);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isInitLoading = false;
    }
  }

  Future<void> onClickActions(int index) async {
    switch (index) {
      case 0:
        await Routers.goToWalletSendOnePage(context);
        break;
      case 1:
        await Routers.goToWalletReceivePage(context);
        break;
      case 2:
        await Routers.goToWalletSwapPage(context);
        getTransfers();
        break;
      case 3: // go to the serch page
        await Routers.goToWalletSearchPage(context);
        break;
    }
  }

  Future<void> onClickSend() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {} catch (e) {
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  Future<void> getUserScore() async {
    _isLoadingScore = true;
    try {
      _scores.clear();
      var s = await tastScoreService.getScoresByUser(AuthHelper.user!.id!);
      _scores.addAll(s);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isLoadingScore = false;
    }
  }

  Future<Map<String, dynamic>> getDisplayData(TransactionModel tx) async {
    try {
      Map<String, dynamic> token = kWalletTokenList.firstWhere(
        (one) => one["chain"] == tx.chain!,
        orElse: () => {},
      );
      token["from_address"] = tx.from_address;
      token["to_address"] = tx.to_address;
      token["amount"] = tx.amount;
      await Future.delayed(Duration(seconds: 0));
      return token;
    } catch (e) {
      return {};
    }
  }

  void handleClickFavorites(BuildContext ctx) {
    Routers.goToFavoritesPage(ctx);
  }

  Future<void> toggleFavorite(String network) async {
    String message = "";
    var tokens = (AuthHelper.user?.favoriteTokens ?? []).toList();
    try {
      if (tokens.contains(network)) {
        tokens.remove(network);
        message = "successfully removed $network from favorites";
      } else {
        tokens.add(network);
        message = "successfully added $network to favorites";
      }
      UserModel newUser = user!.copyWith(favoriteTokens: tokens);
      await AuthHelper.updateUser(newUser);
    } catch (e) {
      message =
          "Failed to ${tokens.contains(network) ? 'remove' : 'add'} $network to favorites.";
      logger.d("Exception raised while toggle favorites ${e.toString()}");
    }
    AIHelpers.showToast(msg: message);
    notifyListeners();
  }

  bool checkFavorite(String network) {
    return AuthHelper.user?.favoriteTokens?.contains(network) == true;
  }

  handleClickFavoriteToken(BuildContext ctx, Map<String, dynamic> network) {
    if (network["binance_id"].isEmpty) {
      AIHelpers.showToast(msg: "No details for this token.");
      return;
    }
    Routers.goToTokenDetailPage(ctx, network);
  }
}
