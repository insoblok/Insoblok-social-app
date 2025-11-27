import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/services/access_code_service.dart';

class RegisterSecondProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _user;

  Future<void> init(
    BuildContext context, {
    required UserModel userModel,
  }) async {
    this.context = context;
    _user = userModel;
  }

  void updatePlace(String s) {
    _user = _user.copyWith(placeId: s);
    logger.d("This is updatePlace $s");
    notifyListeners();
  }

  void updateCountry(String s) {
    _user = _user.copyWith(country: s);
    notifyListeners();
  }

  Future<void> onClickRegister() async {
    await FirebaseHelper.signInFirebase();
    if (isBusy) return;
    clearErrors();
    int xpScore = 0;
    if (_user.firstName != null && _user.firstName != '') {
      xpScore = xpScore + 50;
    }
    if (_user.lastName != null && _user.lastName != '') {
      xpScore = xpScore + 50;
    }
    if (_user.country != null &&
        _user.country != '' &&
        _user.city != null &&
        _user.city != '') {
      xpScore = xpScore + 75;
    }
    if (_user.website != null && _user.website != '') {
      xpScore = xpScore + 25;
    }

    await runBusyFuture(() async {
      try {
        await AuthHelper.signUp(_user);
        if (xpScore > 0) await tastScoreService.registerScore(xpScore);

        // Ensure credentials are saved after successful registration
        final globalStore = GlobalStore();
        final savedEmail = await globalStore.getSavedEmail();
        final savedPassword = await globalStore.getSavedPassword();
        if (savedPassword != null && savedPassword.isNotEmpty) {
          await globalStore.saveCredentials(
            email: savedEmail ?? '',
            password: savedPassword,
            enableAutoLogin: true,
          );
        }

        // Check if email is already confirmed before navigating
        final email = _user.email ?? savedEmail ?? '';
        logger.d('Sign up completed. Email: $email, UserId: ${_user.nickId}');

        if (context.mounted) {
          if (email.isNotEmpty) {
            // Check if email access code is already confirmed
            final accessCodeService = AccessCodeService();
            final isEmailConfirmed = await accessCodeService
                .checkAccessCodeByEmail(email);

            if (isEmailConfirmed) {
              // Email already confirmed - skip access code confirm page
              logger.d(
                'Email $email is already confirmed. Skipping access code confirm page.',
              );
              Routers.goToMainPage(context);
            } else {
              // Email not confirmed - navigate to access code confirm page
              Map<String, dynamic> props = {
                'email': email,
                'userId': _user.nickId ?? '',
                'birthday': DateTime.now(), // Default birthday if not available
              };
              logger.d(
                'Navigating to access code confirm page with props: $props',
              );
              Routers.goToAccessCodeConfirmPage(context, props);
            }
          } else {
            logger.w('Email is empty. Navigating to main page.');
            Routers.goToMainPage(context);
          }
        }
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
