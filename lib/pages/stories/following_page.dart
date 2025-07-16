import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FollowingProvider>.reactive(
      viewModelBuilder: () => FollowingProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Following'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(child: Center(child: Loader(size: 60))),
                },
                if (viewModel.stories.isEmpty && !viewModel.isBusy) ...{
                  SliverFillRemaining(
                    child: InSoBlokEmptyView(desc: 'Story is Empty!'),
                  ),
                } else ...{
                  SliverFillRemaining(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: viewModel.stories.length,
                            itemBuilder: (context, index) {
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
                      ],
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
