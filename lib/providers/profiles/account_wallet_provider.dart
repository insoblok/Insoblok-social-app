import 'package:flutter/material.dart';

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


  double get totalBalance => balanceInso / 500 + balanceUsdt;

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

    getTransfers();
    getUserScore();
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
        await onClickSend();
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
}
