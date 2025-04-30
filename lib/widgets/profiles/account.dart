import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AccountPresentHeaderView extends ViewModelWidget<AccountProvider> {
  const AccountPresentHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      color: AppSettingHelper.background,
      child: SizedBox(
        height: 135.0 + kAccountAvatarSize / 2.0,
        child: Stack(
          children: [
            AIImage(
              viewModel.accountUser?.discovery ?? AIImages.imgBackSplash,
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
                  border: Border.all(width: 2.0, color: AIColors.blue),
                  borderRadius: BorderRadius.circular(kAccountAvatarSize / 2.0),
                ),
                child: ClipOval(child: AIImage(viewModel.accountUser?.avatar)),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36.0,
                height: 36.0,
                margin: EdgeInsets.only(
                  left: 20.0,
                  top: MediaQuery.of(context).padding.top + 12.0,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppSettingHelper.transparentBackground,
                ),
                child: Icon(Icons.arrow_back, size: 18.0),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
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
          Text(
            viewModel.accountUser?.fullName ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            '@${viewModel.accountUser?.nickId}',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12.0),
          Text(
            viewModel.accountUser?.desc ??
                'User can input your profile description if you didn\'t set that yet!. That will be shown to other and will make more user experience of InSoBlokAI.',
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
                (viewModel.accountUser?.linkInfo ?? []).map((info) {
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
                        style: Theme.of(context).textTheme.labelMedium,
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
        for (var i = 0; i < 3; i++) ...{
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
                              color: AIColors.blue,
                            ),
                          )
                          : null,
                ),
                child: Text(
                  kAccountPageTitles[i],
                  style:
                      viewModel.pageIndex == i
                          ? Theme.of(context).textTheme.bodySmall
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
