import 'package:flutter/foundation.dart';
import 'dart:async';
import '../services/tatum_service.dart';
import '../models/token_model.dart';

class TokenProvider with ChangeNotifier {
  TokenProvider({TatumService? tatumService})
      : _tatumService = tatumService ?? TatumService();

  final TatumService _tatumService;
  final int _pollSeconds = 60;

  bool _initialized = false;
  List<Token> _tokens = [];
  bool _isLoading = false;
  bool _isFetching = false;
  String _error = '';
  Timer? _pollingTimer;
  String _dataSource = 'Initializing…';
  bool _usingTatumApi = false;

  List<Token> get tokens => _tokens;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get dataSource => _dataSource;
  bool get usingTatumApi => _usingTatumApi;

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> initializeTokens() async {

     if (_initialized) return;
    _initialized = true;
    
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _tokens = [
        Token(symbol: 'BTC', name: 'Bitcoin',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/1/small/bitcoin.png'),
        Token(symbol: 'ETH', name: 'Ethereum',     price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/279/small/ethereum.png'),
        Token(symbol: 'SOL', name: 'Solana',       price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/4128/small/solana.png'),
        Token(symbol: 'BNB', name: 'Binance Coin', price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png'),
        Token(symbol: 'XRP', name: 'Ripple',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png'),
        Token(symbol: 'DOGE', name: 'Dogecoin',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/5/small/dogecoin.png'),
      ];

      await _refreshDataSourceFlag();
      await fetchPrices();

      _startPolling();
    } catch (e) {
      _error = 'Initialization failed: $e';
      _initializeWithMockData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPrices() async {
    if (_isFetching) return; // avoid overlapping polls
    _isFetching = true;
    try {
      await _refreshDataSourceFlag();

      _tokens = [
        Token(symbol: 'BTC', name: 'Bitcoin',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/1/small/bitcoin.png'),
        Token(symbol: 'ETH', name: 'Ethereum',     price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/279/small/ethereum.png'),
        Token(symbol: 'SOL', name: 'Solana',       price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/4128/small/solana.png'),
        Token(symbol: 'BNB', name: 'Binance Coin', price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png'),
        Token(symbol: 'XRP', name: 'Ripple',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png'),
        Token(symbol: 'DOGE', name: 'Dogecoin',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/5/small/dogecoin.png'),
      ];

      final symbols = _tokens.map((t) => t.symbol).toList();
      final prices = await _tatumService.getTokenPrices(symbols);

      if (prices.isEmpty) {
        _setRealisticMockPrices();
        _dataSource = 'Demo Data (API Unavailable)';
        _error = 'No live prices available.';
      } else {
        for (var token in _tokens) {
          final v = prices[token.symbol];
          if (v != null) {
            token
              ..price = v
              ..lastUpdated = DateTime.now();
          }
        }
        _error = '';
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to update prices: $e';
      _setRealisticMockPrices();
      _dataSource = 'Demo Data (API Unavailable)';
      notifyListeners();
    } finally {
      _isFetching = false;
    }
  }

  void manualRefresh() {
    _error = '';
    fetchPrices();
  }

  // --------------- helpers ---------------

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: _pollSeconds), (_) {
      fetchPrices();
    });
  }

  Future<void> _refreshDataSourceFlag() async {
    final ok = await _tatumService.testTatumApiKey();
    _usingTatumApi = ok;
    _dataSource = 'My Favorite Tokens';
  }

  void _initializeWithMockData() {
    _tokens = [
        Token(symbol: 'BTC', name: 'Bitcoin',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/1/small/bitcoin.png'),
        Token(symbol: 'ETH', name: 'Ethereum',     price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/279/small/ethereum.png'),
        Token(symbol: 'SOL', name: 'Solana',       price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/4128/small/solana.png'),
        Token(symbol: 'BNB', name: 'Binance Coin', price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/825/small/bnb-icon2_2x.png'),
        Token(symbol: 'XRP', name: 'Ripple',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/44/small/xrp-symbol-white-128.png'),
        Token(symbol: 'DOGE', name: 'Dogecoin',      price: 0.0, lastUpdated: DateTime.now(), image :'https://assets.coingecko.com/coins/images/5/small/dogecoin.png'),
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
