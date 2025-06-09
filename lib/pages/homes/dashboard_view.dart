import 'package:flutter/material.dart';
import 'package:insoblok/routers/router.dart';

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
        return CustomScrollView(
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
                actions: [
                  if (viewModel.tabIndex == 0) ...{
                    IconButton(
                      onPressed: () => Routers.goToAddStoryPage(context),
                      icon: AIImage(
                        AIImages.icAddLogo,
                        width: 28.0,
                        height: 28.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  },
                ],
                bottom: TabBar(
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
                      child: Text(
                        'Feed',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'News',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (viewModel.isBusy) ...{
              SliverFillRemaining(child: Center(child: Loader(size: 60))),
            },
            if (viewModel.stories.isEmpty) ...{
              SliverFillRemaining(
                child: Center(
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
                ),
              ),
            } else ...{
              viewModel.tabIndex == 0
                  ? SliverFillRemaining(
                    child: Column(
                      children: [
                        if (viewModel.isUpdated)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                const Spacer(),
                                InkWell(
                                  onTap: viewModel.fetchStoryData,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AIColors.pink,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      'New Feeds',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                viewModel.onClickFeedOptionButton(0);
                              },
                              child: Container(
                                height: 40.0,
                                width: 132.0,
                                decoration: BoxDecoration(
                                  color:
                                      viewModel.feedIndex == 0
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondary.withAlpha(16),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Following',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color:
                                            viewModel.feedIndex == 0
                                                ? AIColors.white
                                                : AIColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                viewModel.onClickFeedOptionButton(1);
                              },
                              child: Container(
                                height: 40.0,
                                width: 132.0,
                                decoration: BoxDecoration(
                                  color:
                                      viewModel.feedIndex == 1
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(
                                            context,
                                          ).colorScheme.secondary.withAlpha(16),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'For you',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color:
                                            viewModel.feedIndex == 1
                                                ? AIColors.white
                                                : AIColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: viewModel.pageController,
                            padEnds: false,
                            itemCount: viewModel.stories.length,
                            itemBuilder: (_, index) {
                              return StoryListCell(
                                story: viewModel.stories[index],
                              );
                            },
                          ),
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
            },
          ],
        );
      },
    );
  }
}
