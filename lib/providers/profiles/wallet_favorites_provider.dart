import 'package:flutter/material.dart';
import 'dart:async';
import 'package:observable_ish/observable_ish.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/services/price_socket_service.dart';
import 'package:insoblok/utils/utils.dart';
// import 'package:insoblok/locator.dart';

class WalletFavoritesProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final RxValue<int> _viewType = RxValue<int>(0);
  int get viewType => _viewType.value;
  set viewType(int v) {
    _viewType.value = v;
    notifyListeners();
  }

  // ------- live price streaming -------
  final Map<String, double> livePrices = {};
  // -1: down, 0: no change/unknown, 1: up
  final Map<String, int> priceDirections = {};
  // Increments whenever a symbol's price changes; used to restart UI animations.
  final Map<String, int> priceChangeTick = {};
  final PriceSocketService _priceSocket = PriceSocketService();
  StreamSubscription? _priceSub;

  List<String> _tokens = [];
  List<String> get tokens => _tokens;
  set tokens(List<String> tk) {
    _tokens = tk;
    notifyListeners();
  }

  String _query = "";
  String get query => _query;

  bool isSelectMode = false;
  List<String> selectedTokens = [];

  Future<List<Map<String, dynamic>>> get filteredItems async {
    final response = await web3service.searchTokensBySymbol(query, tokens);
    return response;
  }

  Future<List<Map<String, dynamic>>> get favoriteTokens async {
    return await web3service.getFavoriteTokensByIds(
      AuthHelper.user?.favoriteTokens ?? [],
    );
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    tokens = await web3service.getAvailableTokenIds();
    logger.d("initial tokens are $tokens");
    _priceSocket.enableLogs = true;
    await _startFavoritesPriceStream();
  }

  final Web3Service web3service = Web3Service();

  Future<void> handleUpdateQuery(String value) async {
    _query = value;
    notifyListeners();
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
    await _startFavoritesPriceStream(); // rewire stream for new favorites
  }

  bool checkFavorite(String network) {
    return AuthHelper.user?.favoriteTokens?.contains(network) == true;
  }

  void handleTapFavoriteToken(String token) {
    if (isSelectMode) {
      if (selectedTokens.contains(token)) {
        selectedTokens.remove(token);
        if (selectedTokens.isEmpty) {
          isSelectMode = false;
        }
      } else {
        selectedTokens.add(token);
      }
    }
    notifyListeners();
  }

  void handleLongPressFavoriteToken(String token) {
    logger.d("long pressed $token");
    isSelectMode = true;
    selectedTokens.add(token);
    notifyListeners();
  }

  Future<void> handleTapRemoveFavoriteTokens(BuildContext ctx) async {
    await AIHelpers.confirmRequest(
      ctx,
      () async {
        bool result = await web3service.removeFavoriteTokens(
          AuthHelper.user?.id ?? "",
          selectedTokens,
        );
        if (result) {
          (await favoriteTokens).removeWhere(
            (element) => selectedTokens.contains(element["id"]),
          );
          selectedTokens.clear();
          isSelectMode = false;
          notifyListeners();
          AIHelpers.showToast(
            msg: "Successfully removed tokens from favorites",
          );
        } else {
          AIHelpers.showToast(msg: "Failed to remove tokens from favorites");
        }
      },
      confirmText: "Delete",
      content: "Really want to remove these tokens from favorites",
    );
  }

  void clearSelection() {
    selectedTokens.clear();
    isSelectMode = false;
    notifyListeners();
  }

  // ------- socket helpers -------
  Future<void> _startFavoritesPriceStream() async {
    final favs = await favoriteTokens;
    final symbols = <String>[];
    for (final t in favs) {
      final sym = t['symbol'];
      if (sym is String && sym.isNotEmpty) {
        symbols.add(sym.toUpperCase());
      }
    }
    logger.d('[Favorites] Starting price stream for: ${symbols.join(", ")}');
    await _priceSub?.cancel();
    _priceSub = _priceSocket.updates.listen((e) {
      if (_priceSocket.enableLogs) {
        logger.d('[Favorites] tick ${e.symbol} ${e.price}');
      }
      final String sym = e.symbol.toUpperCase();
      final double newPrice = e.price;
      final double? previous = livePrices[sym];
      // Compute direction
      int direction = 0;
      if (previous != null) {
        if (newPrice > previous) {
          direction = 1;
        } else if (newPrice < previous) {
          direction = -1;
        }
      }
      priceDirections[sym] = direction;
      // Increment tick only when price actually changes (avoid restarting animation on equal price)
      if (direction != 0) {
        priceChangeTick[sym] = (priceChangeTick[sym] ?? 0) + 1;
      }
      livePrices[sym] = newPrice;
      notifyListeners();
    });
    await _priceSocket.connect(symbols, fiat: 'USD');
  }

  @override
  void dispose() {
    _priceSub?.cancel();
    _priceSocket.dispose();
    super.dispose();
  }
}
