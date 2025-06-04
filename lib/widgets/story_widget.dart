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
        return GestureDetector(
          onVerticalDragStart: (details) async {
            await showModalBottomSheet(
              context: context,
              backgroundColor: AppSettingHelper.background,
              barrierColor: Colors.transparent,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
                minHeight:
                    MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              builder: (ctx) {
                return StoryDetailDialog(story: viewModel.story);
              },
            );
            viewModel.fetchStory();
          },
          child: Container(
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
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  AIHelpers.htmlRender(viewModel.story.text),
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
                          height: double.infinity,
                          autoPlay: true,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          onChangePage: (index) => viewModel.pageIndex = index,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.story.category != null &&
                      viewModel.story.category == 'vote') ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 12.0,
                      children: [
                        Expanded(
                          child: VoteFloatingButton(
                            onTap: () {
                              viewModel.updateVote(true);
                            },
                            text:
                                viewModel.story.cntYay == 0
                                    ? 'Yay'
                                    : 'Yay (${viewModel.story.cntYay})',
                            textColor:
                                viewModel.story.isVote() == true
                                    ? AIColors.white
                                    : AIColors.green,
                            src:
                                viewModel.story.isVote() == true
                                    ? AIImages.icYayFill
                                    : AIImages.icYayOutline,
                            backgroundColor:
                                viewModel.story.isVote() == true
                                    ? AIColors.green
                                    : Colors.transparent,
                            borderColor: AIColors.green,
                          ),
                        ),
                        Expanded(
                          child: VoteFloatingButton(
                            onTap: () {
                              viewModel.updateVote(false);
                            },
                            text:
                                viewModel.story.cntNay == 0
                                    ? 'Nay'
                                    : 'Nay (${viewModel.story.cntNay})',
                            textColor:
                                viewModel.story.isVote() == false
                                    ? AIColors.white
                                    : AIColors.pink,
                            src:
                                viewModel.story.isVote() == false
                                    ? AIImages.icNayFill
                                    : AIImages.icNayOutline,
                            backgroundColor:
                                viewModel.story.isVote() == false
                                    ? AIColors.pink
                                    : AIColors.transparent,
                            borderColor: AIColors.pink,
                          ),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StoryDetailDialog extends StatelessWidget {
  final StoryModel story;

  const StoryDetailDialog({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryContentProvider>.reactive(
      viewModelBuilder: () => StoryContentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  if (viewModel.scrollController.offset == 0) {
                    Navigator.of(context).pop();
                  }
                  return false;
                }
                return true;
              },
              child: SingleChildScrollView(
                controller: viewModel.scrollController,
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AIColors.speraterColor,
                            width: 0.33,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AIHelpers.htmlRender(viewModel.story.text),
                          if ((viewModel.story.medias ?? []).isNotEmpty) ...{
                            const SizedBox(height: 8.0),
                            StoryDialogMediaView(),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: viewModel.updateLike,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AIImage(
                                      viewModel.story.isLike()
                                          ? AIImages.icFavoriteFill
                                          : AIImages.icFavorite,
                                      width: 16.0,
                                      height: 16.0,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${(viewModel.story.likes ?? []).length}',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                          TextSpan(
                                            text: '   Likes  ',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: viewModel.updateFollow,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AIImage(
                                      AIImages.icFollow,
                                      width: 20.0,
                                      height: 20.0,
                                      color:
                                          viewModel.story.isFollow()
                                              ? AIColors.green
                                              : null,
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${(viewModel.story.follows ?? []).length}',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                          TextSpan(
                                            text: '   Followers',
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.33,
                            height: 32.0,
                            color: AIColors.speraterColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (viewModel.story.category != null &&
                                  viewModel.story.category == 'vote') ...{
                                InkWell(
                                  onTap: () {
                                    viewModel.actionType('vote');
                                  },
                                  child: AIImage(
                                    viewModel.isVote
                                        ? AIImages.icYayFill
                                        : AIImages.icYayOutline,
                                    color:
                                        viewModel.isVote
                                            ? AIColors.pink
                                            : AIColors.grey,
                                    width: 28.0,
                                    height: 28.0,
                                  ),
                                ),
                              },
                              InkWell(
                                onTap: () {
                                  viewModel.actionType('comment');
                                  // viewModel.addComment();
                                },
                                child: AIImage(
                                  AIImages.icCommit,
                                  color:
                                      viewModel.isComment
                                          ? AIColors.pink
                                          : AIColors.grey,
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ),

                              InkWell(
                                onTap: viewModel.onClickRepost,
                                child: AIImage(
                                  AIImages.icRetwitter,
                                  width: 28.0,
                                  height: 28.0,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: AIImage(
                                  AIImages.icShare,
                                  width: 28.0,
                                  height: 28.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 0.33,
                      height: 24.0,
                      color: AIColors.speraterColor,
                    ),
                    if (viewModel.isVote) ...{
                      if ((viewModel.story.votes?.isEmpty ?? true)) ...{
                        StoryListEmptyView(
                          description: 'On click on that open tastescore tab!',
                        ),
                      } else ...{
                        for (var vote
                            in (viewModel.story.votes?.reversed.toList() ??
                                [])) ...{
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            child: VotedUserCell(voteModel: vote),
                          ),
                        },
                      },
                    },
                    if (viewModel.isComment) ...{
                      if ((viewModel.story.comments?.isEmpty ?? true)) ...{
                        StoryListEmptyView(
                          description: 'Nobody had commented yet!',
                        ),
                      } else ...{
                        for (var comment
                            in (viewModel.story.comments?.reversed.toList() ??
                                [])) ...{
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            child: StoryDetailCommentCell(
                              comment: comment,
                              isLast:
                                  (viewModel.story.comments ?? []).length ==
                                  comment,
                            ),
                          ),
                        },
                      },
                      const SizedBox(height: 20),
                    },
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 24.0,
                    ),
                  ],
                ),
              ),
            ),
            if (viewModel.isComment) ...{
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    border: Border(
                      top: BorderSide(
                        color: AIColors.speraterColor,
                        width: 0.33,
                      ),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 70.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Comments...',
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: null,
                            controller: viewModel.textController,
                            onChanged:
                                (value) => viewModel.commentContent = value,
                            onFieldSubmitted: (value) {},
                            onSaved: (value) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AIColors.pink,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: IconButton(
                              onPressed: viewModel.sendComment,
                              icon: Icon(
                                Icons.arrow_upward_outlined,
                                color: AIColors.white,
                                size: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            },
            if (viewModel.isBusy) ...{
              Align(
                alignment: Alignment.center,
                child: Center(child: Loader(size: 60)),
              ),
            },
          ],
        );
      },
    );
  }
}

class StoryDialogMediaView extends ViewModelWidget<StoryContentProvider> {
  const StoryDialogMediaView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: AspectRatio(
        aspectRatio: 1.91,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            spacing: 8.0,
            children: [
              for (var i = 0; i < viewModel.story.medias!.length; i++) ...{
                AspectRatio(
                  aspectRatio: 0.6,
                  child: InkWell(
                    onTap:
                        () => AIHelpers.goToDetailView(context, [
                          viewModel.story.medias![i].link!,
                        ]),
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
                        child: AspectRatio(
                          aspectRatio: 3 / 2,
                          child: AIImage(
                            viewModel.story.medias![i].link,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class StoryListEmptyView extends StatelessWidget {
  final String description;

  const StoryListEmptyView({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.0,
      alignment: Alignment.center,
      child: Text(description),
    );
  }
}
