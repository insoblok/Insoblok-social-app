import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container(
                //   width: double.infinity,
                //   height: 52.0,
                //   decoration: BoxDecoration(
                //     color: AIColors.appScaffoldBackground,
                //     borderRadius: BorderRadius.circular(12.0),
                //     boxShadow: [
                //       BoxShadow(
                //         offset: Offset(4.0, 4.0),
                //         color: Colors.black12,
                //         blurRadius: 3.0,
                //         spreadRadius: 3.0,
                //       ),
                //       BoxShadow(
                //         offset: Offset(-2.0, -2.0),
                //         color: Colors.white12,
                //         blurRadius: 1.0,
                //         spreadRadius: 1.0,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 24.0),
                AITextField(
                  hintText: 'Ethereum Address',
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  onChanged: (value) => viewModel.address = value,
                ),
                const SizedBox(height: 24.0),
                AITextField(
                  hintText: 'Ethereum Amount (wei)',
                  prefixIcon: Icon(Icons.code_rounded),
                  onChanged: (value) => viewModel.amount = value,
                ),
                const SizedBox(height: 40.0),
                Row(
                  children: [
                    const SizedBox(width: 32.0),
                    Expanded(
                      child: OutlineButton(
                        isBusy: viewModel.isBusy,
                        onTap: () => viewModel.onClickTestDemo(),
                        borderColor: AIColors.yellow,
                        child: Text(
                          'Buy ETH by Metamask',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AIColors.yellow,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32.0),
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
