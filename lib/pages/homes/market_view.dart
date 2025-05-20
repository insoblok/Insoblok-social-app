import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketProvider>.reactive(
      viewModelBuilder: () => MarketProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('Marketplace'),
              centerTitle: true,
              leading: AppLeadingView(),
              actions: [
                if (kDebugMode) ...{
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: viewModel.onTapAddProduct,
                  ),
                },
              ],
            ),
            if (viewModel.isBusy) ...{
              SliverFillRemaining(
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      colors: [Theme.of(context).primaryColor],
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            },
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    children: [
                      ...viewModel.products.map((p) {
                        return ProductItemWidget(
                          product: p,
                          onTap: () => viewModel.onTapVTOList(p),
                        );
                      }),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
