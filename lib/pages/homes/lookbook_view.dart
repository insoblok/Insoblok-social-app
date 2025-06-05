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
                SliverAppBar(
                  leading: AppLeadingView(),
                  title: Text('LookBook'),
                  centerTitle: true,
                  pinned: true,
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
                            'LookBook is Empty\nPlease try any action on Story!',
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
            ),
          ],
        );
      },
    );
  }
}
