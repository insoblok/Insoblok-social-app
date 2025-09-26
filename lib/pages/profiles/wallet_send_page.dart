import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletSendPage extends StatelessWidget {
  const WalletSendPage({super.key});
  
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, "", "", "", 0),
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('My Wallet'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: viewModel.isBusy ? 
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Loader(
                    color: Colors.pink,
                    size: 60
                  ),
                  SizedBox(height: 18),
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 20
                    )
                  ),
                ],
              ) 
            ) :
            ListView(
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
                          ClipOval(
                            child: Container(
                              color: Colors.grey.shade400,
                              child: AIImage(
                                token["icon"],
                                width: 36.0,
                                height: 36.0,
                              ),
                            ),
                          ),
                          Expanded(child: Text(token['short_name']!.toString())),
                          Text(
                                '${AIHelpers.formatDouble(viewModel.allBalances?[token["chain"]] ?? 0, 10)} ${token["short_name"]}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 48.0),
                GradientPillButton(
                  text: "Next",
                  onPressed: () {
                    viewModel.handleClickNextOnSendPage(context);
                  },
                  loading: viewModel.isBusy,
                  loadingText: "... Loading ",
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
