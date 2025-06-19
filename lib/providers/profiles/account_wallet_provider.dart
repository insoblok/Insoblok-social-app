import 'package:flutter/material.dart';
import 'package:insoblok/locator.dart';
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

  Future<void> init(BuildContext context) async {
    this.context = context;

    reownService = locator<ReownService>();
    logger.d(await reownService.balanceOf);
    logger.d(await reownService.totalSupply);
  }

  Future<void> onClickActions(int index) async {
    logger.d(index);
    switch (index) {
      case 1:
        await onClickSend();
        break;
    }
  }

  Future<void> onClickSend() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // await reownService.ethSignTypedDataV3();
        await reownService.ethSendTransaction(
          recipientAddress: '0xcbf2d61a9b97f0114a270f894a58c7ec364507d6',
          amount: 1,
        );
      } catch (e) {
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());
  }
}
