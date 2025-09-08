import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/routers/routers.dart';

class ChatPaymentPage extends StatelessWidget {
  const ChatPaymentPage({super.key});

  @override build(BuildContext context) {
    return ViewModelBuilder<ChatPaymentProvider>.reactive(
      viewModelBuilder: () => ChatPaymentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("P2P Payment"),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24),
                  child: Column(
                    children: [
                        AITextField(
                          hintText: "From",
                          controller: viewModel.fromAddressTextEditingController,
                        ),
                        const SizedBox(height: 24),
                        AITextField(
                          hintText: "To",
                          controller: viewModel.toAddressTextEditingController, // ← Fixed controller name
                      ),                   
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 24),
                  child: GradientPillButton(
                    text: "Next",
                    loadingText: " ... Loading ",
                    onPressed: () {
                      Routers.goToPaymentAmountPage(context);
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