import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashProvider>.reactive(
      viewModelBuilder: () => SplashProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: AIImage(
              AIImages.imgVybe,
              width: MediaQuery.of(context).size.width / 1.5,
              fit: BoxFit.fitWidth,
            ),
          ),
        );
      },
    );
  }
}
