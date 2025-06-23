import 'dart:math';

import 'package:flutter/material.dart';

class FanExpandableFab extends StatefulWidget {
  final Widget icon; // Main FAB icon
  final Widget closeIcon;
  final List<Widget> children; // Action buttons
  final double radius; // How far the buttons spread
  final double startAngle; // Starting angle in degrees
  final double sweepAngle; // Total angle of the fan in degrees

  const FanExpandableFab({
    super.key,
    required this.icon,
    required this.closeIcon,
    required this.children,
    this.radius = 150.0,
    this.startAngle = 90.0,
    this.sweepAngle = 90.0,
  });

  @override
  _FanExpandableFabState createState() => _FanExpandableFabState();
}

class _FanExpandableFabState extends State<FanExpandableFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _toggle() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isOpen = !_isOpen;
  }

  @override
  Widget build(BuildContext context) {
    final int count = widget.children.length;
    final double startRad = widget.startAngle * pi / 180;
    final double sweepRad = widget.sweepAngle * pi / 180;

    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // Action buttons in fan shape
        for (int i = 0; i < count; i++)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              // Calculate angle position for each button
              final double angle = startRad + (sweepRad / (count - 1)) * i;
              final double dx = cos(angle) * widget.radius * _animation.value;
              final double dy = sin(angle) * widget.radius * _animation.value;
              return Positioned(
                bottom: dy, // 56 is default FAB height
                right: dx,
                child: Opacity(opacity: _animation.value, child: child),
              );
            },
            child: widget.children[i],
          ),

        // Main FAB
        FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(44),
          ),
          mini: false,
          elevation: 0.0,
          highlightElevation: 0.0,
          onPressed: () {
            setState(() {
              _toggle();
            });
          },
          child: _isOpen ? widget.closeIcon : widget.icon,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
