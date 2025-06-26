import 'package:flutter/material.dart';

class AnimatiedLinearProgressIndicator extends StatefulWidget {
  final double value;
  final double? minHeight;
  final double? borderRadius;
  final Color? color;
  final Color? backgroundColor;

  const AnimatiedLinearProgressIndicator({
    super.key,
    required this.value,
    this.minHeight,
    this.borderRadius,
    this.color,
    this.backgroundColor,
  });

  @override
  State<AnimatiedLinearProgressIndicator> createState() =>
      _AnimatiedLinearProgressIndicatorState();
}

class _AnimatiedLinearProgressIndicatorState
    extends State<AnimatiedLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 0.0, end: 0.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(Duration(milliseconds: 1000), () {
      animation = Tween<double>(
        begin: 0.0,
        end: widget.value,
      ).animate(controller)..addListener(() {
        setState(() {});
      });
      controller.reset();
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: animation.value,
      minHeight: widget.minHeight,
      color: widget.color,
      backgroundColor: widget.backgroundColor,
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
