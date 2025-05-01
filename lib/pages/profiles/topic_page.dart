import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class TopicPage extends StatelessWidget {
  const TopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopicProvider>.reactive(
      viewModelBuilder: () => TopicProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('My Likes'), centerTitle: true),
          body: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              var story = viewModel.stories[i];
              return StoryListCell(story: story);
            },
            separatorBuilder: (context, i) {
              return Container();
            },
            itemCount: viewModel.stories.length,
          ),
        );
      },
    );
  }
}
