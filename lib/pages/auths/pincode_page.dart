import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';

class PinCodePage extends StatefulWidget {
  @override
  _PinCodePageState createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> with SingleTickerProviderStateMixin {
  String enteredPin = "";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _pincodeKey = "wallet_pincode";
  int? pinCodeLength;
  CryptoService cryptoService = locator<CryptoService>();
  bool signing = false;
  String status = "Swipe up for Face ID or Enter Passcode";
  late AnimationController _controller;
  late Animation<double> _pulse;
  late PageController _pageController;

  LocalAuthService localAuthService = LocalAuthService();
  String checkFaceStatus = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.9, end: 1.15).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        checkFaceStatus = "Authenticating...";
      });
      _checkFace();
    });
    _loadPinLength();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
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
        enteredPin = "";
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
    final double buttonSize = (MediaQuery.of(context).size.width) * 0.22;
    return InkWell(
      onTap: () => _onKeyPressed(number, context),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w400),
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
    final double buttonSize = (MediaQuery.of(context).size.width) * 0.22;
    logger.d("button size is $buttonSize");
    return Column(
      children: numbers.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((item) {
              if (item.isEmpty) {
                return SizedBox(width: buttonSize, height: buttonSize);
              } else if (item == "back") {
                return SizedBox(
                  width: buttonSize,
                  height: buttonSize,
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

  Future<void> _checkFace() async {
    
    UnlockedWallet wallet = await localAuthService.accessWalletWithFaceId();
    logger.d("Wallet is ${wallet.address}");
    if (wallet.address.isEmpty) {
      setState(() {
        checkFaceStatus = "Biometric Unlock Failed. Try again with PinCode.";
      });
    }
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
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              if (index == 0 ) {
                _checkFace();
              }
            },
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment(0.8, -0.8),
                          radius: 1.2,
                          colors: [Colors.white.withOpacity(0.03), Colors.transparent],
                        ),
                      ),
                    ),

                    // Content
                    SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Animated pulsing Face ID frame
                                  AnimatedBuilder(
                                    animation: _pulse,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _pulse.value,
                                        child: child,
                                      );
                                    },
                                    child: _FaceIdIcon(size: 160),
                                  ),

                                  SizedBox(height: 28),

                                  // Label
                                  Text('Biometric Auth', style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 28, fontWeight: FontWeight.w600)),

                                  SizedBox(height: 8),

                                  // Hint text
                                  Text(checkFaceStatus, style: TextStyle(color: Colors.white.withOpacity(0.7))),

                                  SizedBox(height: 40),

                                  // Small hint for fallback
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),

                          // Bottom padding to simulate edge area
                          SizedBox(height: 16)
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
                
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                            Icon(Icons.lock, color: Colors.white, size: 36),
                            SizedBox(height: 16),
                              FractionallySizedBox(
                                widthFactor: 0.7,
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
                            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                            // Spacer(),
                            _buildKeypad(),
                            ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
            ]
          ),
      )
      )
    );
  }
}


class _FaceIdIcon extends StatelessWidget {
  final double size;
  const _FaceIdIcon({Key? key, this.size = 120}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rounded square frame corners
          Positioned.fill(
            child: CustomPaint(
              painter: _FramePainter(),
            ),
          ),

          // Simple face made from basic shapes
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tag_faces, size: size * 0.5, color: Colors.white.withOpacity(0.95)),
            ],
          )
        ],
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.95)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final cornerLength = size.width * 0.18;

    // Top-left
    canvas.drawLine(Offset(0, cornerLength), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - cornerLength, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - cornerLength), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}