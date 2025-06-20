import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountStoryListCell extends StatelessWidget {
  final StoryModel story;

  const AccountStoryListCell({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryContentProvider>.reactive(
      viewModelBuilder: () => StoryContentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        var medias = viewModel.story.medias ?? [];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AIColors.speraterColor, width: 0.33),
            ),
          ),
          child: InkWell(
            onTap: viewModel.goToDetailPage,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AIAvatarImage(
                      viewModel.owner?.avatar,
                      width: kStoryDetailAvatarSize,
                      height: kStoryDetailAvatarSize,
                      fullname: viewModel.owner?.fullName ?? 'Test',
                      textSize: 24,
                      isBorder: true,
                      borderRadius: kStoryDetailAvatarSize / 2,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            viewModel.owner?.fullName ?? '---',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          AIHelpers.htmlRender(viewModel.story.text),
                          if (medias.isNotEmpty) ...{
                            const SizedBox(height: 8.0),
                            Container(
                              width: 180,
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
                                  aspectRatio: 0.8,
                                  child: StoryCarouselView(
                                    story: story,
                                    boxFit: BoxFit.cover,
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
                                        (viewModel.story.comments?.length ?? 0)
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
                                        (viewModel.story.follows?.length ?? 0)
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
                                        viewModel.story.isLike()
                                            ? AIImages.icFavoriteFill
                                            : AIImages.icFavorite,
                                        height: 14.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        (viewModel.story.likes?.length ?? 0)
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
                                  onTap:
                                      () => AIHelpers.shareStory(
                                        context,
                                        story: story,
                                      ),
                                  child: Row(
                                    children: [
                                      AIImage(AIImages.icShare, height: 14.0),
                                    ],
                                  ),
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
