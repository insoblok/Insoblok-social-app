import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UserAvatarView extends StatelessWidget {
  final void Function(int?)? onUpdateAvatar;
  const UserAvatarView({super.key, this.onUpdateAvatar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      height: 120.0,
      child: Stack(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: AIColors.pink),
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: ClipOval(
              child: AIImage(
                width: double.infinity,
                height: double.infinity,
                AuthHelper.user?.avatar,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                var result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Container(
                        width: double.infinity,
                        color: AIColors.darkScaffoldBackground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(0),
                              child: Row(
                                children: [
                                  AIImage(Icons.air, color: AIColors.pink),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'Create to AI Avatar',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AIColors.pink,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AIColors.pink,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(
                                      'Premium',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(1),
                              child: Row(
                                children: [
                                  AIImage(Icons.camera, color: AIColors.pink),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'From Image Gallery',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AIColors.pink,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Free',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (onUpdateAvatar != null) {
                  onUpdateAvatar!(result);
                }
              },
              child: Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AIColors.pink,
                  shape: BoxShape.circle,
                ),
                child: AIImage(Icons.camera, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final dynamic src;
  final String text;
  final void Function()? onTap;

  const UserInfoWidget({super.key, this.src, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AIColors.borderColor)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (src != null) ...{
              AIImage(src, color: Colors.white),
              const SizedBox(width: 24.0),
            },
            Text(text, style: TextStyle(color: Colors.white)),
            const Spacer(),
            AIImage(Icons.arrow_forward_ios, height: 14.0, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class AppLeadingView extends StatelessWidget {
  const AppLeadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: ClipOval(
          child: AIAvatarImage(
            AuthHelper.user?.avatar,
            width: 32.0,
            height: 32.0,
            fullname: AuthHelper.user?.nickId ?? 'Test',
          ),
        ),
      ),
    );
  }
}

class UserRelatedView extends StatelessWidget {
  final String uid;

  const UserRelatedView({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, uid: uid),
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AIColors.speraterColor, width: 0.33),
            ),
          ),
          child: InkWell(
            onTap: viewModel.goToDetailPage,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: AIAvatarImage(
                            viewModel.owner?.avatar,
                            width: kStoryDetailAvatarSize,
                            height: kStoryDetailAvatarSize,
                            textSize: 24.0,
                            fullname: viewModel.owner?.nickId ?? 'Test',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            viewModel.owner?.fullName ?? '---',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '@${viewModel.owner?.nickId} • ${viewModel.owner?.timestamp?.mdyFormatter}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                (viewModel.owner?.desc != null)
                    ? AIHelpers.htmlRender(viewModel.owner?.desc)
                    : Text(
                      'User can input your profile description if you didn\'t set that yet!. That will be shown to other and will make more user experience of InSoBlokAI.',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Row(
                      children: [
                        AIImage(AIImages.icRetwitter, height: 14.0),
                        const SizedBox(width: 4.0),
                        Text(
                          (viewModel.owner?.follows?.length ?? 0).socialValue,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    const SizedBox(width: 40.0),
                    Row(
                      children: [
                        AIImage(
                          viewModel.owner?.isLike() ?? false
                              ? AIImages.icFavoriteFill
                              : AIImages.icFavorite,
                          height: 14.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          (viewModel.owner?.likes?.length ?? 0).socialValue,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
