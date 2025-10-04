import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insoblok/services/services.dart';

class PinCodeInputWidget extends StatelessWidget {
  final String enteredPin;
  final int pinLength;
  final ValueChanged<String> onKeyPressed;
  final String status;
  final Color dotColor;
  final Color filledColor;
  final Color buttonColor;
  final Color textColor;
  final double buttonSize;
  final double dotSize;
  final double dotSpacing;
  final bool showBackButton;
  final bool showLockIcon;
  final double topSpacing;

  PinCodeInputWidget({
    Key? key,
    required this.enteredPin,
    required this.pinLength,
    required this.onKeyPressed,
    required this.status,
    this.dotColor = Colors.white,
    this.filledColor = Colors.white,
    this.buttonColor = Colors.red,
    this.textColor = Colors.white,
    this.buttonSize = 80,
    this.dotSize = 14,
    this.dotSpacing = 12,
    this.showBackButton = true,
    this.showLockIcon = true,
    this.topSpacing = 40,
  }) : super(key: key);

  final Map<String, String> numberLetters = {
    "1": "",
    "2": "ABC",
    "3": "DEF",
    "4": "GHI",
    "5": "JKL",
    "6": "MNO",
    "7": "PQRS",
    "8": "TUV",
    "9": "WXYZ",
    "0": "",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topSpacing),
        
        if (showLockIcon) ...[
          Icon(Icons.lock, color: Colors.white, size: 36),
          SizedBox(height: 16),
        ],
        
        FractionallySizedBox(
          widthFactor: 0.6,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (status.contains("Signing")) ...[
                    CircularProgressIndicator(strokeWidth: 4, color: Colors.pinkAccent),
                    SizedBox(width: 16),
                  ],
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              
              // Pin Dots
              _buildPinDots(),
            ],
          ),
        ),
        SizedBox(height: 48),
        
        // Number Pad
        _buildNumberPad(context),
      ],
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        bool filled = index < enteredPin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: dotSpacing),
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: filled ? filledColor : Colors.transparent,
            border: Border.all(color: dotColor, width: 1.5),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildNumberPad(BuildContext ctx) {
    final numbers = [
      ["1", "2", "3"],
      ["4", "5", "6"],
      ["7", "8", "9"],
      [if (showBackButton) "back", "0", "OK"]
    ];

    return Column(
      children: numbers.map((row) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: MediaQuery.of(ctx).size.width * 0.1),
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
                    onPressed: () => onKeyPressed("back"),
                    icon: Icon(Icons.backspace, color: textColor, size: 28),
                  ),
                );
              } else if (item == 'OK') {
                return SizedBox(
                  width: buttonSize,
                  height: buttonSize,
                  child: Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                    onTap: () => onKeyPressed("OK"),
                      child: Text(
                        "OK",
                        style: Theme.of(ctx).textTheme.bodyLarge
                      )
                    ),
                  ),
                );
              }
              else {
                return _buildNumberButton(item);
              }
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return _AnimatedButton(
      buttonSize: buttonSize,
      onPressed: () {
        HapticFeedback.lightImpact(); 
        SystemSound.play(SystemSoundType.click);
        onKeyPressed(number);
      },
      backgroundColor: buttonColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontSize: 28,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (numberLetters[number]!.isNotEmpty) ...[
            SizedBox(height: 2),
            Text(
              numberLetters[number]!,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.8),
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }

}

// Reusable animated button widget with iPhone-like effects
class _AnimatedButton extends StatefulWidget {
  final double buttonSize;
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;

  const _AnimatedButton({
    required this.buttonSize,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
  });

  @override
  __AnimatedButtonState createState() => __AnimatedButtonState();
}

class __AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: widget.buttonSize,
        height: widget.buttonSize,
        decoration: BoxDecoration(
          color: _isPressed 
              ? widget.backgroundColor.withOpacity(0.8) // Darker when pressed
              : widget.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: _isPressed 
              ? [
                  // Inner shadow effect when pressed (iPhone-like)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                    spreadRadius: -2,
                  ),
                ]
              : [
                  // Outer shadow when not pressed
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                  // Light shadow for depth
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
        ),
        // Scale animation - iPhone-like press effect
        transform: Matrix4.identity()..scale(_isPressed ? 0.92 : 1.0),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 100),
          opacity: _isPressed ? 0.8 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }
}

// Alternative simpler version with just scale animation
class _SimpleAnimatedButton extends StatefulWidget {
  final double buttonSize;
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;

  const _SimpleAnimatedButton({
    required this.buttonSize,
    required this.onPressed,
    required this.child,
    required this.backgroundColor,
  });

  @override
  __SimpleAnimatedButtonState createState() => __SimpleAnimatedButtonState();
}

class __SimpleAnimatedButtonState extends State<_SimpleAnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: Duration(milliseconds: 100),
        scale: _isPressed ? 0.9 : 1.0,
        child: Container(
          width: widget.buttonSize,
          height: widget.buttonSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}