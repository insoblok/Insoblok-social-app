import 'dart:async';

import 'package:flutter/material.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
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
  int get currentPage => _currentPage;

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

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }
  
  final globals = GlobalStore();
  bool get enabled => globals.isVybeCamEnabled;

  Future<void> init(BuildContext context) async {
    this.context = context;


    logger.d("vybeCamEnabled in login: $enabled");

    _reownService = locator<ReownService>();
    await _reownService.init(context);

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

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();

    super.dispose();
  }

  Future<void> login() async {
    if (isClickWallet) return;
    clearErrors();

    isClickWallet = true;
    try {
      await reownService.connect();
      if (reownService.isConnected) {
        logger.d(reownService.walletAddress);

      
        var authUser = await AuthHelper.signIn(
          reownService.walletAddress!,
          isCheckScan,
        );

        logger.d("authUser : $authUser");
        
        if (authUser?.walletAddress?.isEmpty ?? true) {
          Routers.goToRegisterFirstPage(
            context,
            user: UserModel(walletAddress: reownService.walletAddress!),
          );
        } else {

          globals.isVybeCamEnabled = isCheckScan;
          await globals.save();

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

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> googleSignin() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await AuthHelper.signInWithGoogle();
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
