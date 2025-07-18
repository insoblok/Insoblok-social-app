import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';

class AccountWalletIconCover extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const AccountWalletIconCover({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(16),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: child,
      ),
    );
  }
}

class AccountWalletTokenCover extends StatelessWidget {
  final Widget child;

  const AccountWalletTokenCover({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(18),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: AIColors.black.withAlpha(50),
              spreadRadius: 2,
              blurRadius: 2,
              // offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
