import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/locator.dart';

class PinCodeRegistrationPage extends StatefulWidget {
  const PinCodeRegistrationPage({Key? key, required this.mnemonic}) : super(key: key);
  final String mnemonic;

  @override
  _PinRegistrationPageState createState() => _PinRegistrationPageState();
}

class _PinRegistrationPageState extends State<PinCodeRegistrationPage> {
  String _enteredPin = "";
  String _confirmedPin = "";
  bool _isConfirmStep = false;
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
    try {
      String mnemonic = "";
      String address = "";
      if (widget.mnemonic.isEmpty) {
        final newWalletResult =  await cryptoService.createAndStoreWallet(pin);
        mnemonic = newWalletResult.mnemonic ?? "";
        address = newWalletResult.address;
      } else {
        final unlockWalletResult = await cryptoService.importFromMnemonic(widget.mnemonic, pin);
        mnemonic = widget.mnemonic;
        address = unlockWalletResult.address;
      }

      logger.d("Wallet creation result is $address, $mnemonic");
      
      if (widget.mnemonic.isEmpty) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SeedPhraseConfirmationWidget(
            seedWords: mnemonic.split(" ").toList(), 
            onConfirmed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SeedPhraseConfirmationDialog(
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
            } 
          )
        );
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => SeedPhraseConfirmationDialog(
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
      }
    } catch (e) {
      logger.e(e);
      rethrow; // Re-throw to handle in the dialog
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Using the reusable PinInputWidget
                  PinCodeInputWidget(
                    enteredPin: currentPin,
                    pinLength: pinLength,
                    onKeyPressed: _handleKeyInput,
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:() {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text("Cancel", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}