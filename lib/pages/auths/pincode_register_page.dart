import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/locator.dart';

class PinCodeRegistrationPage extends StatefulWidget {
  const PinCodeRegistrationPage({Key? key, required this.mnemonic})
    : super(key: key);
  final String mnemonic;

  @override
  _PinRegistrationPageState createState() => _PinRegistrationPageState();
}

class _PinRegistrationPageState extends State<PinCodeRegistrationPage> {
  String _enteredPin = "";
  String _confirmedPin = "";
  bool _isConfirmStep = false;
  bool _isLoading = false;
  String _status = "Create a new PIN";
  final int pinLength = 6;
  final CryptoService cryptoService = locator<CryptoService>();

  void _onKeyPressed(String value) {
    setState(() {
      if (!_isConfirmStep) {
        if (_enteredPin.length < pinLength) {
          _enteredPin += value;
          if (_enteredPin.length == pinLength) {
            _isConfirmStep = true;
            _status = "Confirm your PIN";
          }
        }
      } else {
        if (_confirmedPin.length < pinLength) {
          _confirmedPin += value;
          if (_confirmedPin.length == pinLength) {
            if (_enteredPin == _confirmedPin) {
              setState(() {
                _status = "PIN successfully set!";
              });
              // 👉 Save PIN securely (SharedPreferences, SecureStorage, etc.)
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleClickCreate(context, _enteredPin);
              });
            } else {
              setState(() {
                _status = "PINs do not match. Try again.";
                _enteredPin = "";
                _confirmedPin = "";
                _isConfirmStep = false;
              });
            }
          }
        }
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (!_isConfirmStep) {
        if (_enteredPin.isNotEmpty) {
          _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        }
      } else {
        if (_confirmedPin.isNotEmpty) {
          _confirmedPin = _confirmedPin.substring(0, _confirmedPin.length - 1);
        }
      }
    });
  }

  void _handleKeyInput(String value) {
    if (value == "back") {
      _onDelete();
    } else if (value == "OK") {
      _handleClickCreate(context, _enteredPin);
    } else {
      _onKeyPressed(value);
    }
  }

  Future<void> _handleClickCreate(BuildContext bContext, String pin) async {
    if (_isLoading) return; // Prevent multiple calls
    
    setState(() {
      _isLoading = true;
      _status = "Creating wallet...";
    });
    
    try {
      String mnemonic = "";
      String address = "";
      NewWalletResult? walletResult;

      setState(() {
        _status = "Generating wallet...";
      });

      if (widget.mnemonic.isEmpty) {
        walletResult = await cryptoService.createAndStoreWallet(pin);
        mnemonic = walletResult.mnemonic ?? "";
        address = walletResult.address;
      } else {
        walletResult = await cryptoService.importFromMnemonic(
          widget.mnemonic,
          pin,
        );
        mnemonic = widget.mnemonic;
        address = walletResult.address;
      }

      setState(() {
        _status = "Saving credentials...";
      });

      // Save password/PIN for future login
      // This ensures credentials are saved for automatic login
      final globalStore = GlobalStore();
      final savedEmail = await globalStore.getSavedEmail();
      logger.d(
        "Saving credentials - Email: ${savedEmail ?? 'none'}, Password: ${pin.isNotEmpty ? '***' : 'empty'}",
      );
      await globalStore.saveCredentials(
        email: savedEmail ?? '',
        password: pin,
        enableAutoLogin: true,
      );
      logger.d("Credentials saved successfully");

      logger.d("Wallet creation result is $address, $mnemonic");

      // Log all created addresses
      logger.d("ETH address: ${walletResult.address}");
      logger.d("USDT address: ${walletResult.addresses['usdt']}");
      logger.d("XRP public key: ${walletResult.addresses['xrp']}");
      logger.d("All addresses: ${walletResult.addresses}");

      setState(() {
        _status = "Setting up account...";
      });

      if (widget.mnemonic.isEmpty) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => SeedPhraseConfirmationWidget(
                seedWords: mnemonic.split(" ").toList(),
                onConfirmed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) => SeedPhraseConfirmationDialog(
                          originalSeedPhrase: mnemonic.trim(),
                          onConfirm: () async {
                            var authUser = await AuthHelper.signIn(
                              address,
                              true,
                            );

                            if (authUser?.walletAddress?.isEmpty ?? true) {
                              Routers.goToRegisterFirstPage(
                                bContext,
                                user: UserModel(walletAddress: address),
                              );
                            } else {
                              AuthHelper.updateStatus('Online');
                              Routers.goToMainPage(bContext);
                            }
                          },
                          onCancel: () {
                            Navigator.pop(context); // Close confirmation dialog
                          },
                          showSeedPhrase: false,
                        ),
                  );
                },
              ),
        );
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => SeedPhraseConfirmationDialog(
                originalSeedPhrase: mnemonic.trim(),
                onConfirm: () async {
                  var authUser = await AuthHelper.signIn(address, true);

                  if (authUser?.walletAddress?.isEmpty ?? true) {
                    Routers.goToRegisterFirstPage(
                      bContext,
                      user: UserModel(walletAddress: address),
                    );
                  } else {
                    AuthHelper.updateStatus('Online');
                    Routers.goToMainPage(bContext);
                  }
                },
                onCancel: () {
                  Navigator.pop(context); // Close confirmation dialog
                },
                showSeedPhrase: false,
              ),
        );
      }
    } catch (e) {
      logger.e(e);
      setState(() {
        _isLoading = false;
        _status = "Error occurred. Please try again.";
      });
      rethrow; // Re-throw to handle in the dialog
    } finally {
      // Don't set _isLoading to false here as we're navigating away
      // The loading state will be reset when the page is disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = _isConfirmStep ? _confirmedPin : _enteredPin;
    final double buttonSize = (MediaQuery.of(context).size.width) * 0.18;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.red.shade700,
              Colors.blue.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 40),

                      // Using the reusable PinInputWidget
                      Opacity(
                        opacity: _isLoading ? 0.5 : 1.0,
                        child: PinCodeInputWidget(
                          enteredPin: currentPin,
                          pinLength: pinLength,
                          onKeyPressed: _isLoading ? (_) {} : _handleKeyInput,
                          status: _status,
                          dotColor: Colors.white,
                          filledColor: Colors.white,
                          buttonColor: Colors.red,
                          textColor: Colors.white,
                          buttonSize: buttonSize,
                          dotSize: 18,
                          dotSpacing: 8,
                          showBackButton: true,
                          showLockIcon: true,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                },
                          child: Opacity(
                            opacity: _isLoading ? 0.5 : 1.0,
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Loading overlay
              if (_isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
