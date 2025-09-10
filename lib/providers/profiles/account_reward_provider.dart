import 'dart:math';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';

class AccountRewardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? u) {
    _owner = u;
    notifyListeners();
  }

  final Web3Service _web3service = locator<Web3Service>();

  void init(BuildContext context, UserModel? user) async {
    this.context = context;
    _owner = user ?? AuthHelper.user;

    fetchData();
  }

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await getUserScore();
        await getUsersScoreList();
        await getTransfers();
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  final List<TastescoreModel> _scores = [];
  List<TastescoreModel> get scores =>
      _scores..sort((b, a) => a.timestamp!.difference(b.timestamp!).inSeconds);

  int get totalScore {
    var result = 0;

    for (var score in scores) {
      result += (score.bonus ?? 0);
    }
    return result;
  }

  int get availableXP {
    return totalScore - transferValues[0].toInt();
    // return 5000;
  }

  int get todayScore {
    var result = 0;
    var today = kDateCounterFormatter.format(DateTime.now());
    var year = DateTime.now().year;

    for (var score in scores) {
      var scoreDay = kDateCounterFormatter.format(score.timestamp!);
      var scoreYear = score.timestamp!.year;
      if (today == scoreDay && year == scoreYear) {
        result += (score.bonus ?? 0);
      }
    }
    return result;
  }

  List<UserLevelModel> get userLevels =>
      AppSettingHelper.appSettingModel?.userLevel ?? [];

  UserLevelModel get userLevel {
    for (var userLevel in userLevels) {
      if ((userLevel.min ?? 0) <= totalScore &&
          totalScore < (userLevel.max ?? 1000000000)) {
        return userLevel;
      }
    }
    return userLevels.first;
  }

  double get indicatorValue {
    var min = userLevel.min ?? 0;
    var max = userLevel.max ?? 0;
    return (totalScore - min) / (max - min);
  }

  bool _isLoadingScore = false;
  bool get isLoadingScore => _isLoadingScore;
  set isLoadingScore(bool f) {
    _isLoadingScore = f;
    notifyListeners();
  }

  XpInSoModel? _selectXpInSo;
  XpInSoModel? get selectXpInSo => _selectXpInSo;
  set selectXpInSo(XpInSoModel? model) {
    _selectXpInSo = model;
    notifyListeners();
  }

  var textController = TextEditingController();

  Future<void> getUserScore() async {
    _isLoadingScore = true;
    try {
      _scores.clear();
      var s = await tastScoreService.getScoresByUser(owner!.id!);
      _scores.addAll(s);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isLoadingScore = false;
    }
  }

  Future<void> getUserRank() async {}

  final List<UserScoreModel> _usersScoreList = [];
  List<UserScoreModel> get usersScoreList => _usersScoreList;

  List<UserScoreModel> get userTotalScores =>
      _usersScoreList.sorted((b, a) => a.xpTotal - b.xpTotal).toList();

  int _userRank = 0;
  int get userRank => _userRank;
  set userRank(int f) {
    _userRank = f;
    notifyListeners();
  }

  double get rankIndicatorValue {
    return userRank / 100;
  }

  Future<void> getUsersScoreList() async {
    try {
      var scores = await tastScoreService.getScoreList();
      var newMap = groupBy(scores, (obj) => obj.userId);

      for (var key in newMap.keys) {
        if (key != null) {
          var score = UserScoreModel(id: key, scores: newMap[key] ?? []);
          _usersScoreList.add(score);
        }
      }
      var userRankIndex = 0;
      for (int i = 0; i < userTotalScores.length; i++) {
        if (userTotalScores[i].id == owner!.id) {
          userRankIndex = i;
          break;
        }
      }
      userRank =
          ((userTotalScores.length - userRankIndex) *
                  100 /
                  userTotalScores.length)
              .toInt();
    } catch (e) {
      logger.e(e);
      setError(e);
    } finally {
      notifyListeners();
    }
  }

  final List<TransferModel> _transfers = [];

  List<double> get transferValues =>
      transferService.getXpToInsoBalance(_transfers);

  List<double> get transferValues1 =>
      transferService.getInsoToUsdtBalance(_transfers);

  bool _isInitLoading = false;
  bool get isInitLoading => _isInitLoading;
  set isInitLoading(bool f) {
    _isInitLoading = f;
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

  Future<void> convertXPtoINSO() async {
    var content = textController.text;
    if (content.isNotEmpty &&
        ((double.tryParse(content) ?? 0) > 0) &&
        isPossibleConvert) {
      if (isBusy) return;
      clearErrors();
      await runBusyFuture(() async {
        try {
          if (AuthHelper.user != null) {
            var xpValue = double.tryParse(content);
            var inSoValue = convertedInSo();
            var model = transferService.getTransferModel(
              fromToken: TransferTokenName.XP,
              toToken: TransferTokenName.INSO,
              from: xpValue ?? 0,
              to: inSoValue,
            );
            await transferService.addTransfer(transfer: model);
            
            // String txHash = await _web3service.transfer("insoblok", cryptoService.privateKey!.address, inSoValue);
            final result = await _web3service.getINSOByXP(xpValue ?? 0, inSoValue, cryptoService.privateKey!.address.hex);

            logger.d("Transaction has is $result");
            // if(txHash.isEmpty) {
            //   setError("Failed to convert your XP.");
            // }
          }
        } catch (e) {
          setError(e);
          logger.e(e);
        } finally {
          textController.text = '';
          selectXpInSo = null;
          xpValue = null;
          isTypingXp = false;
          isPossibleConvert = false;
          notifyListeners();
        }
      }());

      if (hasError) {
        AIHelpers.showToast(msg: modelError.toString());
      } else {
        AIHelpers.showToast(msg: "Successfully converted XP into INSO");
        fetchData();
      }
    }
  }

  String? _xpValue;
  String? get xpValue => _xpValue;
  set xpValue(String? f) {
    _xpValue = f;
    notifyListeners();
  }

  bool _isTypingXp = false;
  bool get isTypingXp => _isTypingXp;
  set isTypingXp(bool f) {
    _isTypingXp = f;
    notifyListeners();
  }

  bool _isPossibleConvert = false;
  bool get isPossibleConvert => _isPossibleConvert;
  set isPossibleConvert(bool f) {
    _isPossibleConvert = f;
    notifyListeners();
  }

  void selectInSo(XpInSoModel? value) {
    if ((value?.max ?? 0) > availableXP) {
      isPossibleConvert = false;
      return;
    }
    isTypingXp = false;
    isPossibleConvert = true;
    selectXpInSo = value;
    xpValue = null;
    textController.text = '${value?.max ?? 0}';
    notifyListeners();
  }

  void setXpValue(String? xp) {
    if (xp == null) return;
    isTypingXp = true;
    if ((int.tryParse(xp) ?? 0) > availableXP) {
      isPossibleConvert = false;
      return;
    }
    selectXpInSo = null;
    isPossibleConvert = true;
    xpValue = xp;
    textController.text = xp;
    notifyListeners();
  }

  double convertedInSo() {
    if (isTypingXp) {
      var xp = double.tryParse(xpValue!) ?? 0;
      var rate = 100;
      for (XpInSoModel inSoModel
          in (AppSettingHelper.appSettingModel?.xpInso ?? [])) {
        if ((xp >= (inSoModel.min ?? 0)) && (xp < (inSoModel.max ?? 0))) {
          rate = inSoModel.rate ?? 0;
        }
      }
      double insoValue = xp / rate;
      return insoValue;
    } else {
      if (selectXpInSo == null) return 0;
      double insoValue = selectXpInSo!.max! * selectXpInSo!.rate! / 100;
      if (insoValue == 0.0) insoValue = 1.0;
      logger.d("insoValues is $insoValue");
      return insoValue;
    }
  }
}
