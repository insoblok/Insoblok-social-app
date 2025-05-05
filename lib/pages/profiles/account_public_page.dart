import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class AccountPublicPage extends StatelessWidget {
  const AccountPublicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountPublicProvider>.reactive(
      viewModelBuilder: () => AccountPublicProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Public Information'), centerTitle: true),
        );
      },
    );
  }
}
