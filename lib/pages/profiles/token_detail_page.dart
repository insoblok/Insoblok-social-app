import 'package:flutter/material.dart';
import 'package:reown_appkit/modal/pages/preview_send/utils.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';


class TokenDetailPage extends StatelessWidget {
  final Map<String, dynamic> network;
  const TokenDetailPage({super.key, required this.network});
  
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () => AccountWalletProvider(),
      onViewModelReady: (viewModel) async { 
        await viewModel.init(context);
        logger.d("getting token details");
        await viewModel.getTokenDetails(network["coingecko_id"]);
      },
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.grey.shade400,
                          child: AIImage(
                            network["icon"],
                            width: 36.0,
                            height: 36.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        network["displayName"],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  
                ],
              ),
            ),
            actions: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800, // background color
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        viewModel.toggleFavorite(network["chain"]);
                      },
                      icon: Icon(viewModel.checkFavorite(network["chain"]) == true ? Icons.star : Icons.star_border),
                      color: Colors.amberAccent,
                      iconSize: 20,
                    ),
                  ),
                )
            ],
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: SafeArea(
            child: AppBackgroundView(
              child: viewModel.isBusy ?
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Loader(
                        size: 60.0,
                        color: Colors.pink
                      ),
                      Text(
                        "",
                        style: TextStyle(fontSize: 24)
                      )
                    ]
                  )
                ) :Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "\$ ",
                                style: Theme.of(context).textTheme.labelLarge
                              ),
                              Text(
                                AIHelpers.formatNumbers((viewModel.tokenDetails["market_data"]?["current_price"]?["usd"] ?? 0).toDouble()),
                                style: Theme.of(context).textTheme.titleLarge
                              ),
                              Text(" USD",
                                style: Theme.of(context).textTheme.labelLarge
                              )
                            ],
                          ),
                          Text(
                            "${(viewModel.tokenDetails["market_data"]?["price_change_percentage_24h"] ?? 0) > 0 ? '+' : ''}${viewModel.tokenDetails["market_data"]["price_change_percentage_24h"] ?? 0} %",
                            style: TextStyle(
                              color: (viewModel.tokenDetails["market_data"]?["price_change_percentage_24h"] ?? 0) > 0 ? Colors.greenAccent : Colors.redAccent

                            )

                          )
                        ]
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: viewModel.chartRangesList.map((tab) {
                          final bool isSelected = viewModel.selectedChartRange == tab["label"];
                          return GestureDetector(
                            onTap: () { 
                              viewModel.selectChartRange(tab["label"]);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.grey.shade700,
                                ),
                              ),
                              child: Text(
                                tab["label"],
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    // --- Chart / Data ---
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: CryptoSparklineWidget(
                        key: ValueKey(viewModel.selectedChartRange),
                        symbol: network["binance_id"].toString(),
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height * 0.3,
                        interval: viewModel.chartRanges[viewModel.selectedChartRange]!["interval"].toString(),
                        limit: viewModel.chartRanges[viewModel.selectedChartRange]!["limit"]
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.show_chart
                              ),
                              Text(
                                " Market Data",
                                style: Theme.of(context).textTheme.bodyLarge
                              ),
                              
                            ]
                          ),
                          GestureDetector(
                            onTap: () {
                              viewModel.toggleShowMarketData();
                            },
                            child: Row(
                              children: [
                                Text(
                                  viewModel.showingMarketData ? "Show less" : "Show more",
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  viewModel.showingMarketData ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: viewModel.showingMarketData
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: const SizedBox.shrink(), // hidden
                      secondChild: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Market Cap",
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                      Text(
                                        "\$${AIHelpers.formatLargeNumberSmart(viewModel.tokenDetails["market_data"]?["market_cap"]?["usd"] ?? 0)}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      )
                                    ]
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rank",
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                      Text(
                                        "#${(viewModel.tokenDetails["market_cap_rank"] ?? 0)}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      )
                                    ]
                                  ),
                                ),
                              ]
                            )
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Supply",
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                      Text(
                                        "${(AIHelpers.formatLargeNumberSmart(viewModel.tokenDetails["market_data"]?["total_supply"] ?? 0))} ${network["short_name"]}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      )
                                    ]
                                  ),
                                ),
                                Expanded(
                                  flex: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Max Supply",
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                      Text(
                                        "${(AIHelpers.formatLargeNumberSmart(viewModel.tokenDetails["market_data"]?["max_supply"] ?? 0))} ${network["short_name"]}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      )
                                    ]
                                  ),
                                ),
                                
                                
                              ]
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 33,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Circulating Supply",
                                        style: Theme.of(context).textTheme.labelMedium,
                                      ),
                                      Text(
                                        "\$${AIHelpers.formatLargeNumberSmart(viewModel.tokenDetails["market_data"]?["circulating_supply"]?? 0)}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      )
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        ],
                      ), // visible
                    ),
                    
                  ]
                ),
            ),
          ),
        );
      }
    );
  }

}