import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class StoryListCell extends StatelessWidget {
  final StoryModel story;

  const StoryListCell({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryProvider>.reactive(
      viewModelBuilder: () => StoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return PageView(
          controller: viewModel.pageController,
          scrollDirection: Axis.vertical,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: InkWell(
                onTap: viewModel.goToDetailPage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: AIAvatarImage(
                                // key: GlobalKey(debugLabel: 'story-${story.uid}'),
                                viewModel.owner?.avatar,
                                width: kStoryDetailAvatarSize,
                                height: kStoryDetailAvatarSize,
                                fullname: viewModel.owner?.nickId ?? 'Test',
                                textSize: 24,
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
                              Text(
                                viewModel.owner?.fullName ?? '---',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '@${viewModel.owner?.nickId} • ${viewModel.story.timestamp?.timeago}',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.33,
                            color: AIColors.speraterColor,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: StoryCarouselView(
                            story: story,
                            onChangePage:
                                (index) => viewModel.pageIndex = index,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: AIColors.green,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AIImage(
                                  AIImages.icYay,
                                  width: 32,
                                  height: 32,
                                  color: AIColors.white,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Yay',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AIColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: AIColors.pink,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AIImage(
                                  AIImages.icNay,
                                  width: 32,
                                  height: 32,
                                  color: AIColors.white,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Nay',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AIColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StoryContentPage(story: viewModel.story),
          ],
        );
      },
    );
  }
}

class StoryContentPage extends StatelessWidget {
  final StoryModel story;

  const StoryContentPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryProvider>.reactive(
      viewModelBuilder: () => StoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [];
          },
          body: Column(
            mainAxisSize: MainAxisSize.min,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   children: [
                        //     ClipOval(
                        //       child: AIAvatarImage(
                        //         viewModel.owner?.avatar,
                        //         width: kStoryDetailAvatarSize,
                        //         height: kStoryDetailAvatarSize,
                        //         textSize: 24,
                        //         fullname: viewModel.owner?.fullName ?? '---',
                        //       ),
                        //     ),
                        //     const SizedBox(width: 8.0),
                        //     Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           viewModel.owner?.fullName ?? '---',
                        //           style: Theme.of(context).textTheme.bodyMedium,
                        //         ),
                        //         Text(
                        //           '@${viewModel.owner?.nickId}',
                        //           style: Theme.of(context).textTheme.labelLarge,
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
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
                              onChangePage: (index) {},
                            ),
                          ),
                        ),
                      ),
                    },
                    const SizedBox(height: 16.0),
                    Text(
                      viewModel.story.shownHMDate,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Divider(
                      thickness: 0.33,
                      height: 32.0,
                      color: AIColors.speraterColor,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${(viewModel.story.likes ?? []).length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: ' Likes  ',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          TextSpan(
                            text: '${(viewModel.story.follows ?? []).length}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: ' Followers',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.33,
                      height: 32.0,
                      color: AIColors.speraterColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: viewModel.addComment,
                          child: AIImage(
                            AIImages.icCommit,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        InkWell(
                          onTap: viewModel.updateFollow,
                          child: AIImage(
                            AIImages.icRetwitter,
                            width: 20.0,
                            height: 20.0,
                            color:
                                viewModel.story.isFollow()
                                    ? AIColors.green
                                    : null,
                          ),
                        ),
                        InkWell(
                          onTap: viewModel.updateLike,
                          child: AIImage(
                            viewModel.story.isLike()
                                ? AIImages.icFavoriteFill
                                : AIImages.icFavorite,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                        AIImage(AIImages.icShare, width: 20.0, height: 20.0),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.33,
                height: 32.0,
                color: AIColors.speraterColor,
              ),
              for (var comment
                  in (viewModel.story.comments?.reversed.toList() ?? [])) ...{
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 4.0,
                  ),
                  child: StoryDetailCommentCell(
                    comment: comment,
                    isLast: (viewModel.story.comments ?? []).length == comment,
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
