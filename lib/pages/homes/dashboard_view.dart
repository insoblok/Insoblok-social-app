import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
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
        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AIColors.darkBar,
                  automaticallyImplyLeading: false,
                  title: Text('Stories'),
                  pinned: true,
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt_rounded),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ...viewModel.stories.reversed.map((story) {
                      return StoryListCell(story: story);
                    }),
                    const SizedBox(height: 96.0),
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
              child: InkWell(
                onTap: () => Routers.goToAddStoryPage(context),
                child: Container(
                  width: 54.0,
                  height: 54.0,
                  padding: const EdgeInsets.all(12.0),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 96.0,
                    right: 24.0,
                  ),
                  decoration: BoxDecoration(
                    color: AIColors.blue,
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  child: AIImage(Icons.add, width: 28.0, height: 28.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
