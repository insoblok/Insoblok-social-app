import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';
class WalletReceiveProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }


  Future<void> init(BuildContext context) async {
    this.context = context;
  }
  final Web3Service _web3service = locator<Web3Service>();

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

  
}
