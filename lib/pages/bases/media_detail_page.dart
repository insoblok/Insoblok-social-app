import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class MediaDetailPage extends StatelessWidget {
  final List<String> medias;
  const MediaDetailPage({super.key, required this.medias});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MomentProvider>.reactive(
      viewModelBuilder: () => MomentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Moments'), centerTitle: true),
        );
      },
    );
  }
}
