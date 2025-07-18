import 'dart:math';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

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
          appBar: AppBar(
            title: Text('XP Dashboard'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: ListView(
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
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withAlpha(16),
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            spacing: 8.0,
                            children: [
                              Text(
                                '${viewModel.totalScore} XP',
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text('+${viewModel.todayScore} XP today'),
                            ],
                          ),
                        ],
                      ),
                      if ((viewModel.userLevel.level ?? 0) < 5) ...{
                        const SizedBox(height: 2.0),
                        AnimatiedLinearProgressIndicator(
                          value: viewModel.indicatorValue,
                          minHeight: 8.0,
                          borderRadius: 4.0,
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
                const SizedBox(height: 8),
                RewardTransferView(),
                const SizedBox(height: 16.0),
                RewardTierView(),
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
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (viewModel.scores.isEmpty) ...{
                      SafeArea(
                        child: InSoBlokEmptyView(desc: 'XRP History is empty!'),
                      ),
                    } else ...{
                      for (
                        var i = 0;
                        i < min(3, viewModel.scores.length);
                        i++
                      ) ...{ScoreItemView(score: viewModel.scores[i])},
                    },
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
