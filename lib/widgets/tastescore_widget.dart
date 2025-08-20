import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class TastescoreRemarkView extends ViewModelWidget<AccountRewardProvider> {
  const TastescoreRemarkView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
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
            animationDuration: 3000,
            enableLoadingAnimation: true,
            axes: <RadialAxis>[
              RadialAxis(
                minimum: (viewModel.userLevel.min ?? 0).toDouble(),
                maximum: (viewModel.userLevel.max ?? 0).toDouble(),
                pointers: <GaugePointer>[],
                showLabels: false,
                showTicks: false,
                showFirstLabel: true,
                showLastLabel: true,
                ranges: <GaugeRange>[
                  GaugeRange(
                    startValue: (viewModel.userLevel.min ?? 0).toDouble(),
                    endValue: viewModel.totalScore.toDouble(),
                    color: Theme.of(context).primaryColor,
                  ),
                  GaugeRange(
                    startValue: viewModel.totalScore.toDouble(),
                    endValue: (viewModel.userLevel.max ?? 0).toDouble(),
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
                          style: Theme.of(context).textTheme.titleSmall,
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
              Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
              Text(
                'Top ${100 - viewModel.userRank + 1}%\nglobally',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

const kTastescoreAvatarSize = 40.0;

class TastescoreAvatarView extends ViewModelWidget<AccountRewardProvider> {
  const TastescoreAvatarView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      spacing: 12.0,
      children: [
        Row(
          children: [
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16.0),
                  child: AIImage(viewModel.owner?.avatar, width: 240.0),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: kTastescoreAvatarSize,
              height: kTastescoreAvatarSize,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopify,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            for (
              var i = 0;
              i < min(3, viewModel.usersScoreList.length);
              i++
            ) ...{
              TastescoreUserView(
                key: GlobalKey(debugLabel: viewModel.usersScoreList[i].id),
                userId: viewModel.usersScoreList[i].id,
                score: viewModel.usersScoreList[i].xpTotal,
              ),
            },
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ],
    );
  }
}

class TastescoreUserView extends StatelessWidget {
  final String userId;
  final int score;

  const TastescoreUserView({
    super.key,
    required this.userId,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, id: userId, score: score),
      builder: (context, viewModel, _) {
        var userData = viewModel.owner;
        return Row(
          spacing: 8.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            userData == null
                ? ShimmerContainer(
                  child: Container(
                    width: kTastescoreAvatarSize,
                    height: kTastescoreAvatarSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                : userData.avatarStatusView(
                  width: kTastescoreAvatarSize,
                  height: kTastescoreAvatarSize,
                  borderWidth: 3.0,
                  textSize: 18.0,
                  showStatus: false,
                ),
            Text('$score'),
          ],
        );
      },
    );
  }
}

class TastescoreLevelView extends ViewModelWidget<AccountRewardProvider> {
  const TastescoreLevelView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var level = viewModel.userLevel;
    return Column(
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
            color: Theme.of(context).colorScheme.secondary.withAlpha(16),
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
                  color: Theme.of(context).colorScheme.secondary.withAlpha(16),
                  shape: BoxShape.circle,
                ),
                child: AIImage(AIImages.imgLevel(viewModel.userLevel.level!)),
              ),
              Expanded(
                child: Column(
                  spacing: 8.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(viewModel.userLevel.title!),
                        Text(
                          '${viewModel.userLevel.min} ~ ${viewModel.userLevel.max ?? ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 12.0,
                      runSpacing: 4.0,
                      children: [
                        for (var tag
                            in (viewModel.userLevel.feature ?? [])) ...{
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondary.withAlpha(16),
                              borderRadius: BorderRadius.circular(8.0),
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
    );
  }
}

class TastescoreXpNextView extends ViewModelWidget<AccountRewardProvider> {
  const TastescoreXpNextView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var level = viewModel.userLevel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('XPTONEXT', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                  Container(
                    width: kTastescoreAvatarSize,
                    height: kTastescoreAvatarSize,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Notify Me When My Score Changes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Switch(
                    value: true,
                    onChanged: (value) {},
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    activeTrackColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              if ((viewModel.userLevel.level ?? 0) < 5) ...{
                AnimatiedLinearProgressIndicator(
                  value: viewModel.indicatorValue,
                  backgroundColor: AIColors.pink.withAlpha(32),
                  minHeight: 16.0,
                  borderRadius: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${level.min} XP',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '+${viewModel.todayScore} XP today',
                      textAlign: TextAlign.end,
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
      ],
    );
  }
}

class TastescoreRankView extends ViewModelWidget<AccountRewardProvider> {
  const TastescoreRankView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RANK', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(16),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            spacing: 12.0,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                spacing: 12.0,
                children: [
                  Container(
                    width: kTastescoreAvatarSize,
                    height: kTastescoreAvatarSize,
                    decoration: BoxDecoration(
                      color: AIColors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'TasteSignal Pluse',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '#monochrome',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              if ((viewModel.userLevel.level ?? 0) < 5) ...{
                AnimatiedLinearProgressIndicator(
                  value: viewModel.rankIndicatorValue,
                  minHeight: 16.0,
                  color: AIColors.blue,
                  backgroundColor: AIColors.blue.withAlpha(32),
                  borderRadius: 8.0,
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
    );
  }
}
