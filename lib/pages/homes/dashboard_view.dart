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
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            DefaultTabController(
              length: 2,
              child: SliverAppBar(
                pinned: true,
                floating: true,
                leading: AppLeadingView(),
                title: Text('Home'),
                centerTitle: true,
                bottom: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (index) {
                    viewModel.tabIndex = index;
                    if (index == 0) {
                      viewModel.fetchNewsData();
                    } else {
                      viewModel.fetchStoryData();
                    }
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        'News',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Story',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (viewModel.isBusy) ...{
              SliverFillRemaining(child: Center(child: Loader(size: 60))),
            },
            if (viewModel.showNewses.isEmpty) ...{
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
                        'News data seems to be not exsited. After\nsome time, Please try again!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            } else ...{
              viewModel.tabIndex == 0
                  ? SliverList(
                    delegate: SliverChildListDelegate([
                      for (var news in viewModel.showNewses) ...{
                        NewsListCell(news: news),
                      },
                    ]),
                  )
                  : SliverFillRemaining(
                    child: Column(
                      children: [
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
                  ),
            },
          ],
        );
      },
    );
  }
}
