import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingProvider>.reactive(
      viewModelBuilder: () => SettingProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('InSoBlokAI Setting'), centerTitle: true),
          body: ListView(),
        );
      },
    );
  }
}
