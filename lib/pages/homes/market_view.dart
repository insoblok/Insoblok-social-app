import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketProvider>.reactive(
      viewModelBuilder: () => MarketProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              leading: AppLeadingView(),
              title: Text('Marketplace'),
              centerTitle: true,
              pinned: true,
              actions: [],
            ),
          ],
        );
      },
    );
  }
}
