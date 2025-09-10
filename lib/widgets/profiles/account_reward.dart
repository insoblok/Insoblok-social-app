import 'package:flutter/material.dart';
import 'package:insoblok/widgets/linear_progress_widget.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';

class AccountXPDashboardView extends ViewModelWidget<AccountProvider> {
  const AccountXPDashboardView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    if (viewModel.isLoadingScore) {
      return Container();
    }
    var level = viewModel.userLevel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RRC Image',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Spacer(),
              Transform.scale(
                scale: 0.8, // << make it smaller (try 0.7–0.9)
                alignment: Alignment.centerRight,
                child: Switch.adaptive(
                  value: viewModel.isRRCImage,
                  onChanged: viewModel.setRRCImage,
                  activeColor: Theme.of(context).primaryColor,

                  // Optional: reduce minimum tap target from 48px
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),


          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⭐  XP Dashboard',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (viewModel.isMe)
                InkWell(
                  onTap: () => Routers.goToAccountRewardPage(context),
                  child: Text(
                    'More Detail ▶',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
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
            child: Row(
              spacing: 24.0,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${viewModel.totalScore}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            TextSpan(
                              text: ' XP',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${(level.max ?? 0) - viewModel.totalScore} XP',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: ' to next milestone',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                      if ((viewModel.userLevel.level ?? 0) < 5) ...{
                        const SizedBox(height: 2.0),
                        AnimatiedLinearProgressIndicator(
                          value: viewModel.indicatorValue,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8.0,
                  children: [
                    Text(
                      'LEVEL ${viewModel.userLevel.level}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Tier: ',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          TextSpan(
                            text: '${viewModel.userLevel.max} XP',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
