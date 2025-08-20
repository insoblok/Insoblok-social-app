import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UserListProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(
    BuildContext context, {
    required List<UserModel> users,
  }) async {
    this.context = context;
    selectedUsers = users;
    fetchData();
  }

  List<UserModel> users = [];
  List<UserModel> get showUsers {
    if (_searchKey.isEmpty) return users;
    List<UserModel> result = [];
    for (var user in users) {
      if (user.fullName.toLowerCase().contains(_searchKey.toLowerCase())) {
        result.add(user);
      }
    }
    return result;
  }

  List<UserModel> selectedUsers = [];

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var dbUsers = await userService.getAllUsers();
        for (var user in dbUsers) {
          if (user != null) {
            users.add(user);
          }
        }
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

  String _searchKey = '';
  void updateSearch(String s) {
    _searchKey = s;
    notifyListeners();
  }

  void selected(UserModel user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    notifyListeners();
  }
}
