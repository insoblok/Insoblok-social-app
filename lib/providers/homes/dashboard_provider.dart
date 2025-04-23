import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:web3dart/web3dart.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class DashboardProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  String _address = '0x769ae5ed977ee80ef17d14b06a59ff1b1ba52b8f';
  String get address => _address;
  set address(String s) {
    _address = s;
    notifyListeners();
  }

  String _amount = '1';
  String get amount => _amount;
  set amount(String s) {
    _amount = s;
    notifyListeners();
  }

  Future<void> onClickTestDemo() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var balance = await EthereumHelper.getBalance();
        logger.d(balance);
        await EthereumHelper.sendTransaction(
          to: address,
          amount: amount,
          gasPrice: EtherAmount.fromInt(EtherUnit.szabo, 1),
          gasLimit: 1,
        );
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
