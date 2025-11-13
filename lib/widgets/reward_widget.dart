import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class RewardTierView extends ViewModelWidget<AccountRewardProvider> {
  const RewardTierView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.0,
      children: [
        Text(
          'Progression Tiers',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        for (UserLevelModel level
            in (AppSettingHelper.appSettingModel?.userLevel ?? [])) ...{
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  level == viewModel.userLevel
                      ? Theme.of(context).colorScheme.secondary.withAlpha(16)
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(level.title!),
                          Text(
                            '${level.min} ~ ${level.max ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall,
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
        },
      ],
    );
  }
}

class RewardTransferView extends ViewModelWidget<AccountRewardProvider> {
  const RewardTransferView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(16),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            'Available : ${viewModel.availableXP} XP',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              for (XpInSoModel inSoModel
                  in (AppSettingHelper.appSettingModel?.xpInso ?? [])) ...{
                InkWell(
                  onTap: () {
                    viewModel.selectInSo(inSoModel);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          viewModel.selectXpInSo == inSoModel
                              ? AIColors.pink
                              : Theme.of(
                                context,
                              ).colorScheme.secondary.withAlpha(16),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '${inSoModel.max}\n'),
                          TextSpan(
                            text: '(${inSoModel.max! * inSoModel.rate! / 100})',
                            style: const TextStyle(
                              fontSize: 12,
                            ), // smaller second line
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            viewModel.selectXpInSo == inSoModel
                                ? AIColors.white
                                : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: '0',
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          textDirection: TextDirection.rtl,
                          controller: viewModel.textController,
                          onChanged: (value) {
                            viewModel.setXpValue(value);
                          },
                        ),
                      ),
                      Text('  XP', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Text('to', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Text(
                        '${viewModel.convertedInSo()}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('  INSO', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              TextFillButton(
                onTap: () {
                  viewModel.convertXPtoINSO();
                },
                height: 36,
                isBusy: viewModel.isBusy,
                color:
                    viewModel.isPossibleConvert
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary.withAlpha(64),
                text: 'Convert XP to INSO',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
