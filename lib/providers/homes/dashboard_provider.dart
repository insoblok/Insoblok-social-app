import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:web3dart/web3dart.dart';

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

  Future<void> onClickTestDemo() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await EthereumHelper.sendTransaction(
          to: '0x',
          amount: '1.0',
          gasPrice: EtherAmount.fromInt(EtherUnit.wei, 1),
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
