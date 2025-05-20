import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UpdateProfileProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _account;
  UserModel get account => _account;
  set account(UserModel model) {
    _account = model;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    account = AuthHelper.user ?? UserModel();
  }

  Future<void> onUpdatedAvatar() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountAvatarPage(context);
        if (result != null) {
          account = account.copyWith(avatar: result);
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<void> onUpdatedPublic() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountPublicPage(context);
        if (result != null) {
          account = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<void> onUpdatedPrivate() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountPrivatePage(context);
        if (result != null) {
          account = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<void> onClickUpdated() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (user?.email?.isEmpty ?? true) {
          await FirebaseHelper.convertAnonymousToPermanent(
            email: account.email ?? '',
            password: account.password ?? '',
          );
        }
        await AuthHelper.updateUser(account);
        Fluttertoast.showToast(msg: 'Successfully updated user profile!');
        Navigator.of(context).pop(true);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
