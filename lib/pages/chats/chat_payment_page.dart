import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/routers/routers.dart';

class ChatPaymentPage extends StatelessWidget {
  final Map<String, String> args;
  const ChatPaymentPage({super.key, required this.args});
  @override build(BuildContext context) {
    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, args["sender"] ?? "", args["receiver"] ?? "", "", 0),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("P2P Payment"),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24),
                      child: Column(
                        children: [
                            AITextField(
                              hintText: "From",
                              controller: viewModel.senderController
                            ),
                            const SizedBox(height: 24),
                            AITextField(
                              hintText: "To",
                              controller: viewModel.receiverController
                          ),                   
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 24),
                    child: GradientPillButton(
                      text: "Next",
                      loadingText: " ... Loading ",
                      onPressed: () {
                        Routers.goToPaymentAmountPage(context, viewModel.senderController.text.trim(), viewModel.receiverController.text.trim(), "", 0);
                      }
                    ),
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}