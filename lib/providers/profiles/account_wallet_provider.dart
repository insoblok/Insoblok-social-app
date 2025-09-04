import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/utils/const.dart';

class AccountWalletProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

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

  List<Map<String, dynamic>> enabledNetworks = [];
  
  String get networkString => enabledNetworks.length == 1 ? enabledNetworks[0]["displayName"] : "Enabled Networks";
  
  Map<String, double> tokenValues = {};

  double totalBalance = 0;

  List<Map<String, dynamic>> get filteredTransactions {
    if (enabledNetworks.isEmpty) return [];
    
    return transactions?.where((txn) {
      return enabledNetworks.any((network) => 
          network['chain'] == txn['chain']);
    }).toList() ?? [];
  }

  final Web3Service _web3Service = locator<Web3Service>();

  Map<String, double>? get allBalances => _web3Service.allBalances;
  Map<String, double>? get allPrices => _web3Service.allPrices;

  List<Map<String, dynamic>>? get transactions => _web3Service.transactions ?? [];

  @override
  List<ListenableServiceMixin> get listenableServices => [_web3Service];

  String? get address => cryptoService.privateKey!.address.hex;  

  int get totalScore {
      var result = 0;

      for (var score in scores) {
        result += (score.bonus ?? 0);
      }
      return result;
    }
    
  int get availableXP {
    return totalScore - transferXpToInsoValues[0].toInt();
    // return 5000;
  }

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

  Future<void> init(BuildContext context) async {
    this.context = context;

    reownService = locator<ReownService>();
    await Future.wait([
      _web3Service.getBalances(address!),
      _web3Service.getPrices(),
      _web3Service.getTransactions(address!)
    ]);
    allBalances!.forEach((token, balance) {
      final price = allPrices![token];
      if (price != null) {
        final value = balance * price;
        tokenValues[token] = value;
        totalBalance += value;
      }
    });
    logger.d("All balances is $allBalances");
    logger.d("Total balance is $totalBalance");
    // transactions = await getTransactions(cryptoService.privateKey!.address.hex);
    getTransfers();
    getUserScore();
    notifyListeners();
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
        // await onClickSend();
        await Routers.goToWalletSendPage(context);
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
}
