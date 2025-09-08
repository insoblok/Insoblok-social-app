import 'dart:async';

import 'package:flutter/material.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
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
  
  final globals = GlobalStore();
  bool get enabled => globals.isVybeCamEnabled;

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

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();

    super.dispose();
  }

  Future<void> handleClickCreateNewWallet(BuildContext buildContext) async {
    if(isClickCreateNewWallet) return;
    isClickCreateNewWallet = true;
    final scaffoldContext = buildContext;
    showDialog<String>(
      context: buildContext,
      builder: (bContext) {
        final TextEditingController _passwordController = TextEditingController();
        final TextEditingController _confirmController = TextEditingController();
        bool _obscurePassword = true;
        bool _obscureConfirm = true;

    // Handler function
        void _handleOkClick(BuildContext ctx, BuildContext buttonContext) async {
          final password = _passwordController.text.trim();
          final confirm = _confirmController.text.trim();

          if (password.isEmpty || confirm.isEmpty) {
            AIHelpers.showToast(msg: "Please enter both fields.");
            return;
          }
          if (password != confirm) {
            AIHelpers.showToast(msg: "Passwords don't match.");
            return;
          }

          // ✅ Both match → call your wallet creation function
          // createNewWallet(password);
          
          try {
            final newWalletResult = await cryptoService.createAndStoreWallet(password);
            var authUser = await AuthHelper.signIn(
              newWalletResult.address,
              isCheckScan,
            );

            Navigator.pop(buttonContext, null);
            
            if (authUser?.walletAddress?.isEmpty ?? true) {
              Routers.goToRegisterFirstPage(
                context,
                user: UserModel(walletAddress: newWalletResult.address),
              );
            } else {
              AuthHelper.updateStatus('Online');
              Routers.goToMainPage(context);
            }
            } catch (e) {
              logger.e(e);
            }
          
        }

        void _handleClickCancel(BuildContext ctx) {
          isClickCreateNewWallet = false;
          Navigator.pop(ctx, null);
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AIColors.modalBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Set Password",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AIPasswordField(
                    controller: _passwordController
                  ),
                  const SizedBox(height: 12),
                  AIPasswordField(
                    controller: _confirmController
                  )
                  ],
              ),
              actions: [
                TextButton(
                  onPressed: () => _handleClickCancel(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _handleOkClick(scaffoldContext, context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );


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
  } 

  Future<void> handleClickSignIn(BuildContext ctx) async {
    if(isBusy) return;
    setBusy(true);
    clearErrors();
    runBusyFuture(() async {
      try {
      final password = existingPasswordController.text.trim();
      UnlockedWallet unlockedWallet = await cryptoService.unlockFromStorage(password);
      if (unlockedWallet.address == "") { 
        setError("Incorrect Password.");
        return;
      }
      var authUser = await AuthHelper.signIn(
        unlockedWallet.address,
        isCheckScan,
      );

      if (authUser?.walletAddress?.isEmpty ?? true) {
        Routers.goToRegisterFirstPage(
          context,
          user: UserModel(walletAddress: unlockedWallet.address),
        );
      } else {
        AuthHelper.updateStatus('Online');
        Routers.goToMainPage(context);
      }
    } catch (e) {
      logger.d(e);
      setError("Failed to SignIn $e");
    } finally {
      isClickCreateNewWallet = false;
      setBusy(false);
    }
    }());

  if(hasError) {
    AIHelpers.showToast(msg: modelError.toString());
  }
  

  }
}
