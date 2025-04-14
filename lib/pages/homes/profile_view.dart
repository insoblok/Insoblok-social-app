import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class ProfileView extends ViewModelWidget<InSoBlokProvider> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 24.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
            height: 24.0,
          ),
          UserAvatarView(
            onUpdateAvatar: (result) async {
              if (result == 0) {
                var url = await Routers.goToAccountPage(context);
                await AuthHelper.setUser(
                  AuthHelper.user!.copyWith(avatar: url),
                );
                viewModel.notifyListeners();
              }
            },
          ),
          const SizedBox(height: 40.0),
          Container(
            width: double.infinity,
            height: 52.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AIColors.borderColor),
              ),
            ),
            child: Row(
              children: [
                AIImage(
                  Icons.account_circle,
                  color: Colors.white,
                ),
                const SizedBox(width: 24.0),
                Text(
                  '${AuthHelper.user?.firstName} ${AuthHelper.user?.lastName} ',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                AIImage(
                  Icons.arrow_forward_ios,
                  height: 14.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AIColors.borderColor,
          ),
        ],
      ),
    );
  }
}
