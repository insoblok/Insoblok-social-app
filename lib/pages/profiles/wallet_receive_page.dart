import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';

import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletReceivePage extends StatelessWidget {
  const WalletReceivePage({super.key});
  
  String formatDouble(double value, int decimals) {
    return value.toStringAsFixed(decimals).replaceFirst(RegExp(r'\.?0+$'), '');
  }
  @override
  Widget build(BuildContext context) {

    final allBalances = ModalRoute.of(context)!.settings.arguments as Map<String, double>;

    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
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
                Container(
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
                      for (var token in kWalletTokenList) ... [
                        Row(
                        spacing: 12.0,
                        children: [
                          AIImage(
                            token['icon'],
                            width: 36.0,
                            height: 36.0,
                          ),
                          Expanded(child: Text(token['short_name']!.toString())),
                          Text(
                                '${formatDouble(allBalances[token["chain"]] ?? 0, 10)} ${token["short_name"]}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Select from Token',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12,
                    children: [
                      for (var i = 0; i < kWalletTokenList.length; i++) ...{
                        TagView(
                          tag: kWalletTokenList[i]['name'].toString() ?? 'tag',
                          height: 34,
                          isSelected:
                              viewModel.selectedFromToken == i ? true : false,
                          textSize: 14.0,
                          onTap: () {
                            viewModel.selectFromToken(i);
                          },
                        ),
                      },
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  decoration: kCardDecoration,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    textDirection: TextDirection.rtl,
                    controller: viewModel.sendTokenTextController,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Receiver',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 15.0),
                Container(
                  decoration: kCardDecoration,
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: '',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    textDirection: TextDirection.rtl,
                    controller: viewModel.receiverTextController,
                  ),
                ),
                const SizedBox(height: 48.0),
                TextFillButton(
                  onTap: () {
                    viewModel.sendToken();
                  },
                  height: 48,
                  isBusy: viewModel.isBusy,
                  color:
                      viewModel.selectedFromToken !=
                                  viewModel.selectedToToken &&
                              viewModel.isPossibleConvert
                          ? Theme.of(context).primaryColor
                          : Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(64),
                  text:
                      'Send ${kWalletTokenList[viewModel.selectedFromToken]['name'] ?? 'tag'}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
