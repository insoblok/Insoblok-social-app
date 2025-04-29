import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

const kAccountAvatarSize = 72.0;
const kAccountPageTitles = ['My Posts', 'Liked', 'Following'];

class AccountPage extends StatelessWidget {
  final UserModel? user;

  const AccountPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountProvider>.reactive(
      viewModelBuilder: () => AccountProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: user),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 135.0 + kAccountAvatarSize / 2.0,
                    child: Stack(
                      children: [
                        AIImage(
                          viewModel.accountUser?.discovery ??
                              AIImages.imgBackSplash,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 135.0,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            width: kAccountAvatarSize,
                            height: kAccountAvatarSize,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.0,
                                color: AIColors.blue,
                              ),
                              borderRadius: BorderRadius.circular(
                                kAccountAvatarSize / 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: AIImage(viewModel.accountUser?.avatar),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            margin: EdgeInsets.only(
                              left: 20.0,
                              top: MediaQuery.of(context).padding.top + 12.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  AppSettingHelper.themeMode == ThemeMode.light
                                      ? AIColors.lightTransparentBackground
                                      : AIColors.darkTransparentBackground,
                            ),
                            child: Icon(Icons.arrow_back, size: 18.0),
                          ),
                        ),
                        if (viewModel.accountUser?.uid == viewModel.user?.uid)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: const EdgeInsets.only(right: 20.0),
                              width: 100.0,
                              height: 32.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AIColors.blue,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: Theme.of(context).textTheme.labelSmall!
                                    .copyWith(color: AIColors.blue),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          viewModel.accountUser?.fullName ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '@${viewModel.accountUser?.nickId}',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          viewModel.accountUser?.desc ??
                              'You can input your profile description if you didn\'t set that yet!. That will be shown to other and will make more user experience of InSoBlokAI.',
                          style:
                              viewModel.accountUser?.desc == null
                                  ? Theme.of(context).textTheme.labelMedium
                                  : Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16.0),
                        Wrap(
                          spacing: 12.0,
                          runSpacing: 4.0,
                          children:
                              (viewModel.accountUser?.linkInfo ?? []).map((
                                info,
                              ) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AIImage(
                                      info['icon'],
                                      width: 18.0,
                                      height: 18.0,
                                      color: AIColors.greyTextColor,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      info['title']!,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16.0),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    (viewModel.accountUser?.likes?.length ?? 0)
                                        .socialValue,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' Likes  ',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextSpan(
                                text:
                                    '  ${(viewModel.accountUser?.follows?.length ?? 0).socialValue}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' Followers',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 12.0,
                    children: [
                      for (var i = 0; i < 3; i++) ...{
                        Expanded(
                          child: InkWell(
                            onTap: () => viewModel.pageIndex = i,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border:
                                    viewModel.pageIndex == i
                                        ? Border(
                                          bottom: BorderSide(
                                            width: 2.0,
                                            color: AIColors.blue,
                                          ),
                                        )
                                        : null,
                              ),
                              child: Text(kAccountPageTitles[i]),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
