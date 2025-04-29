import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class MomentPage extends StatelessWidget {
  const MomentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MomentProvider>.reactive(
      viewModelBuilder: () => MomentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold();
      },
    );
  }
}
