import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class PaymentAmountPage extends StatelessWidget {
  final Map<String, dynamic> args;
  PaymentAmountPage({super.key, required this.args});

  @override build(BuildContext context) {
    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, args["sender"].toString(), args["receiver"].toString(), args["network"].toString(), double.parse(args["amount"].toString())),
      builder: (context, viewModel, _) {
        print("network is ${viewModel.network}");
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
                              viewModel.handleClickMax();
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
                                value: viewModel.network,
                                dropdownColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                underline: Container(),
                                items:
                                  kWalletTokenList.map((ethInfo) {
                                    final chainValue = (ethInfo["chain"] ?? "").toString();
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
                                  if(newValue == null) return;
                                  viewModel.network = newValue;
                                  viewModel.selectedNetwork = kWalletTokenList.firstWhere((one) => one["chain"].toString() == newValue);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Balance: ${viewModel.allBalances[viewModel.network] ?? "0" } ${viewModel.selectedNetwork["short_name"] ?? ""}'),
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