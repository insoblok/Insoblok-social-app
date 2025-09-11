import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/pages/chats/message_page.dart';

class PaymentResultPage extends StatelessWidget {
  const PaymentResultPage({super.key});

  @override build(BuildContext context) {
    return ViewModelBuilder<PaymentResultProvider>.reactive(
      viewModelBuilder: () => PaymentResultProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        final network = kWalletTokenList.firstWhere((tk) => tk["chain"] == viewModel.selectedNetwork);
        return Scaffold(
          appBar: AppBar(
            title: Text("P2P Payment Result"),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(

            ),
          ),
          body: AppBackgroundView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('Sent ${network["short_name"].toString()}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "Submitted",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:[
                          Text(
                            "${viewModel.amount} ${network['short_name']}",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            '${DateFormat("EEEE, MMM d, y h:mm a").format(DateTime.now())}',
                            style: TextStyle(
                              fontSize: 14,
                            )
                          )
                        ]
                      )
                    ],                            
                  )
                ),
                const SizedBox(height: 48.0),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          AIHelpers.launchExternalSource("${network["scanUrl"]}/${viewModel.transactionHash}");
                        },
                        child: Text(
                          "View full history on Scan site",
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 16
                          )
                        ) 
                      ),

                      const SizedBox(height: 72.0)
                      
                    ]
                  ),  
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      GradientPillButton(
                        text: "Return to Chat Page",
                        onPressed: () {
                          viewModel.handleClickReturn(context);
                        }
                      )
                    ]
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