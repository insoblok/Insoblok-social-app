import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

const kRewardAvatarSize = 56.0;

class AccountRewardPage extends StatelessWidget {
  const AccountRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountRewardProvider>.reactive(
      viewModelBuilder: () => AccountRewardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, null),
      builder: (context, viewModel, _) {
        var level = viewModel.userLevel;
        return Scaffold(
          appBar: AppBar(title: Text('XP Dashboard'), centerTitle: true),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(16),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  spacing: 12.0,
                  children: [
                    Row(
                      spacing: 12.0,
                      children: [
                        Stack(
                          children: [
                            AIAvatarImage(
                              viewModel.user?.avatar,
                              width: kRewardAvatarSize,
                              height: kRewardAvatarSize,
                              fullname: viewModel.user?.nickId ?? 'Test',
                              textSize: 20.0,
                              isBorder: true,
                              borderRadius: kRewardAvatarSize / 2,
                            ),
                            Container(
                              width: 24.0,
                              height: 24.0,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: AIImage(
                                AIImages.imgLevel(
                                  viewModel.userLevel.level ?? 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${viewModel.user?.fullName}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                'LEVEL ${level.level} (${viewModel.userLevel.title})',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          spacing: 8.0,
                          children: [
                            Text(
                              '${viewModel.totalScore} XP',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Text('+${viewModel.todayScore} XP today'),
                          ],
                        ),
                      ],
                    ),
                    if ((viewModel.userLevel.level ?? 0) < 5) ...{
                      const SizedBox(height: 2.0),
                      LinearProgressIndicator(
                        value: viewModel.indicatorValue,
                        minHeight: 8.0,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${level.min} XP',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            '${level.max} XP',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    },
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.0,
                children: [
                  Text(
                    'Progression Tiers',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  for (UserLevelModel level
                      in (AppSettingHelper.appSettingModel?.userLevel ??
                          [])) ...{
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color:
                            level == viewModel.userLevel
                                ? Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(16)
                                : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.0,
                        children: [
                          Container(
                            width: 56.0,
                            height: 56.0,
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withAlpha(16),
                              shape: BoxShape.circle,
                            ),
                            child: AIImage(AIImages.imgLevel(level.level!)),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 8.0,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(level.title!),
                                    Text(
                                      '${level.min} ~ ${level.max ?? ''}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Wrap(
                                  spacing: 12.0,
                                  runSpacing: 4.0,
                                  children: [
                                    for (var tag in (level.feature ?? [])) ...{
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 2.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary.withAlpha(16),
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                        child: Text(tag),
                                      ),
                                    },
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                ],
              ),
              const SizedBox(height: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activities',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      InkWell(
                        onTap: () => Routers.goToRewardDetailPage(context),
                        child: Text(
                          'View All ▶',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  for (var i = 0; i < min(3, viewModel.scores.length); i++) ...{
                    ScoreItemView(score: viewModel.scores[i]),
                  },
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
