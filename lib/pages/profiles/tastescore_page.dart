import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

const kUserAvatarSize = 56.0;

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
              Column(
                spacing: 8.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 60.0,
                        child: Column(
                          spacing: 12.0,
                          children: [
                            AIImage(AIImages.icFire, width: 24.0, height: 24.0),
                            Text(
                              '${viewModel.todayScore} XP',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum:
                                  (viewModel.userLevel.min ?? 0).toDouble(),
                              maximum:
                                  (viewModel.userLevel.max ?? 0).toDouble(),
                              pointers: <GaugePointer>[],
                              showLabels: false,
                              showTicks: false,
                              showFirstLabel: true,
                              showLastLabel: true,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue:
                                      (viewModel.userLevel.min ?? 0).toDouble(),
                                  endValue: viewModel.totalScore.toDouble(),
                                  color: Theme.of(context).primaryColor,
                                ),
                                GaugeRange(
                                  startValue: viewModel.totalScore.toDouble(),
                                  endValue:
                                      (viewModel.userLevel.max ?? 0).toDouble(),
                                  color: Colors.grey,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Your', textAlign: TextAlign.center),
                                      Text(
                                        'Tastescore'.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleSmall,
                                      ),
                                      Text(
                                        '${viewModel.totalScore}',
                                        style: TextStyle(
                                          fontSize: 36.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60.0,
                        child: Column(
                          spacing: 12.0,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              'Top ${100 - viewModel.userRank + 1}%\nglobally',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(16),
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
                          child: AIImage(
                            AIImages.imgLevel(viewModel.userLevel.level!),
                          ),
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
                                  Text(viewModel.userLevel.title!),
                                  Text(
                                    '${viewModel.userLevel.min} ~ ${viewModel.userLevel.max ?? ''}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Wrap(
                                spacing: 12.0,
                                runSpacing: 4.0,
                                children: [
                                  for (var tag
                                      in (viewModel.userLevel.feature ??
                                          [])) ...{
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
                ],
              ),
              const SizedBox(height: 24.0),
              Text('XPTONEXT', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12.0),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+${viewModel.todayScore} XP today',
                      textAlign: TextAlign.end,
                    ),
                    if ((viewModel.userLevel.level ?? 0) < 5) ...{
                      LinearProgressIndicator(
                        value: viewModel.indicatorValue,
                        backgroundColor: AIColors.pink.withAlpha(32),
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
              Text('RANK', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12.0),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if ((viewModel.userLevel.level ?? 0) < 5) ...{
                      LinearProgressIndicator(
                        value: viewModel.rankIndicatorValue,
                        minHeight: 16.0,
                        color: AIColors.blue,
                        backgroundColor: AIColors.blue.withAlpha(32),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top ${100 - viewModel.userRank + 1} %',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          Text(
                            'Top 100 %',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    },
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
