import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class TastescorePage extends StatelessWidget {
  final UserModel? user;
  const TastescorePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountRewardProvider>.reactive(
      viewModelBuilder: () => AccountRewardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, user),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('TASTESCORE'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              children: [
                TastescoreRemarkView(),
                const SizedBox(height: 24.0),
                TastescoreAvatarView(),
                const SizedBox(height: 24.0),
                TastescoreLevelView(),
                const SizedBox(height: 24.0),
                TastescoreXpNextView(),
                const SizedBox(height: 24.0),
                TastescoreRankView(),
              ],
            ),
          ),
        );
      },
    );
  }
}
