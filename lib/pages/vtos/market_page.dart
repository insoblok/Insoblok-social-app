import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insoblok/utils/image.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class MarketPlacePage extends StatelessWidget {
  const MarketPlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketProvider>.reactive(
      viewModelBuilder: () => MarketProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: AppBackgroundView(
            child: CustomScrollView(
              slivers: [
                AISliverAppbar(
                  context,
                  title: Text('MarketPlace'),
                  pinned: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: viewModel.onTapFilter,
                    ),
                    if (kDebugMode || (viewModel.user?.isPremium ?? false))
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: viewModel.onTapAddProduct,
                      ),
                  ],
                  extendHeight: viewModel.isClickFilter ? 110 : 0,
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
                  sliver:
                      viewModel.filterProducts.isNotEmpty
                          ? SliverList(
                            delegate: SliverChildListDelegate([
                              StaggeredGrid.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
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
                          )
                          : SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipOval(
                                    child: AIImage(
                                      AIImages.placehold,
                                      width: 160.0,
                                      height: 160.0,
                                    ),
                                  ),
                                  const SizedBox(height: 24.0),
                                  Text(
                                    "Empty!",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 60.0,
                                    ),
                                    child: Text(
                                      "There is no any products yet.",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
