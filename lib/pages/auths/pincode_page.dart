import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';

class PinCodePage extends StatefulWidget {
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  String enteredPin = "";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _pincodeKey = "wallet_pincode";
  int? pinCodeLength;
  CryptoService cryptoService = locator<CryptoService>();
  bool signing = false;
  String status = "Swipe up for Face ID or Enter Passcode";

  @override
  void initState() {
    super.initState();
    _loadPinLength();
  }

  Future<void> _loadPinLength() async {
    final pinCodeKey = await _secureStorage.read(key: _pincodeKey);
    setState(() {
      pinCodeLength = int.tryParse(pinCodeKey ?? "") ?? 6;
    });
  }

  Future<void> _onKeyPressed(String value, BuildContext ctx) async {
    if (signing) return;
    setState(() {
      if (value == "back") {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      } else {
        if (enteredPin.length < pinCodeLength!) {
          enteredPin += value;
        }
      }
    });
    if (enteredPin.length == 6) {
      await signIn(ctx);
    }
  }

  Future<void> signIn(BuildContext ctx) async {
    if (signing) return;
    setState(() {
      signing = true;
      status = "... Signing In Now";
    });
    try {
      UnlockedWallet unlockedWallet = await cryptoService.unlockFromStorage(enteredPin);
      if (unlockedWallet.address.isNotEmpty) {
        var authUser = await AuthHelper.signIn(unlockedWallet.address, false);

        if (authUser?.walletAddress?.isEmpty ?? true) {
          Routers.goToRegisterFirstPage(
            context,
            user: UserModel(walletAddress: unlockedWallet.address),
          );
        } else {
          AuthHelper.updateStatus('Online');
          Routers.goToMainPage(context);
        }
        return;
      }
    } catch (_) {} finally {
      setState(() {
        status = "Wrong password. Try again";
        signing = false;
      });
    }
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        bool filled = index < enteredPin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: filled ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white, width: 1.5),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onKeyPressed(number, context),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 90,
        height: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final numbers = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"],
      ["", "0", "back"]
    ];

    return Column(
      children: numbers.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((item) {
              if (item.isEmpty) {
                return SizedBox(width: 80, height: 80);
              } else if (item == "back") {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: IconButton(
                    onPressed: () => _onKeyPressed("back", context),
                    icon: Icon(Icons.backspace, color: Colors.white, size: 28),
                  ),
                );
              } else {
                return _buildNumberButton(item);
              }
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.red.shade700, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              Icon(Icons.lock, color: Colors.white, size: 36),
              SizedBox(height: 16),
              Expanded(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Column(
                    children:[ 
                      Text(
                        status,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      SizedBox(height: 16.0),
                      _buildPinDots(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              // Spacer(),
              _buildKeypad(),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Emergency", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("Cancel", style: TextStyle(color: Colors.white70, fontSize: 16)),
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
