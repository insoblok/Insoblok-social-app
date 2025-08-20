import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const PostDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostDetailProvider>.reactive(
      viewModelBuilder: () => PostDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, data: data),
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
                        return StoryListCell(story: viewModel.stories[index]);
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
