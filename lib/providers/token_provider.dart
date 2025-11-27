import 'package:flutter/foundation.dart';
import 'dart:async';
import '../services/price_socket_service.dart';
import '../models/token_model.dart' as tm;

class TokenProvider with ChangeNotifier {
  TokenProvider({PriceSocketService? socketService})
    : _socketService = socketService ?? PriceSocketService();

  final PriceSocketService _socketService;

  bool _initialized = false;
  List<tm.Token> _tokens = [];
  // price-change meta tracked per symbol for UI animations
  final Map<String, int> _directions = {}; // -1, 0, 1
  final Map<String, int> _changeTicks = {};
  final Map<String, double> _previousPrices = {};
  final Map<String, double> _diffs = {};
  bool _isLoading = false;
  String _error = '';
  String _dataSource = 'Initializing…';
  bool _usingTatumApi = false; // repurposed: true when live socket active
  StreamSubscription<PriceUpdate>? _socketSub;

  List<tm.Token> get tokens => _tokens;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get dataSource => _dataSource;
  bool get usingTatumApi => _usingTatumApi;
  Map<String, int> get directions => _directions;
  Map<String, int> get changeTicks => _changeTicks;
  Map<String, double> get diffs => _diffs;

  @override
  void dispose() {
    _socketSub?.cancel();
    _socketService.dispose();
    super.dispose();
  }

  Future<void> initializeTokens() async {
    if (_initialized) return;
    _initialized = true;

    _socketService.enableLogs = true;
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _tokens = [
        tm.Token(
          symbol: 'BTC',
          name: 'Bitcoin',
          price: 0.0,
          lastUpdated: DateTime.now(),
          image:
              'https://assets.coingecko.com/coins/images/1/small/bitcoin.png',
        ),
        tm.Token(
          symbol: 'ETH',
          name: 'Ethereum',
          price: 0.0,
          lastUpdated: DateTime.now(),
          image:
              'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
        ),
        tm.Token(
          symbol: 'SOL',
          name: 'Solana',
          price: 0.0,
          lastUpdated: DateTime.now(),
          image:
              'https://assets.coingecko.com/coins/images/4128/small/solana.png',
        ),
        tm.Token(
          symbol: 'BNB',
          name: 'Binance Coin',
          price: 0.0,
          lastUpdated: DateTime.now(),
          image:
              'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
        ),
        tm.Token(
          symbol: 'XRP',
          name: 'Ripple',
          price: 0.0,
          lastUpdated: DateTime.now(),
          image:
              'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png',
        ),
        tm.Token(
          symbol: 'DOGE',
          name: 'Dogecoin',
          price: 0.0,
          lastUpdated: DateTime.now(),
          image:
              'https://assets.coingecko.com/coins/images/5/small/dogecoin.png',
        ),
      ];

      // start live socket (Binance → fallback to CoinCap internally)
      _usingTatumApi = true;
      _dataSource = 'My Favorite Tokens';
      final syms = _tokens.map((t) => t.symbol).toList();
      _socketSub?.cancel();
      _socketSub = _socketService.updates.listen((tick) {
        if (_socketService.enableLogs) {
          // ignore: avoid_print
          print('[TokenProvider] tick ${tick.symbol} ${tick.price}');
        }
        final idx = _tokens.indexWhere(
          (t) => t.symbol.toUpperCase() == tick.symbol.toUpperCase(),
        );
        if (idx != -1) {
          final token = _tokens[idx];
          final double prev = token.price;
          final double next = tick.price;
          int dir = 0;
          if (prev != 0.0) {
            if (next > prev) {
              dir = 1;
            } else if (next < prev) {
              dir = -1;
            }
          }
          final sym = token.symbol.toUpperCase();
          // Calculate diff using the previous price before updating
          // Use _previousPrices if available (from previous socket update), otherwise use current token.price
          if (_previousPrices.containsKey(sym)) {
            // We have a stored previous price, use it for accurate diff
            _diffs[sym] = next - _previousPrices[sym]!;
          } else if (prev != 0.0) {
            // First update: use current token.price as previous (if not zero)
            _diffs[sym] = next - prev;
          }

          // Update token price and store current price as previous for next update
          token
            ..price = next
            ..lastUpdated = DateTime.now();
          _previousPrices[sym] = next;
          _directions[sym] = dir;
          if (dir != 0) {
            _changeTicks[sym] = (_changeTicks[sym] ?? 0) + 1;
          }
          notifyListeners();
        }
      });
      // ignore: avoid_print
      print('[TokenProvider] connect symbols=$syms fiat=USD');
      await _socketService.connect(syms, fiat: 'USD');
    } catch (e) {
      _error = 'Initialization failed: $e';
      _initializeWithMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void manualRefresh() {
    // no-op: socket pushes in real-time; reconnect to refresh
    _socketService.connect(_tokens.map((t) => t.symbol).toList(), fiat: 'USD');
  }

  // --------------- helpers ---------------

  void _initializeWithMockData() {
    _tokens = [
      tm.Token(
        symbol: 'BTC',
        name: 'Bitcoin',
        price: 0.0,
        lastUpdated: DateTime.now(),
        image: 'https://assets.coingecko.com/coins/images/1/small/bitcoin.png',
      ),
      tm.Token(
        symbol: 'ETH',
        name: 'Ethereum',
        price: 0.0,
        lastUpdated: DateTime.now(),
        image:
            'https://assets.coingecko.com/coins/images/279/small/ethereum.png',
      ),
      tm.Token(
        symbol: 'SOL',
        name: 'Solana',
        price: 0.0,
        lastUpdated: DateTime.now(),
        image:
            'https://assets.coingecko.com/coins/images/4128/small/solana.png',
      ),
      tm.Token(
        symbol: 'BNB',
        name: 'Binance Coin',
        price: 0.0,
        lastUpdated: DateTime.now(),
        image:
            'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png',
      ),
      tm.Token(
        symbol: 'XRP',
        name: 'Ripple',
        price: 0.0,
        lastUpdated: DateTime.now(),
        image:
            'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png',
      ),
      tm.Token(
        symbol: 'DOGE',
        name: 'Dogecoin',
        price: 0.0,
        lastUpdated: DateTime.now(),
        image: 'https://assets.coingecko.com/coins/images/5/small/dogecoin.png',
      ),
    ];
    _dataSource = 'Demo Data (Offline)';
    _usingTatumApi = false;
  }

  void _setRealisticMockPrices() {
    final basePrices = {
      'BTC': 45123.45,
      'ETH': 3245.67,
      'USDT': 1.0,
      'BNB': 567.89,
      'SOL': 123.45,
      'ADA': 0.4567,
      'XRP': 0.5678,
    };

    final random = DateTime.now().millisecond;
    for (var token in _tokens) {
      final base = basePrices[token.symbol];
      if (base != null) {
        final variation = ((random % 100) - 50) / 1000.0; // ±5%
        token
          ..price = base * (1 + variation)
          ..lastUpdated = DateTime.now();
      }
    }
    _usingTatumApi = false;
  }
}
