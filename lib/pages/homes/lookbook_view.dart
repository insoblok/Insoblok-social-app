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
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: AppLeadingView(),
                  title: Text('LookBook'),
                  centerTitle: true,
                  pinned: true,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: AIImage(
                        AIImages.icSetting,
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ...viewModel.stories.reversed.map((story) {
                      return StoryListCell(story: story);
                    }),
                    const SizedBox(height: 20),
                  ]),
                ),
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
                          color: AIColors.blue,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'New Posts',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomFloatingButton(
                onTap: () => Routers.goToAddStoryPage(context),
                src: AIImages.icAddLogo,
              ),
            ),
          ],
        );
      },
    );
  }
}
