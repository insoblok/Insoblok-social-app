import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AIColors.speraterColor, width: 0.33),
            ),
          ),
          child: InkWell(
            onTap: () => Routers.goToStoryDetailPage(context, story),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: kStoryDetailAvatarSize,
                      alignment: Alignment.centerRight,
                      child: AIImage(
                        AIImages.icFavoriteFill,
                        color: AIColors.grey,
                        width: 12.0,
                        height: 12.0,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Kieron Dotson and Zack John liked',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: AIImage(
                            viewModel.owner?.avatar,
                            width: kStoryDetailAvatarSize,
                            height: kStoryDetailAvatarSize,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: viewModel.owner?.fullName ?? '---',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextSpan(
                                  text:
                                      ' @${viewModel.owner?.nickId} • ${story.timestamp?.timeago}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                          AIHelpers.htmlRender(story.text),
                          if (medias.isNotEmpty) ...{
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
                                    onChangePage:
                                        (index) => viewModel.pageIndex = index,
                                  ),
                                ),
                              ),
                            ),
                          },
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: viewModel.addComment,
                                  child: Row(
                                    children: [
                                      AIImage(AIImages.icCommit, height: 14.0),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        (story.comments?.length ?? 0)
                                            .socialValue,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: viewModel.updateFollow,
                                  child: Row(
                                    children: [
                                      AIImage(
                                        AIImages.icRetwitter,
                                        height: 14.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        (story.follows?.length ?? 0)
                                            .socialValue,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: viewModel.updateLike,
                                  child: Row(
                                    children: [
                                      AIImage(
                                        story.isLike()
                                            ? AIImages.icFavoriteFill
                                            : AIImages.icFavorite,
                                        height: 14.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        (story.likes?.length ?? 0).socialValue,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    AIImage(AIImages.icShare, height: 14.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StoryDetailCommentCell extends StatelessWidget {
  final StoryCommentModel comment;
  final bool isLast;

  const StoryDetailCommentCell({
    super.key,
    required this.comment,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: FirebaseHelper.getUser(comment.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        var user = snapshot.data;
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: kStoryDetailAvatarSize / 2.0),
              padding: const EdgeInsets.only(
                left: kStoryDetailAvatarSize / 2.0 + 8.0,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 0.33, color: AIColors.speraterColor),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: user?.fullName ?? '---',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextSpan(
                                text: ' @${user?.nickId}',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        comment.timestamp?.timeago ?? '---',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  AIHelpers.htmlRender(comment.content),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
            ClipOval(
              child: AIImage(
                user?.avatar,
                width: kStoryDetailAvatarSize,
                height: kStoryDetailAvatarSize,
              ),
            ),
          ],
        );
      },
    );
  }
}
