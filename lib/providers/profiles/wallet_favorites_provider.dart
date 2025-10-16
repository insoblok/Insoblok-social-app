import 'package:flutter/material.dart';
import 'package:observable_ish/observable_ish.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';


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
    return await web3service.getFavoriteTokensByIds(AuthHelper.user?.favoriteTokens ?? []);
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    tokens = await web3service.getAvailableTokenIds();
    logger.d("initial tokens are $tokens");
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
      }
      else {
        tokens.add(network);
        message = "successfully added $network to favorites";
      }
      
      UserModel newUser = user!.copyWith(favoriteTokens: tokens);
      await AuthHelper.updateUser(newUser);
    } catch (e) {
      message = "Failed to ${tokens.contains(network) ? 'remove' : 'add' } $network to favorites.";
      logger.d("Exception raised while toggle favorites ${e.toString()}");
    }
    AIHelpers.showToast(msg: message);
    // notifyListeners();
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
      }
      else {
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
    await AIHelpers.confirmRequest(ctx, () async {
      bool result = await web3service.removeFavoriteTokens(AuthHelper.user?.id ?? "", selectedTokens);
        if (result) {
          (await favoriteTokens).removeWhere((element) => selectedTokens.contains(element["id"]));
          selectedTokens.clear();
          isSelectMode = false;
          notifyListeners();
          AIHelpers.showToast(msg: "Successfully removed tokens from favorites");     
        }   
        else {
          AIHelpers.showToast(msg: "Failed to remove tokens from favorites");
        }
    }, confirmText: "Delete", content: "Really want to remove these tokens from favorites");
    
  }

  void clearSelection() {
    selectedTokens.clear();
    isSelectMode = false;
    notifyListeners();
  }

}