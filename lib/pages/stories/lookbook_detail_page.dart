import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class LookbookDetailPage extends StatelessWidget {
  final StoryModel story;
  const LookbookDetailPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LookbookDetailProvider>.reactive(
      viewModelBuilder: () => LookbookDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: AppBackgroundView(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                DefaultTabController(
                  length: 4,
                  child: SliverAppBar(
                    title: Text('Story Detail'),
                    centerTitle: true,
                    flexibleSpace: AppBackgroundView(),
                    pinned: true,
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
                          enableDetail: false,
                          enableReaction: false,
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
