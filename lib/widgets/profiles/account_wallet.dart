import 'package:flutter/material.dart';

import 'package:insoblok/services/services.dart';

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
          color: AppSettingHelper.greyBackground,
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
    return Container(
      width: 160.0,
      height: 80.0,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }
}
