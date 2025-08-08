import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class LookbookPage extends StatelessWidget {
  const LookbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LookbookProvider>.reactive(
      viewModelBuilder: () => LookbookProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: AppBackgroundView(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                DefaultTabController(
                  length: 4,
                  child: SliverAppBar(
                    title: Text('Lookbook'),
                    centerTitle: true,
                    flexibleSpace: AppBackgroundView(),
                    pinned: true,
                    // bottom: PreferredSize(
                    //   preferredSize: Size.fromHeight(30.0),
                    //   child: TabBar(
                    //     indicatorSize: TabBarIndicatorSize.tab,
                    //     onTap: (index) {
                    //       viewModel.tabIndex = index;
                    //       viewModel.filterList(index);
                    //     },
                    //     tabs: [
                    //       Tab(
                    //         height: 30.0,
                    //         child: Text(
                    //           'Stories',
                    //           style: Theme.of(context).textTheme.headlineSmall,
                    //         ),
                    //       ),
                    //       Tab(
                    //         height: 30.0,
                    //         child: Text(
                    //           'Posts',
                    //           style: Theme.of(context).textTheme.headlineSmall,
                    //         ),
                    //       ),
                    //       Tab(
                    //         height: 30.0,
                    //         child: Text(
                    //           'Comments',
                    //           style: Theme.of(context).textTheme.headlineSmall,
                    //         ),
                    //       ),
                    //       Tab(
                    //         height: 30.0,
                    //         child: Text(
                    //           'Likes',
                    //           style: Theme.of(context).textTheme.headlineSmall,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ),
                ),
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(child: Center(child: Loader(size: 60))),
                },
                if (viewModel.stories.isEmpty && !viewModel.isBusy) ...{
                  SliverFillRemaining(
                    child: InSoBlokEmptyView(
                      desc:
                          'Lookbook is Empty\nPlease try any action on Story!',
                    ),
                  ),
                } else ...{
                  SliverFillRemaining(
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: viewModel.pageController,
                      padEnds: false,
                      itemCount: viewModel.stories.length,
                      itemBuilder: (_, index) {
                        return StoryListCell(
                          key: GlobalKey(
                            debugLabel:
                                'story-${viewModel.stories[index].id}',
                          ),
                          story: viewModel.stories[index],
                        );
                      },
                    ),
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
