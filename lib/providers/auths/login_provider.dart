import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class LoginProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late Timer _timer;
  final _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();

    super.dispose();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    _reownService = ReownService(context);
    await _reownService.init();

    FlutterNativeSplash.remove();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });

    notifyListeners();
  }

  bool _isClickWallet = false;
  bool get isClickWallet => _isClickWallet;
  set isClickWallet(bool f) {
    _isClickWallet = f;
    notifyListeners();
  }

  late ReownService _reownService;
  ReownService get reownService => _reownService;

  Future<void> login() async {
    if (isClickWallet) return;
    clearErrors();
    isClickWallet = true;
    try {
      await reownService.connect();
      if (reownService.isConnected) {
        logger.d(reownService.walletAddress);
        await AuthHelper.service.signIn(
          walletAddress: reownService.walletAddress,
        );
      } else {
        setError('Failed wallet connected!');
      }
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      if (AuthHelper.user?.firstName != null) {
        AuthHelper.updateStatus('Online');
        Routers.goToMainPage(context);
      } else {
        Routers.goToRegisterPage(context);
      }
    }
  }

  Future<void> googleSignin() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await AuthHelper.service.signInWithGoogle();
      } catch (e, s) {
        setError(e);
        logger.e(e);
        logger.e(s);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      AuthHelper.updateStatus('Online');
      Routers.goToMainPage(context);
    }
  }
}
