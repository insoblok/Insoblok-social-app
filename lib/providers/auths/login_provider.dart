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

  CryptoService cryptoService = locator<CryptoService>();
  LocalAuthService localAuthService = LocalAuthService();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  static const loginMethods = ["Login with Password", "Login with Face ID"];

  final ApiService apiService = ApiService(baseUrl: "");

  String _loginMethod = loginMethods[0];
  String get loginMethod => _loginMethod;
  set loginMethod(String s) {
    _loginMethod = s;
    notifyListeners();
  }

  final _existingPasswordController = TextEditingController();
  TextEditingController get existingPasswordController =>
      _existingPasswordController;

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

  bool _isNavigatingToMain = false;
  bool get isNavigatingToMain => _isNavigatingToMain;
  set isNavigatingToMain(bool value) {
    _isNavigatingToMain = value;
    notifyListeners();
  }

  final globals = GlobalStore();
  bool get enabled => globals.isVybeCamEnabled;

  String _checkFaceStatus = "";
  String get checkFaceStatus => _checkFaceStatus;
  set checkFaceStatus(String s) {
    _checkFaceStatus = s;
    notifyListeners();
  }

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

    await checkWalletStatus();
    if (!walletExists) return;

    // Immediately attempt authentication and go directly to main page
    await _attemptDirectLogin();
  }

  Future<void> _attemptDirectLogin() async {
    // Try to authenticate using saved credentials first
    final globalStore = GlobalStore();
    final savedPassword = await globalStore.getSavedPassword();

    logger.d(
      "Attempting direct login. Has saved password: ${savedPassword != null && savedPassword.isNotEmpty}",
    );

    if (savedPassword != null && savedPassword.isNotEmpty) {
      // Try to authenticate with saved password
      try {
        logger.d("Unlocking wallet with saved password...");
        UnlockedWallet unlockedWallet = await cryptoService.unlockFromStorage(
          savedPassword,
        );
        logger.d("Wallet unlocked. Address: ${unlockedWallet.address}");

        if (unlockedWallet.address.isNotEmpty) {
          logger.d("Signing in with wallet address...");
          var authUser = await AuthHelper.signIn(unlockedWallet.address, false);
          logger.d("Auth user: ${authUser?.walletAddress}");

          if (authUser?.walletAddress?.isNotEmpty ?? false) {
            logger.d("Authentication successful! Navigating to main page...");
            isNavigatingToMain = true;
            notifyListeners();
            AuthHelper.updateStatus('Online');
            // Add a small delay to show the loading indicator
            await Future.delayed(const Duration(milliseconds: 500));
            if (context.mounted) {
              Routers.goToMainPage(context);
            }
            return;
          } else {
            logger.d("Auth user wallet address is empty");
          }
        } else {
          logger.d("Unlocked wallet address is empty");
        }
      } catch (e, stackTrace) {
        logger.d("Auto-login failed: $e");
        logger.d("Stack trace: $stackTrace");
        // Fall through to try face authentication
      }
    } else {
      logger.d("No saved password found");
    }

    // Check if biometric is enabled for the user, or if device supports biometrics
    final isBiometricAvailable = await localAuthService.isFaceIDAvailable();
    final userBiometricEnabled = AuthHelper.user?.biometricEnabled ?? false;

    // Try face authentication if available
    if (isBiometricAvailable && userBiometricEnabled) {
      // Go directly to face authentication
      await checkFace(context);
    } else {
      // Don't navigate to pincode page - stay on login page
      // The login page will show options for manual authentication
      checkFaceStatus = "";
      notifyListeners();
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
          isNavigatingToMain = true;
          AuthHelper.updateStatus('Online');
          // Add a small delay to show the loading indicator
          await Future.delayed(const Duration(milliseconds: 500));
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
      isNavigatingToMain = true;
      AuthHelper.updateStatus('Online');
      // Add a small delay to show the loading indicator
      await Future.delayed(const Duration(milliseconds: 500));
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
        AIHelpers.showToast(
          msg: 'Wallet imported successfully! Address: ${result.address}',
        );
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

  void handleClickForgotPassword() {
    _walletExists = false;
    notifyListeners();
  }

  Future<void> handleSignInWithPassword() async {
    // Try to authenticate directly and go to main page
    _walletExists = true;
    isNavigatingToMain = true;
    notifyListeners();

    // Try saved credentials first
    final globalStore = GlobalStore();
    final savedPassword = await globalStore.getSavedPassword();

    if (savedPassword != null && savedPassword.isNotEmpty) {
      try {
        UnlockedWallet unlockedWallet = await cryptoService.unlockFromStorage(
          savedPassword,
        );
        if (unlockedWallet.address.isNotEmpty) {
          var authUser = await AuthHelper.signIn(unlockedWallet.address, false);
          if (authUser?.walletAddress?.isNotEmpty ?? false) {
            AuthHelper.updateStatus('Online');
            // Add a small delay to show the loading indicator
            await Future.delayed(const Duration(milliseconds: 500));
            if (context.mounted) {
              Routers.goToMainPage(context);
            }
            return;
          }
        }
      } catch (e) {
        logger.d("Sign in with password failed: $e");
        isNavigatingToMain = false;
        checkFaceStatus = "Authentication failed. Please try again.";
        notifyListeners();
        return;
      }
    }

    // No saved password - try face authentication
    final isBiometricAvailable = await localAuthService.isFaceIDAvailable();
    if (isBiometricAvailable) {
      await checkFace(context);
    } else {
      isNavigatingToMain = false;
      checkFaceStatus = "No saved credentials. Please set up authentication.";
      notifyListeners();
    }
  }

  void handleChangeLoginMethod(String method) {
    if (method.isEmpty) return;
    loginMethod = method;
    // Don't navigate to pincode page - handle authentication on login page
    if (method == loginMethods[0]) {
      // Password login - try saved credentials or face auth
      handleSignInWithPassword();
    } else if (method == loginMethods[1]) {
      // Face ID login
      checkFace(context);
    }
  }

  Future<void> checkFace(BuildContext ctx) async {
    UnlockedWallet wallet = await localAuthService.accessWalletWithFaceId();
    logger.d("Wallet is ${wallet.address}");
    if (wallet.address.isEmpty) {
      checkFaceStatus =
          "Biometric Unlock Failed. Please try again or use password.";
      apiService.logRequest({
        "result": "failed",
        "message":
            'Face Unlock Failed: _checkFace ${await AIHelpers.getIPAddress()}',
      });
      notifyListeners();
      return;
    } else {
      checkFaceStatus = "Biometric Auth success. Please wait ...";
      apiService.logRequest({
        "result": "success",
        "message":
            'Face Unlock Success: _checkFace ${await AIHelpers.getIPAddress()}',
      });

      var authUser = await AuthHelper.signIn(wallet.address, false);

      if (authUser?.walletAddress?.isEmpty ?? true) {
        Routers.goToRegisterFirstPage(
          context,
          user: UserModel(walletAddress: wallet.address),
        );
      } else {
        isNavigatingToMain = true;
        AuthHelper.updateStatus('Online');
        // Add a small delay to show the loading indicator
        await Future.delayed(const Duration(milliseconds: 500));
        Routers.goToMainPage(context);
      }
    }
  }
}
