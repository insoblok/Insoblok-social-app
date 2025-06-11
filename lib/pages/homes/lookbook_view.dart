import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class LookbookView extends StatelessWidget {
  const LookbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LookbookProvider>.reactive(
      viewModelBuilder: () => LookbookProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                DefaultTabController(
                  length: 4,
                  child: SliverAppBar(
                    leading: AppLeadingView(),
                    title: Text('LOOKBOOK'),
                    centerTitle: true,
                    pinned: true,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(30.0),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        onTap: (index) {
                          viewModel.tabIndex = index;
                          viewModel.filterList(index);
                        },
                        tabs: [
                          Tab(
                            height: 30.0,
                            child: Text(
                              'Stories',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Tab(
                            height: 30.0,
                            child: Text(
                              'Posts',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Tab(
                            height: 30.0,
                            child: Text(
                              'Comments',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Tab(
                            height: 30.0,
                            child: Text(
                              'Likes',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(child: Center(child: Loader(size: 60))),
                },
                if (viewModel.filterStories.isEmpty) ...{
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
                            'LOOKBOOK is Empty\nPlease try any action on Story!',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                } else ...{
                  SliverFillRemaining(
                    child: Column(
                      children: [
                        // AITabBarView(onTap: (i) => logger.d(i)),
                        Expanded(
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: viewModel.pageController,
                            padEnds: false,
                            itemCount: viewModel.filterStories.length,
                            itemBuilder: (_, index) {
                              var story = viewModel.filterStories[index];
                              return StoryListCell(
                                key: GlobalKey(
                                  debugLabel:
                                      '${story.id} - ${viewModel.tabIndex}',
                                ),
                                story: story,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                },
              ],
            ),
          ],
        );
      },
    );
  }
}
