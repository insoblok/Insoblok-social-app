import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
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
            AISliverAppbar(
              context,
              title: Text('Marketplace'),

              leading: AppLeadingView(),
              pinned: true,
              actions: [
                kDebugMode
                    ? IconButton(
                      icon: Icon(Icons.add_circle),
                      onPressed: viewModel.onTapAddProduct,
                    )
                    : IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: viewModel.onTapFilter,
                    ),
              ],
              extendHeight: viewModel.isClickFilter ? 86 : 0,
              extendWidget:
                  viewModel.isClickFilter
                      ? Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          for (
                            var i = 0;
                            i < kProductCategoryNames.length;
                            i++
                          ) ...{
                            TagView(
                              tag: kProductCategoryNames[i],
                              height: 32,
                              isSelected: viewModel.selectedTags[i],
                              onTap: () {
                                viewModel.updateTagSelect(i);
                                viewModel.filterData();
                              },
                            ),
                          },
                        ],
                      )
                      : SizedBox(),
            ),
            if (viewModel.isBusy) ...{
              SliverFillRemaining(child: Center(child: Loader(size: 60))),
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
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      ...viewModel.filterProducts.map((p) {
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
