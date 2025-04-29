import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kStoryDetailAvatarSize = 55.0;

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
          appBar: AppBar(title: Text(story.title ?? '')),
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
                        Row(
                          children: [
                            ClipOval(
                              child: AIImage(
                                viewModel.owner?.avatar,
                                width: kStoryDetailAvatarSize,
                                height: kStoryDetailAvatarSize,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.owner?.fullName ?? '---',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  '@${viewModel.owner?.nickId}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    AIHelpers.htmlRender(story.text),
                    if ((story.medias ?? []).isNotEmpty) ...{
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
                              onChangePage: (index) {},
                            ),
                          ),
                        ),
                      ),
                    },
                    const SizedBox(height: 16.0),
                    Text(
                      story.shownHMDate,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(thickness: 0.33, height: 32.0),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${(story.likes ?? []).length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: ' Likes  ',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          TextSpan(
                            text: '${(story.follows ?? []).length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: ' Followers',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.33, height: 32.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: AIImage(
                            AIImages.icCommit,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: AIImage(
                            AIImages.icRetwitter,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: AIImage(
                            AIImages.icFavorite,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: AIImage(
                            AIImages.icShare,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 0.33, height: 32.0),
              for (var comment
                  in (story.comments?.reversed.toList() ?? [])) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: StoryDetailCommentCell(
                    comment: comment,
                    isLast: (story.comments ?? []).length == comment,
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
