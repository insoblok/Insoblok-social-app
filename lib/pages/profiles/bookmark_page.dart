import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookmarkProvider>.reactive(
      viewModelBuilder: () => BookmarkProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('My Follows'), centerTitle: true),
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
