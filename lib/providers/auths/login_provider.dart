import 'dart:async';

import 'package:flutter/material.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/pages/auths/import_wallet_dialog.dart';


class LoginProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  bool _walletExists = false;
  bool get walletExists => _walletExists;

  String? _storedAddress;
  String? get storedAddress => _storedAddress;

  late Timer _timer;
  final _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  static const loginMethods = ["Login with Password", "Login with Face ID"];

  String _loginMethod = loginMethods[0];
  String get loginMethod => _loginMethod;
  set loginMethod(String s) {
    _loginMethod = s;
    notifyListeners();
  }

  final _existingPasswordController = TextEditingController();
  TextEditingController get existingPasswordController => _existingPasswordController;

  late ReownService _reownService;
  ReownService get reownService => _reownService;

  bool _isClickCreateNewWallet = false;
  bool get isClickCreateNewWallet => _isClickCreateNewWallet;
  set isClickCreateNewWallet(bool f) {
    _isClickCreateNewWallet = f;
    notifyListeners();
  }

  bool _isClickImportWallet = false;
  bool get isClickImportWallet => _isClickImportWallet;
  set isClickImportWallet(bool f) {
    _isClickImportWallet = f;
    notifyListeners();
  }

  bool _isCheckScan = true;
  bool get isCheckScan => _isCheckScan;
  set isCheckScan(bool f) {
    _isCheckScan = f;
    notifyListeners();
  }

  bool isCheckingWallet = true;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  bool processing = false;
  
  final globals = GlobalStore();
  bool get enabled => globals.isVybeCamEnabled;

  bool checkingFace = false;
  LocalAuthService localAuthService = LocalAuthService();

  Future<void> init(BuildContext context) async {
    this.context = context;
    // logger.d("vybeCamEnabled in login: $enabled");

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

    checkWalletStatus();
    notifyListeners();
  }

  Future<void> checkFace() async {
    checkingFace = true;
    UnlockedWallet wallet = await localAuthService.accessWalletWithFaceId();
    logger.d("Wallet is ${wallet.address}");
    checkingFace = false;
    if (wallet.address.isEmpty) {
      handleChangeLoginMethod(loginMethods[0]);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();

    super.dispose();
  }

  Future<void> login() async {
    if (isClickCreateNewWallet) return;
    clearErrors();

    isClickCreateNewWallet = true;
    try {
      await reownService.connect();
      if (reownService.isConnected) {

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
      isClickCreateNewWallet = false;
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

  void showImportDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      useSafeArea: false,
      builder: (context) => ImportWalletDialog(cryptoService: cryptoService),
    ).then((result) {
      if (result != null) {
        // Import was successful!
        AIHelpers.showToast(msg: 'Wallet imported successfully! Address: ${result.address}');
        // Navigate to main app screen
        Routers.goToRegisterFirstPage(
          context,
          user: UserModel(walletAddress: result.address),
        );
      }
    });
  }

  Future<void> checkWalletStatus() async {
    isCheckingWallet = true;
    _walletExists = await cryptoService.doesWalletExist();
    isCheckingWallet = false;
    notifyListeners();
    // if (_walletExists) await checkFace();
  } 

  Future<void> handleClickSignIn(BuildContext ctx) async {
  //   if(isBusy) return;
  //   setBusy(true);
  //   clearErrors();
  //   runBusyFuture(() async {
  //     try {
  //     final password = existingPasswordController.text.trim();
  //     UnlockedWallet unlockedWallet = await cryptoService.unlockFromStorage(password);
  //     if (unlockedWallet.address == "") { 
  //       setError("Incorrect Password.");
  //       return;
  //     }
  //     var authUser = await AuthHelper.signIn(
  //       unlockedWallet.address,
  //       isCheckScan,
  //     );

  //     if (authUser?.walletAddress?.isEmpty ?? true) {
  //       Routers.goToRegisterFirstPage(
  //         context,
  //         user: UserModel(walletAddress: unlockedWallet.address),
  //       );
  //     } else {
  //       AuthHelper.updateStatus('Online');
  //       Routers.goToMainPage(context);
  //     }
  //   } catch (e) {
  //     logger.d(e);
  //     setError("Failed to SignIn $e");
  //   } finally {
  //     isClickCreateNewWallet = false;
  //     setBusy(false);
  //   }
  //   }());

  // if(hasError) {
  //   AIHelpers.showToast(msg: modelError.toString());
  // }
    Routers.goToPincodePage(context);
  

  }


  void handleClickForgotPassword() {
    _walletExists = false;
    notifyListeners();
  }

  void handleSignInWithPassword() {
    _walletExists = true;
    notifyListeners();
  }

  void handleChangeLoginMethod(String method) {
    if(method.isEmpty) return;
    loginMethod = method;
    if (method == loginMethods[0]) {
      Routers.goToPincodePage(context);
    }
  }
}
