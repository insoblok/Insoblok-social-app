import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletActivitiesPage extends StatelessWidget {
  const WalletActivitiesPage({super.key});


  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case "success":
        bgColor = Colors.green;
        break;
      case "pending":
        bgColor = Colors.orange;
        break;
      case "failed":
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountWalletProvider>.reactive(
    viewModelBuilder: () => AccountWalletProvider(),
    onViewModelReady: (viewModel) => viewModel.init(context),
    builder: (context, viewModel, _) {

      
        return Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () async {
                                  // Open the modal and wait for the result
                                  
                                  final result = await showModalBottomSheet<
                                    Map<String, dynamic>
                                  >(
                                    context: context,
                                    isScrollControlled: true,
                                    builder:
                                        (
                                          context,
                                        ) { 
                                          return NetworkSelectionModal(
                                          // Pass initial state to the modal
                                            initialSelected:
                                                viewModel.enabledNetworks,
                                          );
                                        }
                                  );
                                  if (result != null) {
                                    viewModel.enabledNetworks =
                                        result["enabledNetworks"];
                                    viewModel.setEnabledNetworks(result["enabledNetworks"]);
                                  }
                                  
                                },
                                child: Row(
                                  children: [
                                    viewModel.enabledNetworks.length == 1 ? 
                                    AIImage(
                                      viewModel.enabledNetworks[0]["icon"],
                                      width: 24,
                                      height: 24,
                                    ) :
                                    Text(
                                      viewModel.networkString,
                                      style: TextStyle(),
                                    ),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              // This Expanded is now a direct child of Row
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  iconStyleData: const IconStyleData(
                                    icon: SizedBox.shrink(),
                                  ),
                                  isExpanded: false,
                                  hint: Icon(Icons.menu),
                                  alignment: AlignmentDirectional.centerEnd,
                                  onChanged: (value) {
                                    
                                  },
                                  dropdownStyleData: DropdownStyleData(
      // Padding inside the dropdown menu
                                    padding: EdgeInsets.all(8),
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: "Action",
                                      child: AccountWalletIconCover(
                                        child: AIImage(
                                          AIImages.icRefresh,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {
                                          viewModel.init(context);

                                        }
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "Another action",
                                      child: AccountWalletIconCover(
                                        child: AIImage(
                                          AIImages.icCamera,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "Something else here",
                                      child: AccountWalletIconCover(
                                        child: AIImage(
                                          AIImages.icMenuQrCode,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: "Something else here",
                                      child: AccountWalletIconCover(
                                        child: AIImage(
                                          AIImages.icBottomNoti,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.0),
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                transform: GradientRotation(109.6 * 3.1415926535 / 180), // convert degrees to radians
                                stops: [0.112, 0.537, 1.002], // match CSS percentage stops
                                colors: [
                                  Color.fromRGBO(9, 9, 121, 1),    // rgba(9,9,121,1)
                                  Color.fromRGBO(144, 6, 161, 1),  // rgba(144,6,161,1)
                                  Color.fromRGBO(0, 212, 255, 1),  // rgba(0,212,255,1)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${viewModel.totalBalance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: BoxBorder.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(24) 
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  viewModel.onClickActions(0);
                                },
                                icon: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6), // space inside the circle
                                  child: const Icon(
                                    Icons.call_made, // ↗ similar icon
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                label: Text(
                                  "Send",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.only(left: 4, right: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30), // pill shape
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: BoxBorder.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(24) 
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  viewModel.onClickActions(1);
                                },
                                icon: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6), // space inside the circle
                                  child: const Icon(
                                    Icons.call_received, // ↗ similar icon
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                label: Text(
                                  "Receive",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.only(left: 4, right: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30), // pill shape
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: BoxBorder.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(24) 
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  viewModel.onClickActions(2);
                                },
                                icon: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6), // space inside the circle
                                  child: const Icon(
                                    Icons.swap_horiz, // ↗ similar icon
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                ),
                                label: Text(
                                  "Swap",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.only(left: 4, right: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30), // pill shape
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          children: [
                            for (var token in viewModel.filteredTransactions) ...[
                              token["chain"] != null ?
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  margin: const EdgeInsets.only(
                                    bottom: 8.0,
                                  ),
                                  // decoration: BoxDecoration(
                                  //   color: Theme.of(context)
                                  //       .colorScheme
                                  //       .secondary
                                  //       .withAlpha(18),
                                  //   borderRadius: BorderRadius.circular(
                                  //     8.0,
                                  //   ),
                                  // ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withAlpha(30),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(20), // shadow color with opacity
                                        spreadRadius: 2, // how much the shadow spreads
                                        blurRadius: 1,   // how soft the shadow looks
                                        offset: Offset(5, 5), // changes the shadow position (x, y)
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // AIImage(token["icon"], width: 36.0, height: 36.0),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                WalletAddressWidget(
                                                  address:
                                                      token["from_address"] ??
                                                      '',
                                                ),
                                                const Text("=> "),
                                                WalletAddressWidget(
                                                  address:
                                                      token["to_address"] ??
                                                      '',
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${AIHelpers.formatDouble(token["amount"] ?? 0, 10)} ${token["short_name"] ?? ""}',
                                                  style:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .labelSmall,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    logger.d(
                                                      "Token is $token",
                                                    );
                                                    AIHelpers.launchExternalSource(
                                                      '${token["scanUrl"]}/${token["tx_hash"]}',
                                                    );
                                                  },
                                                  child: Text(
                                                    'View Transaction',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blueAccent,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .end,
                                                  children: [
                                                    Text(
                                                      '\$${(viewModel.tokenValues[token["chain"]] ?? 0).toStringAsFixed(2)}',
                                                      style:
                                                          Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .headlineMedium,
                                                    ),
                                                    const SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    _buildStatusBadge(
                                                      token["status"] ??
                                                          '',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ) :
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(
                                  bottom: 8.0,
                                ),
                                // decoration: BoxDecoration(
                                //   color: Theme.of(context)
                                //       .colorScheme
                                //       .secondary
                                //       .withAlpha(18),
                                //   borderRadius: BorderRadius.circular(
                                //     8.0,
                                //   ),
                                // ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                "${token['from_amount'] ?? '0'}  ${token['from_network_short_name'] ?? ''}",
                                              ),
                                              Text(
                                                "\$${((token['from_amount']) ?? 0) * (viewModel.allPrices?[token["from_network"]] ?? 0)}"
                                              )
                                            ],
                                          ),
                                          Text("  ===>  "),
                                          Column(
                                            children: [
                                              Text(
                                                "${token['to_amount'] ?? '0'}  ${token['to_network_short_name'] ?? ''}",
                                              ),
                                              Text(
                                                "\$${((token['to_amount']) ?? 0) * (viewModel.allPrices?[token["to_network"]] ?? 0)}"
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Opacity(opacity: 0),
                                          GestureDetector(
                                            onTap: () {
                                              logger.d(
                                                "Token is $token",
                                              );
                                              AIHelpers.launchExternalSource(
                                                '${token["to_network_scanUrl"]}/${token["tx_hash"]}',
                                              );
                                            },
                                            child: Text(
                                              'View Transaction',
                                              style: TextStyle(
                                                color:
                                                    Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                          _buildStatusBadge(
                                            token["status"] ??
                                                '',
                                          ),
                                        ]
                                      )
                                    ] 
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              )
            )
        );
      }
    );
  }
}