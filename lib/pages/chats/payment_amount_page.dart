import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class PaymentAmountPage extends StatelessWidget {
  
  PaymentAmountPage({super.key});

  @override build(BuildContext context) {
    return ViewModelBuilder<PaymentAmountProvider>.reactive(
      viewModelBuilder: () => PaymentAmountProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        final network = kWalletTokenList.firstWhere((tk) => tk["chain"] == viewModel.selectedNetwork);
        return Scaffold(
          appBar: AppBar(
            title: Text("P2P Payment Amount"),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 48.0),
                  child: Column(
                    spacing: 12.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tokens'),
                          GestureDetector(
                            onTap:() {
                              viewModel.controller.value = (viewModel.allBalances[viewModel.selectedNetwork] ?? "").toString();
                              viewModel.amount = (viewModel.allBalances[viewModel.selectedNetwork] ?? 0);
                            },
                            child: Text("Use Max")
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: kNoBorderDecoration,
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: viewModel.selectedNetwork,
                                dropdownColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                underline: Container(),
                                items:
                                  kWalletTokenList.map((ethInfo) {
                                    final chainValue = (ethInfo["chain"] ?? "") as String;
                                    return DropdownMenuItem(
                                      value: chainValue,
                                      child: Text(
                                        ((ethInfo['short_name'] ?? "") as String).toUpperCase(),
                                        style:
                                            Theme.of(context).textTheme.bodySmall,
                                      ),
                                    );
                                  }).toList(),
                                onChanged: (newValue) {
                                  viewModel.selectedNetwork = newValue!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Balance: ${viewModel.allBalances[viewModel.selectedNetwork] ?? "" } ${network["short_name"]}'),
                      ),
                      const SizedBox(height: 16.0),
                      // Row(
                      //   children: [
                      //     AITextField(
                      //       onChanged: (value) {
                      //         viewModel.setPaymentAmount(double.parse(value));
                      //       }
                      //     )
                      //   ]
                      // ),
                      NumberPlateWidget(
                        controller: viewModel.controller,
                        onChanged: (input) {
                          viewModel.updateAmount(input);
                        }
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 72),
                  child: GradientPillButton(
                    text: "Preview",
                    onPressed: () {
                      viewModel.handleClickPreview(context);
                    }
                  )
                ),
              ],
            )
                  
          )
        );
      }
    );
    
  }
}