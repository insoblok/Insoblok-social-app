import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class WalletReceiveProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  var sendTokenTextController = TextEditingController();
  var receiverTextController = TextEditingController();

  Future<void> init(BuildContext context) async {
    this.context = context;
    getTransfers();
  }

  final List<TransferModel> _transfers = [];

  List<double> get transferXpToInsoValues =>
      transferService.getXpToInsoBalance(_transfers);

  List<double> get transferInsoToUsdtValues =>
      transferService.getInsoToUsdtBalance(_transfers);

  double get balanceInso =>
      transferXpToInsoValues[1] - transferInsoToUsdtValues[0];
  double get balanceUsdt => transferInsoToUsdtValues[1];

  double _availableValue = 0;
  double get availableValue => _availableValue;
  set availableValue(double f) {
    _availableValue = f;
    notifyListeners();
  }

  Map<String, double> _balances = {};
  Map<String, double> get balances => _balances;
  void setBalances(Map<String, double> newBalances) {
    _balances = newBalances;
    notifyListeners();
  }

  double getBalance(String chain) {
    return _balances[chain] ?? 0.0;
  }

  bool _isInitLoading = false;
  bool get isInitLoading => _isInitLoading;
  set isInitLoading(bool f) {
    _isInitLoading = f;
    notifyListeners();
  }

  int _selectedFromToken = 0;
  int get selectedFromToken => _selectedFromToken;
  set selectedFromToken(int f) {
    _selectedFromToken = f;
    notifyListeners();
  }

  int _selectedToToken = 0;
  int get selectedToToken => _selectedToToken;
  set selectedToToken(int f) {
    _selectedToToken = f;
    notifyListeners();
  }

  double _convertRate = 0.0;
  double get convertRate => _convertRate;
  set convertRate(double f) {
    _convertRate = f;
    notifyListeners();
  }

  bool _isPossibleConvert = false;
  bool get isPossibleConvert => _isPossibleConvert;
  set isPossibleConvert(bool f) {
    _isPossibleConvert = f;
    notifyListeners();
  }

  void selectFromToken(int index) {
    selectedFromToken = index;
    switch (kWalletTokenList[index]['name']) {
      case 'INSO':
        availableValue = balances["inso"]!;
        break;
      case 'USDT':
        availableValue = balances["usdt"]!;
        break;
      case 'XRP':
        availableValue = 0;
      case 'eth':
        availableValue = balances["ethereum"]!;
      case 'seth':
        availableValue = balances["sepolia"]!;
        break;
    }
    logger.d("Available Value is $availableValue");
    getRate(
      kWalletTokenList[index]['name'].toString(),
      kWalletTokenList[selectedToToken]['name'].toString(),
    );
    if ((double.tryParse(sendTokenTextController.text) ?? 0) > availableValue) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }
    notifyListeners();
  }

  void selectToToken(int index) {
    selectedToToken = index;
    getRate(
      kWalletTokenList[selectedFromToken]['name'].toString(),
      kWalletTokenList[index]['name'].toString(),
    );
    notifyListeners();
  }

  void getRate(String? from, String? to) {
    // for (var rate in kSwapRate) {
    //   if (rate['from'] == from && rate['to'] == to) {
    //     convertRate = rate['rate'] as double;
    //   }
    // }
  }

  void changingSendTokenValue(String? fromToken) {
    if (fromToken == null) return;
    if ((double.tryParse(fromToken) ?? 0) > availableValue ||
        (double.tryParse(fromToken) ?? 0) == 0) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }

    sendTokenTextController.text =
        ((double.tryParse(fromToken) ?? 0) * convertRate).toString();
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
      selectFromToken(0);
    }
  }

  Future<void> sendToken() async {
    if (isBusy) return;
    if (availableValue < double.parse(sendTokenTextController.text.trim())) {
      logger.d("Insufficient balance.");
      AIHelpers.showToast(msg: "Insufficient Token Balance.");
      return;
    }
    clearErrors();

    await runBusyFuture(() async {
      try {
        web3Service.sendEvmToken(receiverTextController.text.trim(), double.parse(sendTokenTextController.text.trim()), kWalletTokenList[selectedFromToken], cryptoService.privateKey!);
        // var model = transferService.getTransferModel(
        //   fromToken: fromToken,
        //   toToken: toToken,
        //   from: (double.tryParse(fromTokenTextController.text) ?? 0),
        //   to: (double.tryParse(toTokenTextController.text) ?? 0),
        // );
        // await transferService.addTransfer(transfer: model);
        AIHelpers.showToast(msg: 'Successfully sent!');
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isPossibleConvert = false;
        sendTokenTextController.text = '0';
        getTransfers();
        notifyListeners();
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
