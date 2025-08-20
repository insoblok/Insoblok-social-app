import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PostProvider>.reactive(
      viewModelBuilder: () => PostProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Posts'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                var story = viewModel.stories[i];
                return AccountStoryListCell(story: story);
              },
              separatorBuilder: (context, i) {
                return Container();
              },
              itemCount: viewModel.stories.length,
            ),
          ),
        );
      },
    );
  }
}
