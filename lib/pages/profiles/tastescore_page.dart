import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class TastescorePage extends StatelessWidget {
  final UserModel? user;
  const TastescorePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountRewardProvider>.reactive(
      viewModelBuilder: () => AccountRewardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, user),
      builder: (context, viewModel, _) {
        var level = viewModel.userLevel;
        return Scaffold(
          appBar: AppBar(title: Text('TASTESCORE'), centerTitle: true),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            '${viewModel.owner?.fullName}',
                            style: Theme.of(context).textTheme.titleSmall,
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
                        minHeight: 16.0,
                        borderRadius: BorderRadius.circular(8.0),
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
                    'LEVEL ${level.level} (${viewModel.userLevel.title})',
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
            ],
          ),
        );
      },
    );
  }
}
