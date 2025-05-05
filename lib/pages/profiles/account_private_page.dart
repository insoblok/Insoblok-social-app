import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class AccountPrivatePage extends StatelessWidget {
  const AccountPrivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountPrivateProvider>.reactive(
      viewModelBuilder: () => AccountPrivateProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Private Information'), centerTitle: true),
        );
      },
    );
  }
}
