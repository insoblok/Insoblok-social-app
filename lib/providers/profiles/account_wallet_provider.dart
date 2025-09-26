import 'dart:async';
import 'package:flutter/material.dart';
import 'package:insoblok/pages/profiles/profiles.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AccountWalletProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
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
    Center(child: WalletFavoritesPage()),
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

  List<String> get networkNames => kWalletTokenList.map((one) => one["chain"].toString()).toList();

  List<Map<String, dynamic>> enabledNetworks = [kWalletTokenList[0], kWalletTokenList[1], kWalletTokenList[3], kWalletTokenList[4]];
  setEnabledNetworks(List<Map<String, dynamic>> nets) {
    enabledNetworks = nets;
    notifyListeners();
  }
  String get networkString => enabledNetworks.length == 1 ? enabledNetworks[0]["displayName"] : "Networks";
  
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
    final filtered = transactions?.where((txn) {
      return enabledNetworks.any((network) {
        if (txn["chain"] != null) {
          return network['chain'] == txn['chain'];
        }
        else {
          return (txn["from_token_network"] == network["chain"] || 
                  txn["to_token_network"] == network["chain"]);
        }
      });
    }).toList() ?? [];
    return filtered;
  }

  final Web3Service _web3Service = locator<Web3Service>();
  final AuthService authService = AuthService();

  Map<String, double>? get allBalances => _web3Service.allBalances;
  Map<String, double>? get allPrices => _web3Service.allPrices;
  Map<String, double>? get allChanges => _web3Service.allChanges;
  List<Map<String, dynamic>>? get transactions => _web3Service.transactions ?? [];

  Map<String, dynamic> tokenDetails = {};

  Future<void> getTokenDetails(String coingecko_id) async {
    if(isBusy) { 
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
  List<ListenableServiceMixin> get listenableServices => [_web3Service];

  String? get address => cryptoService.privateKey!.address.hex;  

  // double get totalBalance => balanceInso / 500 + balanceUsdt;

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
    "1H": {
      "interval": "1m",
      "limit": 61,
    }, 
    "1D": {
      "interval": "15m",
      "limit": 97,
    }, 
    "1W": {
      "interval": "1h",
      "limit": 169,
    }, 
    "1M": {
      "interval": "4h",
      "limit": 200,
    }, 
    "3M": {
      "interval": "12h",
      "limit": 200,
    }
  };

  List<Map<String, dynamic>> get chartRangesList => chartRanges.entries.map<Map<String, dynamic>>((entry) {
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


    await Future.wait([
      _web3Service.getBalances(address!),
      
      _web3Service.getPrices(),
      _web3Service.getTransactions(address!),
      getTransfers(),
      getUserScore(),
    ]);
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
    // transactions = await getTransactions(cryptoService.privateKey!.address.hex);
    notifyListeners();
    allBalances!["xp"] = availableXP;
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
