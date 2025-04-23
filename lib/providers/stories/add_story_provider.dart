import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:insoblok/providers/providers.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:provider/provider.dart';

class AddStoryProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  var scrollController = ScrollController();
  late UploadMediaProvider provider;

  Future<void> init(BuildContext context) async {
    this.context = context;
    provider = context.read<UploadMediaProvider>();
  }

  Future<void> onClickAddMediaButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await provider.addMedias(context);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {}
  }
}
