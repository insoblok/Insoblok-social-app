import 'package:flutter/material.dart';

class MessageActionButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onPressed;

  const MessageActionButton({super.key, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.0,
      height: 36.0,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: const CircleBorder(),
        heroTag: null,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
