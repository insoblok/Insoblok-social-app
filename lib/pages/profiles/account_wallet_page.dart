import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

final kWalletTokenList = [
  {'name': 'INSO', 'short_name': 'INSO', 'icon': AIImages.icCoinInso},
  {'name': 'USDT', 'short_name': 'USDT', 'icon': AIImages.icCoinUsdt},
  {'name': 'XRP', 'short_name': 'XRP', 'icon': AIImages.icCoinXrp},
];

const kWalletActionList = [
  {'name': 'Buy', 'icon': Icons.add},
  {'name': 'Send', 'icon': Icons.arrow_upward},
  {'name': 'Receive', 'icon': Icons.arrow_downward},
  {'name': 'Swap', 'icon': Icons.swap_calls},
  {'name': 'Bridge', 'icon': Icons.link},
];

class AccountWalletPage extends StatelessWidget {
  const AccountWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () => AccountWalletProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Wallet'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              children: [
                Row(
                  children: [
                    AIAvatarImage(
                      viewModel.user?.avatar,
                      width: 60,
                      height: 60,
                      fullname: viewModel.user?.nickId ?? 'Test',
                      textSize: 24,
                      isBorder: true,
                      borderWidth: 3,
                      borderRadius: 30,
                    ),
                    Expanded(
                      child: Row(
                        spacing: 16.0,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AccountWalletIconCover(
                            child: AIImage(
                              AIImages.icCamera,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          AccountWalletIconCover(
                            child: AIImage(
                              AIImages.icMenuQrCode,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          AccountWalletIconCover(
                            child: AIImage(
                              AIImages.icBottomNoti,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                ValueListenableBuilder<String>(
                  valueListenable:
                      viewModel.reownService.appKitModel.balanceNotifier,
                  builder: (_, balance, _) {
                    return Text(
                      balance,
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  },
                ),
                const SizedBox(height: 40.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    spacing: 12.0,
                    children: [
                      for (var item in kWalletTokenList) ...{
                        AccountWalletTokenCover(
                          child: Column(
                            children: [
                              Text(
                                item['name']!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text('${item['short_name']} 0.00'),
                            ],
                          ),
                        ),
                      },
                      Container(
                        width: 160.0,
                        height: 80.0,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var item in kWalletActionList) ...{
                      InkWell(
                        onTap:
                            () => viewModel.onClickActions(
                              kWalletActionList.indexOf(item),
                            ),
                        child: Column(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(16),
                                // border: Border.all(
                                //   color: Theme.of(context).primaryColor,
                                // ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: AIImage(item['icon']),
                            ),
                            const SizedBox(height: 8.0),
                            Text(item['name'] as String),
                          ],
                        ),
                      ),
                    },
                  ],
                ),
                const SizedBox(height: 24.0),
                Row(
                  spacing: 12.0,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppSettingHelper.greyBackground,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'Assets',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppSettingHelper.greyBackground,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        'Collectibles',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Row(
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(16),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.0,
                          children: [
                            AIImage(
                              AIImages.icCoinInso,
                              width: 36.0,
                              height: 36.0,
                            ),
                            Text('Ways to buy'),
                            Text(
                              'Via card or bank',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(16),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.0,
                          children: [
                            AIImage(
                              AIImages.icCoinInso,
                              width: 36.0,
                              height: 36.0,
                            ),
                            Text('Receive'),
                            Text(
                              'Deposit to your wallet',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                for (var item in kWalletTokenList) ...{
                  const SizedBox(height: 24.0),
                  Row(
                    spacing: 12.0,
                    children: [
                      AIImage(item['icon'], width: 36.0, height: 36.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'] as String),
                            Text(
                              '0 ${item['short_name']}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$0.00',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
