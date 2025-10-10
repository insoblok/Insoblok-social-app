import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart'; // Add this import

class PinCodePage extends StatefulWidget {
  
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> with SingleTickerProviderStateMixin {

  final ApiService apiService = ApiService(baseUrl: "");
  String enteredPin = "";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _pincodeKey = "wallet_pincode";
  int? pinCodeLength;
  CryptoService cryptoService = locator<CryptoService>();
  bool signing = false;
  String status = " Enter Passcode ";
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
      } else if (value != "OK") {
        if (enteredPin.length < pinCodeLength!) {
          enteredPin += value;
        }
      }
    });
    if (value == "OK" || enteredPin.length == 6) {
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
        logger.d("authUser: ${authUser?.walletAddress}");
        if (authUser?.walletAddress?.isEmpty ?? true) {
          Routers.goToRegisterFirstPage(
            context,
            user: UserModel(walletAddress: unlockedWallet.address),
          );
        } else {
          AuthHelper.updateStatus('Online');
          Routers.goToMainPage(context);

        }
      }
      return;
    } catch (e) {
      logger.d("Exception occurred while getting wallet address. $e");
    } finally {
      setState(() {
        status = "Wrong password. Try again";
        enteredPin = "";
        signing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double buttonSize = (MediaQuery.of(context).size.width) * 0.18;
    
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
                // _checkFace();
              }
            },
            children: [
              // Face ID Page (unchanged)
              /*
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
                    SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                  Text('Biometric Auth', style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 28, fontWeight: FontWeight.w600)),
                                  SizedBox(height: 8),
                                  Text(checkFaceStatus, style: TextStyle(color: Colors.white.withOpacity(0.7))),
                                  SizedBox(height: 40),
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
              */
              // PIN Code Page with combined widget
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
                          
                          PinCodeInputWidget(
                            enteredPin: enteredPin,
                            pinLength: pinCodeLength ?? 6,
                            onKeyPressed: (value) => _onKeyPressed(value, context),
                            status: status,
                            dotColor: Colors.white,
                            filledColor: Colors.white,
                            buttonColor: Colors.red,
                            textColor: Colors.white,
                            buttonSize: buttonSize,
                            dotSize: 14,
                            dotSpacing: 12,
                            showBackButton: true,
                          ),
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
          Positioned.fill(
            child: CustomPaint(
              painter: _FramePainter(),
            ),
          ),
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

    canvas.drawLine(Offset(0, cornerLength), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width - cornerLength, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    canvas.drawLine(Offset(0, size.height - cornerLength), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}