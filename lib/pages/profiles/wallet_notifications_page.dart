import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletNotificationsPage extends StatelessWidget {
  const WalletNotificationsPage({super.key});
  
  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () => AccountWalletProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Container(
            child: Center(
              child: Text("Notifications",
                style: Theme.of(context).textTheme.bodyLarge
              )
            )
          )
        );
      }
    );
  }
}
