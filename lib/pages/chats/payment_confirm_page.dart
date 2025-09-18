import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';

class PaymentConfirmPage extends StatelessWidget {
  final Map<String, dynamic> args;
  const PaymentConfirmPage({super.key, required this.args});

  @override build(BuildContext context) {
    logger.d("Payment information is $args");
    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, args["sender"].toString(), args["receiver"].toString(), args["network"].toString(), double.parse(args["amount"].toString())),
      builder: (context, viewModel, _) {
        final network = kWalletTokenList.firstWhere((tk) => tk["chain"].toString() == viewModel.network);
        final price = viewModel.amount! * viewModel.allPrices[viewModel.network!]!;
        final fee = viewModel.transactionFee * (viewModel.allPrices[viewModel.network!] ?? 0).toDouble();
        final totalPrice = price + fee;
        return Scaffold(
          appBar: AppBar(
            title: Text("P2P Payment Amount Confirm"),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                          spacing: 12.0,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                
                                  "\$${ (price).toStringAsFixed(2) }",
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold 
                                  )
                                ),
                                
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AIImage(network["icon"], width: 32.0, height: 32.0),
                                const SizedBox(width: 12.0),
                                Text(
                                  "${AIHelpers.formatDouble(viewModel.amount ?? 0, 10) ?? 0} ${network['short_name'] ?? ""}",
                                  style: TextStyle(
                                    fontSize: 24
                                  )
                                )
                              ],
                            ),
                          ]
                      )
                    ),
                    Divider(
                      color: Colors.blueGrey
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "To",
                                style: TextStyle(
                                  fontSize:16,
                                  fontWeight: FontWeight.bold
                      
                                )
                              ),
                              Text(viewModel.receiver ?? "",
                                style: TextStyle(
                                  fontSize: 14
                                )
                              )
                            ]
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Network", 
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    network["displayName"].toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                    )
                                  )
                                ]
                              )
                            ]
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Network fee", 
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    "${viewModel.transactionFee.toString()} ${network['short_name']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    )
                                  )
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "\$$fee",
                                    style: TextStyle(
                                      fontSize: 16,
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Spend time", 
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    'Est. less than 10 minutes',
                                    style: TextStyle(
                                      fontSize: 16,
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total", 
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    "\$${ totalPrice.toStringAsFixed(2) }",
                                    style: TextStyle(
                                      fontSize: 16,
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ]
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0, left: 24.0, right: 24.0, bottom: 72),
                  child: GradientPillButton(
                      text: "Send Now",
                      loading: viewModel.isBusy,
                      loadingText: "Sending ...",
                      onPressed: () async {
                        await viewModel.handleClickSend(context);
                      }
                    ),
                )
              ],
            ),
          )
        );
      
      }
    );
  }

}