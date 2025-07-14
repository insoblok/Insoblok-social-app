import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class PageableView extends StatelessWidget {
  const PageableView({super.key});

  @override
  Widget build(BuildContext context) {
    var menuTitles = [
      'Profile',
      'My Posts',
      'Likes',
      'Follows',
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
                      return StoryPageableCell(story: viewModel.stories[index]);
                    },
                  ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Row(
                            spacing: 12.0,
                            children: [
                              for (var title in menuTitles) ...{
                                InkWell(
                                  onTap: () {
                                    var index = menuTitles.indexOf(title);
                                    logger.d(index);
                                    viewModel.onClickMenuItem(index);
                                  },
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                              },
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: viewModel.goToAddPost,
                        child: AIImage(
                          AIImages.icAddLogo,
                          width: 28.0,
                          height: 28.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
