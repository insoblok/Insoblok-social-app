import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kStoryDetailAvatarSize = 44.0;

class StoryDetailPage extends StatelessWidget {
  final StoryModel story;

  const StoryDetailPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryDetailProvider>.reactive(
      viewModelBuilder: () => StoryDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.story.title ?? ''),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(viewModel.story),
              icon:
                  Platform.isIOS
                      ? Icon(Icons.arrow_back_ios)
                      : Icon(Icons.arrow_back),
            ),
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AIColors.speraterColor, width: 0.33),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: viewModel.onTapAvatar,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AIAvatarImage(
                                viewModel.owner?.avatar,
                                width: kStoryDetailAvatarSize,
                                height: kStoryDetailAvatarSize,
                                textSize: 24,
                                fullname: viewModel.owner?.nickId ?? 'Temp',
                                isBorder: true,
                                borderRadius: kStoryDetailAvatarSize / 2,
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.owner?.fullName ?? '---',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '@${viewModel.owner?.nickId}',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    AIHelpers.htmlRender(viewModel.story.text),
                    if ((viewModel.story.medias ?? []).isNotEmpty) ...{
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.33,
                            color: AIColors.speraterColor,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: AspectRatio(
                            aspectRatio: 1.91,
                            child: StoryCarouselView(
                              story: story,
                              height: double.infinity,
                              boxFit: BoxFit.cover,
                              autoPlay: true,
                              onChangePage: (index) {},
                            ),
                          ),
                        ),
                      ),
                    },
                    const SizedBox(height: 16.0),
                    Text(
                      viewModel.story.shownHMDate,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Divider(
                      thickness: 0.2,
                      height: 24.0,
                      color: AIColors.speraterColor,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${(viewModel.story.likes ?? []).length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: ' Likes ',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          TextSpan(
                            text: '${(viewModel.story.follows ?? []).length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: ' Followers ',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.2,
                      height: 24.0,
                      color: AIColors.speraterColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: viewModel.addComment,
                          child: AIImage(
                            AIImages.icComment,
                            width: 20.0,
                            height: 20.0,
                            color: AIColors.white,
                          ),
                        ),
                        InkWell(
                          onTap: viewModel.updateFollow,
                          child: AIImage(
                            AIImages.icFollow,
                            width: 18.0,
                            height: 18.0,
                            color:
                                viewModel.story.isFollow()
                                    ? AIColors.green
                                    : AIColors.white,
                          ),
                        ),
                        InkWell(
                          onTap: viewModel.updateLike,
                          child: Icon(
                            Icons.favorite,
                            color:
                                viewModel.story.isLike()
                                    ? AIColors.green
                                    : AIColors.white,
                            size: 20.0,
                          ),
                        ),
                        InkWell(
                          onTap: viewModel.shareFeed,
                          child: AIImage(
                            AIImages.icShare,
                            width: 18.0,
                            height: 18.0,
                            color: AIColors.white,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 0.2,
                      height: 24.0,
                      color: AIColors.speraterColor,
                    ),
                  ],
                ),
              ),

              for (var comment in viewModel.comments) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: StoryDetailCommentCell(
                    key: GlobalKey(
                      debugLabel: '${comment.id} - ${comment.storyId}',
                    ),
                    comment: comment,
                  ),
                ),
              },
              SizedBox(height: MediaQuery.of(context).padding.bottom + 24.0),
            ],
          ),
        );
      },
    );
  }
}
