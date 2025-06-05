import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountPresentHeaderView extends ViewModelWidget<AccountProvider> {
  const AccountPresentHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      color: AppSettingHelper.background,
      child: SizedBox(
        height: 212.0 + kAccountAvatarSize / 2.0,
        child: Stack(
          children: [
            AIImage(
              viewModel.accountUser?.discovery ?? AIImages.imgBackSplash,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20.0),
                        width: kAccountAvatarSize,
                        height: kAccountAvatarSize,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: AIColors.pink),
                          borderRadius: BorderRadius.circular(
                            kAccountAvatarSize / 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: AIAvatarImage(
                            viewModel.accountUser?.avatar,
                            fullname: viewModel.accountUser?.nickId ?? 'Test',
                            textSize: 28.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              viewModel.accountUser?.fullName ?? '',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '@${viewModel.accountUser?.nickId}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              '+30XP today',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        // LinearProgressIndicator(
                        //   color: AIColors.pink,
                        //   value: viewModel.userScore / 100,
                        //   backgroundColor: AIColors.borderColor,
                        //   minHeight: 8,
                        //   borderRadius: BorderRadius.circular(4),
                        // ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            // Text(
                            //   '${viewModel.userScore} XP / 1200',
                            //   style: Theme.of(context).textTheme.bodySmall,
                            //   textAlign: TextAlign.end,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomCircleBackButton(),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: viewModel.onClickMoreButton,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  margin: EdgeInsets.only(
                    right: 20.0,
                    top: MediaQuery.of(context).padding.top + 12.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppSettingHelper.transparentBackground,
                  ),
                  child:
                      viewModel.isMe
                          ? Icon(Icons.edit, size: 18.0)
                          : Center(
                            child: AIImage(
                              AIImages.icBottomMessage,
                              width: 16.0,
                              height: 16.0,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountFloatingView extends ViewModelWidget<AccountProvider> {
  const AccountFloatingView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   viewModel.accountUser?.fullName ?? '',
          //   style: Theme.of(context).textTheme.titleLarge,
          // ),
          // const SizedBox(height: 16.0),
          viewModel.accountUser?.desc != null
              ? AIHelpers.htmlRender(viewModel.accountUser?.desc)
              : Text(
                'User can input your profile description if you didn\'t set that yet!. That will be shown to other and will make more user experience of InSoBlokAI.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
          const SizedBox(height: 16.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 4.0,
            children:
                (viewModel.accountUser?.linkInfo ?? []).map((info) {
                  return InkWell(
                    onTap: () => viewModel.onClickInfo(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AIImage(
                          info['icon'],
                          height: 18.0,
                          color: AIColors.greyTextColor,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          info['title']!,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16.0),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: (viewModel.accountUser?.likes?.length ?? 0).socialValue,
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
          const SizedBox(height: 24.0),
          // Container(
          //   width: double.infinity,
          //   height: 200.0,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.onSecondary,
          //     borderRadius: BorderRadius.circular(16.0),
          //     boxShadow: [
          //       BoxShadow(
          //         blurRadius: 2.0,
          //         spreadRadius: 3.0,
          //         color: Theme.of(context).colorScheme.secondary.withAlpha(32),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AccountFloatingHeaderView extends ViewModelWidget<AccountProvider> {
  const AccountFloatingHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
      spacing: 12.0,
      children: [
        for (var i = 0; i < 4; i++) ...{
          Expanded(
            child: InkWell(
              onTap: () => viewModel.pageIndex = i,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border:
                      viewModel.pageIndex == i
                          ? Border(
                            bottom: BorderSide(
                              width: 2.0,
                              color: AIColors.pink,
                            ),
                          )
                          : null,
                ),
                child: Text(
                  kAccountPageTitles[i],
                  style:
                      viewModel.pageIndex == i
                          ? Theme.of(context).textTheme.bodyMedium
                          : Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ),
        },
      ],
    );
  }
}

class AccountPublicInfoView extends ViewModelWidget<UpdateProfileProvider> {
  const AccountPublicInfoView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90.0,
                height: 90.0,
                child: Stack(
                  children: [
                    ClipOval(
                      child: AIImage(
                        viewModel.account.avatar,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: viewModel.onUpdatedAvatar,
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Icon(Icons.edit, size: 18.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(viewModel.account.fullName),
                        InkWell(
                          onTap: viewModel.onUpdatedPublic,
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Icon(Icons.edit, size: 18.0)),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '#${viewModel.account.nickId}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(
                      height: 90.0,
                      child:
                          viewModel.account.desc != null
                              ? AIHelpers.htmlRender(viewModel.account.desc)
                              : Text(
                                'User can input your profile description if you didn\'t set that yet!. That will be shown to other and will make more user experience of InSoBlokAI.',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AccountPrivateInfoView extends ViewModelWidget<UpdateProfileProvider> {
  const AccountPrivateInfoView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Private Information')),
              InkWell(
                onTap: viewModel.onUpdatedPrivate,
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(Icons.edit, size: 18.0)),
                ),
              ),
            ],
          ),

          AccountPrivateInfoCover(
            leading: AIImages.icBottomMessage,
            title: viewModel.account.fullName,
          ),
          AccountPrivateInfoCover(
            leading: AIImages.icLocation,
            title: viewModel.account.city ?? 'Your City',
          ),
          AccountPrivateInfoCover(
            leading: AIImages.icLocation,
            title: viewModel.account.country ?? 'Your Country',
          ),
          AccountPrivateInfoCover(
            leading: AIImages.icLocation,
            title: 'Connect to Wallet',
          ),
          Container(
            height: 180.0,
            margin: const EdgeInsets.only(top: 24.0),
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.33,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            child:
                (viewModel.account.discovery == null)
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AIImage(AIImages.icImage, height: 32.0),
                          const SizedBox(height: 12.0),
                          Text(
                            'Discovery image',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    )
                    : AIImage(
                      viewModel.account.discovery,
                      width: double.infinity,
                      height: double.infinity,
                    ),
          ),
        ],
      ),
    );
  }
}

class AccountPrivateInfoCover extends StatelessWidget {
  final dynamic leading;
  final String title;
  final void Function()? onEdit;

  const AccountPrivateInfoCover({
    super.key,
    required this.leading,
    required this.title,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      height: 48.0,
      decoration: BoxDecoration(
        border: Border.all(width: 0.33, color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        children: [
          AIImage(
            leading,
            color: Theme.of(context).primaryColor,
            width: 18.0,
            height: 18.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

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
