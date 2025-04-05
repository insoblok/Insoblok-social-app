import 'package:aiavatar/providers/providers.dart';
import 'package:aiavatar/routers/routers.dart';
import 'package:aiavatar/services/image_service.dart';
import 'package:aiavatar/services/services.dart';
import 'package:aiavatar/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:aiavatar/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends ViewModelWidget<AIAvatarProvider> {
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
                AIImage(Icons.account_circle),
                const SizedBox(width: 24.0),
                Text(
                  '${AuthHelper.user?.firstName} ${AuthHelper.user?.lastName} ',
                ),
                const Spacer(),
                AIImage(
                  Icons.arrow_forward_ios,
                  height: 14.0,
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
