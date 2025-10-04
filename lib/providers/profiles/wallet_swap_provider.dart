import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';


final kSwapRate = [
  {'from': TransferTokenName.INSO, 'to': TransferTokenName.USDT, 'rate': 0.01},
  {'from': TransferTokenName.INSO, 'to': TransferTokenName.INSO, 'rate': 1.00},
  {'from': TransferTokenName.INSO, 'to': TransferTokenName.XRP, 'rate': 0.05},
  {'from': TransferTokenName.USDT, 'to': TransferTokenName.USDT, 'rate': 1.0},
  {'from': TransferTokenName.USDT, 'to': TransferTokenName.INSO, 'rate': 100.0},
  {'from': TransferTokenName.USDT, 'to': TransferTokenName.XRP, 'rate': 20.0},
  {'from': TransferTokenName.XRP, 'to': TransferTokenName.USDT, 'rate': 0.05},
  {'from': TransferTokenName.XRP, 'to': TransferTokenName.INSO, 'rate': 20.0},
  {'from': TransferTokenName.XRP, 'to': TransferTokenName.XRP, 'rate': 1.00},
];

class WalletSwapProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final Web3Service _web3Service = locator<Web3Service>();
  var fromTokenTextController = TextEditingController();
  var toTokenTextController = TextEditingController();
  
  Map<String, double>? get allBalances => _web3Service.allBalances;
  Map<String, double>? get allPrices => _web3Service.allPrices;
  
  CryptoService cryptoService = locator<CryptoService>();

  String? get address => cryptoService.privateKey!.address.hex;  

  Future<void> init(BuildContext context) async {
    this.context = context;
    setBusy(true);
    getTransfers();
    await Future.wait([
      _web3Service.getBalances(address!),
      _web3Service.getPrices(),
      _web3Service.getTransactions(address!),
    ]);
    allBalances?["xp"] = (accountService.availableXP).toDouble();
    fromTokenTextController.text = (allBalances?["insoblok"] ?? "0").toString();
    toTokenTextController.text = (allBalances?["insoblok"] ?? "0").toString();
    
    notifyListeners(); 
    setBusy(false);
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
      case 'inso':
        availableValue = allBalances!["insoblok"] ?? 0;
        break;
      case 'usdt':
        availableValue = allBalances!["usdt"] ?? 0;
        break;
      case 'xrp':
        availableValue = allBalances!["xrp"] ?? 0;
        break;
      case 'eth':
        availableValue = allBalances!["ethereum"] ?? 0;
        break;
      case 'seth':
        availableValue = allBalances!["sepolia"] ?? 0;
        break;
      case 'xp':
        availableValue = allBalances!["xp"] ?? 0;
        break;
      default:
        break;
    }
    getRate(
      kWalletTokenList[index]['name'].toString(),
      kWalletTokenList[selectedToToken]['name'].toString(),
    );
    if ((double.tryParse(fromTokenTextController.text) ?? 0) > availableValue ||
        (double.tryParse(fromTokenTextController.text) ?? 0) == 0) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }
    fromTokenTextController.text = availableValue.toString();
    toTokenTextController.text =
        ((double.tryParse(fromTokenTextController.text) ?? 0) * convertRate)
            .toStringAsFixed(2);
    notifyListeners();
  }

  void selectToToken(int index) {
    selectedToToken = index;
    getRate(
      kWalletTokenList[selectedFromToken]['name'].toString(),
      kWalletTokenList[index]['name'].toString(),
    );
    if ((double.tryParse(fromTokenTextController.text) ?? 0) > availableValue ||
        (double.tryParse(fromTokenTextController.text) ?? 0) == 0) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }
    toTokenTextController.text =
        ((double.tryParse(fromTokenTextController.text) ?? 0) * convertRate)
            .toStringAsFixed(2);
    notifyListeners();
  }

  void getRate(String? from, String? to) {
    for (var rate in kSwapRate) {
      if (rate['from'] == from && rate['to'] == to) {
        convertRate = rate['rate'] as double;
      }
    }
  }

  void changingFromTokenValue(String? fromToken) {
    if (fromToken == null) return;
    if ((double.tryParse(fromToken) ?? 0) > availableValue ||
        (double.tryParse(fromToken) ?? 0) == 0) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }

    toTokenTextController.text =
        ((double.tryParse(fromToken) ?? 0) * convertRate).toString();
    notifyListeners();
  }

  void changingToTokenValue(String? toToken) {
    if (toToken == null) return;

    var fromTokenValue = ((double.tryParse(toToken) ?? 0) / convertRate)
        .toStringAsFixed(2);
    fromTokenTextController.text = fromTokenValue;
    if ((double.tryParse(fromTokenValue) ?? 0) > availableValue ||
        (double.tryParse(fromTokenValue) ?? 0) == 0) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }

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

  Future<void> convertToken() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var fromToken = kWalletTokenList[selectedFromToken]['name'] ?? 'INSO';
        var toToken = kWalletTokenList[selectedToToken]['name'] ?? 'INSO';
        var model = transferService.getTransferModel(
          fromToken: fromToken.toString(),
          toToken: toToken.toString(),
          from: (double.tryParse(fromTokenTextController.text) ?? 0),
          to: (double.tryParse(toTokenTextController.text) ?? 0),
        );
        await transferService.addTransfer(transfer: model);
        AIHelpers.showToast(msg: 'Successfully converted!');
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isPossibleConvert = false;
        fromTokenTextController.text = '0';
        toTokenTextController.text = '0';
        getTransfers();
        notifyListeners();
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
