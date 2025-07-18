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
          body: AppBackgroundView(
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
                          key: GlobalKey(
                            debugLabel: 'story-${viewModel.stories[index].id}',
                          ),
                          story: viewModel.stories[index],
                        );
                      },
                    ),
                CustomCircleBackButton(),
              ],
            ),
          ),
        );
      },
    );
  }
}
