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
        var req = await reownService.onShowTransferModal(context);
        if (req?.recipientAddress != null) {
          var result = await reownService.ethSendTransaction(req: req!);
          logger.d(result);
        }
      } catch (e) {
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());
  }
}
