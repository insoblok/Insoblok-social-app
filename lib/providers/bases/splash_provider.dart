import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';

class SplashProvider extends ReactiveViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late ReownService _reownService;
  ReownService get reownService => _reownService;

  bool _isClickWallet = false;
  bool get isClickWallet => _isClickWallet;
  set isClickWallet(bool f) {
    _isClickWallet = f;
    notifyListeners();
  }

  bool _isCheckScan = true;
  bool get isCheckScan => _isCheckScan;
  set isCheckScan(bool f) {
    _isCheckScan = f;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    await FirebaseHelper.init();
    AuthHelper.service.init();
    await NetworkHelper.service.init();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
    // CryptoHelper.service.init();

    _reownService = locator<ReownService>(); // ✅ assign to class field
    await _reownService.init(context);

    // login();
    Routers.goToLoginPage(context);
    // Routers.goToMainPage(context);
  }

  Future<void> login() async {
    try {
      await reownService.connect();

      logger.d("reownService.isConnected : ${reownService.isConnected}");

      if (reownService.isConnected) {

        logger.d("reownService.walletAddress : ${reownService.walletAddress}");

        var authUser = await AuthHelper.signIn(
          reownService.walletAddress!,
          isCheckScan,
        );

        if (authUser?.walletAddress?.isEmpty ?? true) {
          Routers.goToRegisterFirstPage(
            context,
            user: UserModel(walletAddress: reownService.walletAddress!),
          );
        } else {
          AuthHelper.updateStatus('Online');
          Routers.goToMainPage(context);
        }
      } else {
        setError('Failed wallet connected!');
      }
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isClickWallet = false;
    }
  }
}
