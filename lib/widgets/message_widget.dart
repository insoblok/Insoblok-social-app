import 'package:flutter/material.dart';

class MessageActionButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;

  const MessageActionButton({super.key, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 36.0,
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
