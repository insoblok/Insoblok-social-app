import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/pages/pages.dart';


class PinCodeRegistrationPage extends StatefulWidget {
  const PinCodeRegistrationPage({Key? key}) : super(key: key);

  @override
  _PinRegistrationPageState createState() => _PinRegistrationPageState();
}

class _PinRegistrationPageState extends State<PinCodeRegistrationPage> {
  String _enteredPin = "";
  String _confirmedPin = "";
  bool _isConfirmStep = false;
  String _status = "Create a new PIN";
  final int pinLength = 6;
  final CryptoService cryptoService = CryptoService();
  
  void _onKeyTap(String value) {
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

  Widget _buildPinDots(String pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pinLength,
        (index) {
          bool filled = index < pin.length;
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? Colors.white : Colors.white24,
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeypad() {
    final buttons = [
      "1","2","3",
      "4","5","6",
      "7","8","9",
      "","0","⌫",
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: buttons.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final label = buttons[index];
        if (label == "") {
          return const SizedBox.shrink();
        }
        return GestureDetector(
          onTap: () {
            if (label == "⌫") {
              _onDelete();
            } else {
              _onKeyTap(label);
            }
          },
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleClickCreate(BuildContext bContext, String pin) async {
    try {
      final newWalletResult = await cryptoService.createAndStoreWallet(pin);

      logger.d("Wallet creation result is ${newWalletResult.address}, ${newWalletResult.mnemonic}");
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SeedPhraseConfirmationWidget(
          seedWords: (newWalletResult.mnemonic ?? "").split(" ").toList(), 
          onConfirmed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => SeedPhraseConfirmationDialog(
                originalSeedPhrase: newWalletResult.mnemonic!.trim(),
                onConfirm: () {
                  Routers.goToRegisterFirstPage(bContext,
                    user: UserModel(walletAddress: newWalletResult.address)
                  );
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
      
    } catch (e) {
      logger.e(e);
      rethrow; // Re-throw to handle in the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = _isConfirmStep ? _confirmedPin : _enteredPin;

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
                  const Icon(Icons.lock, color: Colors.white, size: 36),
                  const SizedBox(height: 16),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: Column(
                      children: [
                        Text(
                          _status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        const SizedBox(height: 16.0),
                        _buildPinDots(currentPin),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildKeypad(),
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
