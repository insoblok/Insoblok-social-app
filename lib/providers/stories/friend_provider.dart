import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class FriendProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    fetchData();
  }

  final List<UserModel?> userList = [];

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var value = await userService.getAllUsers();
        if (value.isNotEmpty) {
          userList.clear();
          userList.addAll(value);
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {}
  }
}
