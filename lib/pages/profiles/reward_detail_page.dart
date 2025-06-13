import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class RewardDetailPage extends StatelessWidget {
  const RewardDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RewardDetailProvider>.reactive(
      viewModelBuilder: () => RewardDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('XP Histories'), centerTitle: true),
          body: ListView.separated(
            itemCount: viewModel.scores.length,
            itemBuilder: (context, index) {
              var score = viewModel.scores[index];
              return ScoreItemExtView(score: score);
            },
            separatorBuilder: (context, index) => const Divider(thickness: 0.5),
          ),
        );
      },
    );
  }
}
