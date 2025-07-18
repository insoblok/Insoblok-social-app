import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class PageableView extends StatelessWidget {
  const PageableView({super.key});

  @override
  Widget build(BuildContext context) {
    var menuTitles = [
      'Lookbook',
      'Following',
      'Follow',
      'Leaderboard',
      'MarketPlace',
    ];
    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return AppBackgroundView(
          child: Stack(
            children: [
              viewModel.isBusy
                  ? Center(child: Loader(size: 60))
                  : PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: viewModel.pageController,
                    padEnds: false,
                    itemCount: viewModel.stories.length,
                    itemBuilder: (_, index) {
                      return StoryPageableCell(
                        story: viewModel.stories[index],
                        marginBottom: 76,
                      );
                    },
                  ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 12.0,
                  right: 12.0,
                ),
                child: Row(
                  spacing: 12.0,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child:
                          viewModel.showSearch
                              ? Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(16),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    AIImage(
                                      AIImages.icBottomSearch,
                                      width: 14.0,
                                      height: 14.0,
                                    ),
                                    const SizedBox(width: 6.0),
                                    Text(
                                      'Search for people and groups',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: AIColors.greyTextColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox(
                                height: 44.0,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    spacing: 16.0,
                                    children: [
                                      for (var title in menuTitles) ...{
                                        InkWell(
                                          onTap: () {
                                            var index = menuTitles.indexOf(
                                              title,
                                            );
                                            logger.d(index);
                                            viewModel.onClickMenuItem(index);
                                          },
                                          child: Text(
                                            title,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                          ),
                                        ),
                                      },
                                    ],
                                  ),
                                ),
                              ),
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.showSearch = !viewModel.showSearch;
                      },
                      child: AIImage(
                        AIImages.icBottomSearch,
                        width: 24.0,
                        height: 24.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
