import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return AppBackgroundView(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              DefaultTabController(
                length: 2,
                child: SliverAppBar(
                  pinned: true,
                  floating: false,
                  leading: AppLeadingView(),
                  title: Text('Home'),
                  centerTitle: true,
                  flexibleSpace: AppBackgroundView(),
                  actions: [
                    if (viewModel.tabIndex == 0) ...{
                      IconButton(
                        onPressed: viewModel.goToAddPost,
                        icon: AIImage(
                          AIImages.icAddLogo,
                          width: 28.0,
                          height: 28.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    },
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(30.0),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (index) {
                        viewModel.tabIndex = index;
                        if (index == 0) {
                          viewModel.fetchStoryData();
                        } else {
                          viewModel.fetchNewsData();
                        }
                      },
                      tabs: [
                        Tab(
                          height: 30.0,
                          child: Text(
                            'Feed',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Tab(
                          height: 30.0,
                          child: Text(
                            'News',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (viewModel.isBusy && viewModel.tabIndex == 1) ...{
                SliverFillRemaining(child: Center(child: Loader(size: 60))),
              },
              viewModel.tabIndex == 0
                  ? SliverFillRemaining(
                    child: Column(
                      children: [
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SubTabButton(
                              title: 'For you',
                              selected: viewModel.feedIndex == 1,
                              onTap: () => viewModel.onClickFeedOptionButton(1),
                            ),
                            SubTabButton(
                              title: 'Following',
                              selected: viewModel.feedIndex == 0,
                              onTap: () => viewModel.onClickFeedOptionButton(0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child:
                              viewModel.isBusy
                                  ? Center(child: Loader(size: 60))
                                  : viewModel.stories.isEmpty
                                  ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipOval(
                                          child: AIImage(
                                            AIImages.placehold,
                                            width: 150.0,
                                            height: 150.0,
                                          ),
                                        ),
                                        const SizedBox(height: 40.0),
                                        Text(
                                          'Feed data seems to be not exsited. After\nsome time, Please try again!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: viewModel.stories.length,
                                    itemBuilder: (context, index) {
                                      return StoryListCell(
                                        story: viewModel.stories[index],
                                      );
                                    },
                                  ),

                          // : PageView.builder(
                          //   scrollDirection: Axis.horizontal,
                          //   controller: viewModel.pageController,
                          //   padEnds: false,
                          //   itemCount: viewModel.stories.length,
                          //   itemBuilder: (_, index) {
                          //     return StoryListCell(
                          //       story: viewModel.stories[index],
                          //     );
                          //   },
                          // ),
                        ),
                      ],
                    ),
                  )
                  : SliverList(
                    delegate: SliverChildListDelegate([
                      for (var news in viewModel.showNewses) ...{
                        NewsListCell(news: news),
                      },
                    ]),
                  ),
            ],
          ),
        );
      },
    );
  }
}
