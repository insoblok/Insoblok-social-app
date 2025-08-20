import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class ProfileView extends ViewModelWidget<InSoBlokProvider> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity, height: 24.0),
          UserAvatarView(
            onUpdateAvatar: (result) async {
              if (result == 0) {
                var url = await Routers.goToAccountAvatarPage(context);
                if (url != null) {
                  await AuthHelper.updateUser(
                    AuthHelper.user!.copyWith(avatar: url),
                  );
                  viewModel.notifyListeners();
                }
              }
            },
          ),
          const SizedBox(height: 40.0),
          UserInfoWidget(
            src: Icons.account_circle,
            text: viewModel.user!.fullName,
            onTap: () {},
          ),
          UserInfoWidget(
            src: Icons.email,
            text: 'kenta@insoblokai.io',
            onTap: () {},
          ),
          UserInfoWidget(
            src: Icons.lock,
            text: 'Change Password',
            onTap: () {},
          ),
          Container(height: 1, color: AIColors.borderColor),
          const SizedBox(height: 48.0),
          UserInfoWidget(
            src: Icons.dashboard,
            text: 'My Stories',
            onTap: () {},
          ),
          UserInfoWidget(src: Icons.favorite, text: 'My Likes', onTap: () {}),
          UserInfoWidget(src: Icons.link, text: 'My Follows', onTap: () {}),
          Container(height: 1, color: AIColors.borderColor),
          const SizedBox(height: 48.0),
          UserInfoWidget(src: Icons.wallet, text: 'My Wallet', onTap: () {}),
          UserInfoWidget(
            src: Icons.work_history_sharp,
            text: 'Wallet History',
            onTap: () {},
          ),
          UserInfoWidget(src: Icons.settings, text: 'Setting', onTap: () {}),
          Container(height: 1, color: AIColors.borderColor),
          SizedBox(height: 96.0),
        ],
      ),
    );
  }
}
