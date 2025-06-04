import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
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
                  actions: [
                    IconButton(
                      onPressed: () => Routers.goToAddStoryPage(context),
                      icon: AIImage(
                        AIImages.icAddLogo,
                        width: 28.0,
                        height: 28.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(child: Center(child: Loader(size: 60))),
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
            if (viewModel.isUpdated)
              Padding(
                padding: EdgeInsets.only(
                  top:
                      MediaQuery.of(context).viewInsets.top +
                      40.0 +
                      kToolbarHeight,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: viewModel.fetchData,
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
                          'New Posts',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
