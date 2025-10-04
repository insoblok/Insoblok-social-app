import 'package:flutter/material.dart';

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
      AIHelpers.showToast(msg: modelError.toString());
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
      AIHelpers.showToast(msg: modelError.toString());
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
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onClickUpdated() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // if (user?.email?.isEmpty ?? true) {
        //   await FirebaseHelper.convertAnonymousToPermanent(
        //     email: account.email ?? '',
        //     password: account.password ?? '',
        //   );
        // }
        await AuthHelper.updateUser(account);
        Navigator.of(context).pop(true);
      } catch (e) {
        setError(e);
        logger.e("Exception raised while saving profile data $e");
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
    else {
      AIHelpers.showToast(msg: "Saved profile data successfully.");
    }
  }

  void updateSocials(String field, String value) {
    var socials = List<SocialMediaModel>.from(account.socials ?? []);
    final filtered = socials.where((element) => element.media == field).toList();
    if (filtered.isEmpty) {
      socials.add(SocialMediaModel(media: field, account: value));
    }
    else {
      socials.remove(filtered[0]);
    }
    account = account.copyWith(socials: socials);
    logger.d("Updated account is $socials, ${account.socials}");
  }

  void updateBio(String bio) {
    account = account.copyWith(desc: bio);
  }

  void updateFirstName(String fName) {
    account = account.copyWith(firstName: fName);
  }

  void updateLastName(String lName) {
    account = account.copyWith(lastName: lName);
  }

  void updateLocation(String location) {

  }

  void updateWebsite(String url) {
    account = account.copyWith(website: url);
  }



}
