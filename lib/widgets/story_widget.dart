import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class StoryListCell extends StatelessWidget {
  final StoryModel story;

  const StoryListCell({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    var medias = story.medias ?? [];
    return ViewModelBuilder<StoryProvider>.reactive(
      viewModelBuilder: () => StoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return Container(
          margin: const EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AIColors.darkScaffoldBackground,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
            onTap: () => Routers.goToStoryDetailPage(context, story),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 240.0,
                    child: Stack(
                      children: [
                        StoryCarouselView(
                          story: story,
                          height: 240.0,
                          onChangePage: (index) => viewModel.pageIndex = index,
                        ),
                        if (medias.isNotEmpty)
                          StoryListUserView(
                            background: AIColors.darkTransparentBackground,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (medias.isEmpty) StoryListUserView(),
                        Text(
                          story.title ?? '---',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        AIHelpers.htmlRender(
                          story.text,
                          fontSize: FontSize.medium,
                        ),
                        StoryListActionView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoryListUserView extends ViewModelWidget<StoryProvider> {
  final Color? background;

  const StoryListUserView({super.key, this.background});

  @override
  Widget build(BuildContext context, viewModel) {
    var user = viewModel.owner;
    var story = viewModel.story;
    if (user == null) {
      return Container();
    }
    return Container(
      height: 54.0,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      color: background,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: AIImage(user.avatar, width: 32.0, height: 32.0),
          ),
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '${story.regdate}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${viewModel.pageIndex + 1} / ${(story.medias ?? []).length}',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}

class StoryListActionView extends ViewModelWidget<StoryProvider> {
  const StoryListActionView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var story = viewModel.story;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: viewModel.updateLike,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StoryActionIcon(
                isLoading: viewModel.isLiking,
                src: story.isLike() ? Icons.favorite : Icons.favorite_border,
              ),
              const SizedBox(width: 4.0),
              Text(
                (story.likes?.length ?? 0).socialValue,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24.0),
        InkWell(
          onTap: viewModel.updateFollow,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StoryActionIcon(
                isLoading: viewModel.isFollowing,
                src: story.isFollow() ? Icons.hearing : Icons.hearing_disabled,
              ),
              const SizedBox(width: 4.0),
              Text(
                (story.follows?.length ?? 0).socialValue,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24.0),
        InkWell(
          onTap: viewModel.addComment,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AIImage(Icons.comment, width: 18.0, height: 18.0),
              const SizedBox(width: 4.0),
              Text(
                (story.comments?.length ?? 0).socialValue,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        const Spacer(),
        Text('More Detail >', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

class StoryActionIcon extends StatelessWidget {
  final dynamic src;
  final bool isLoading;
  final double size;

  const StoryActionIcon({
    super.key,
    required this.src,
    this.size = 18.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader(size: size, color: AIColors.red, strokeWidth: 0.75)
        : AIImage(src, width: size, height: size);
  }
}
