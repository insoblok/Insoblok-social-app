import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kStoryAvatarSize = 50.0;

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
            viewModel.dragStart = details.localPosition;
          },
          onVerticalDragUpdate: (details) {
            var dragPosition = details.localPosition;
            if (dragPosition.dy + 50 < viewModel.dragStart.dy) {
              viewModel.showDetailDialog();
            }
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
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipOval(
                            child: AIAvatarImage(
                              // key: GlobalKey(debugLabel: 'story-${story.uid}'),
                              viewModel.owner?.avatar,
                              width: kStoryAvatarSize,
                              height: kStoryAvatarSize,
                              fullname: viewModel.owner?.nickId ?? 'Test',
                              textSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              viewModel.owner?.fullName ?? '---',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${viewModel.story.timestamp?.timeago}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (viewModel.story.category != null &&
                      viewModel.story.category == 'vote')
                    Column(
                      children: [
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vybe VTO Try-On',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(16),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.leaderboard_outlined, size: 18),
                                  Text(
                                    ' ${viewModel.story.cntLooksToday}/5 Looks Today',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 8.0),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        spacing: 40.0,
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
        var bottomInset = MediaQuery.of(context).viewInsets.bottom;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (bottomInset > 0) {
            Future.delayed(Duration(milliseconds: 100), () {
              if (viewModel.scrollController.hasClients) {
                viewModel.scrollController.animateTo(
                  viewModel.scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        });
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
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
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
                            if (viewModel.story.text != null &&
                                AIHelpers.removeFirstBr(
                                      viewModel.story.text!,
                                    ) !=
                                    '<p></p>')
                              AIHelpers.htmlRender(viewModel.story.text),
                            if ((viewModel.story.medias ?? []).isNotEmpty) ...{
                              const SizedBox(height: 8.0),
                              StoryDialogMediaView(),
                            },
                            const SizedBox(height: 16.0),
                            Text(
                              viewModel.story.shownHMDate,
                              style: Theme.of(context).textTheme.labelMedium,
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
                                              text: '  Likes  ',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
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
                                              text: '  Followers',
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (viewModel.isMine) SizedBox(width: 12),
                                if (viewModel.isMine)
                                  InkWell(
                                    onTap: viewModel.onClickSaveToLookBook,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AIColors.pink,
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Save to LOOKBOOK',
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: AIColors.white,
                                        ),
                                      ),
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
                            description:
                                'On click on that open tastescore tab!',
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
                          // SizedBox(
                          //   height: MediaQuery.of(context).viewInsets.bottom,
                          // ),
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
                                key: GlobalKey(
                                  debugLabel:
                                      '${comment.uid} - ${viewModel.story.comments?.reversed.toList().indexOf(comment)}',
                                ),
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
                      SizedBox(height: 94.0),
                    ],
                  ),
                ),
              ),
            ),

            if (viewModel.isBusy) ...{
              Align(
                alignment: Alignment.center,
                child: Center(child: Loader(size: 60)),
              ),
            },
            if (viewModel.isComment) ...{
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    border: Border(
                      top: BorderSide(
                        color: AIColors.speraterColor,
                        width: 0.33,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: AIImage(
                              AIImages.icImage,
                              color: AIColors.grey,
                              width: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: AIImage(
                              AIImages.icCamera,
                              color: AIColors.grey,
                              width: 20,
                            ),
                          ),
                          Expanded(
                            child: QuillSimpleToolbar(
                              controller: viewModel.quillController,
                              config: QuillSimpleToolbarConfig(
                                toolbarIconAlignment: WrapAlignment.start,
                                showDividers: false,
                                showFontFamily: false,
                                showFontSize: false,
                                showColorButton: false,
                                showBackgroundColorButton: false,
                                showHeaderStyle: false,
                                showCodeBlock: false,
                                showInlineCode: false,
                                showIndent: false,
                                showSearchButton: false,
                                showUndo: false,
                                showRedo: false,
                                showQuote: false,
                                showSubscript: false,
                                showSuperscript: false,
                                showListCheck: false,
                                showClearFormat: false,
                                showAlignmentButtons: false,
                                showCenterAlignment: false,
                                showLeftAlignment: false,
                                showLink: false,
                                showJustifyAlignment: false,
                                showRightAlignment: false,
                                showListNumbers: false,
                                showListBullets: false,
                                showStrikeThrough: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          // bottom: 8.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: AIColors.speraterColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: QuillEditor(
                                focusNode: viewModel.focusNode,
                                scrollController:
                                    viewModel.quillScrollController,
                                controller: viewModel.quillController,

                                config: QuillEditorConfig(
                                  autoFocus: false,
                                  expands: false,
                                  placeholder: 'Comments...',

                                  padding: const EdgeInsets.all(16),
                                  customStyles: DefaultStyles(
                                    placeHolder: DefaultTextBlockStyle(
                                      TextStyle(
                                        fontSize: 16,
                                        color: AIColors.grey,
                                      ),
                                      HorizontalSpacing.zero,
                                      VerticalSpacing.zero,
                                      VerticalSpacing.zero,
                                      null,
                                    ),
                                    paragraph: DefaultTextBlockStyle(
                                      TextStyle(
                                        fontSize: 16,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                      HorizontalSpacing.zero,
                                      VerticalSpacing.zero,
                                      VerticalSpacing.zero,
                                      null,
                                    ),
                                  ),

                                  // customize other styles if needed
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 8.0,
                              ),
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
                    ],
                  ),
                ),
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
                        () => AIHelpers.goToDetailView(
                          context,
                          medias:
                              (viewModel.story.medias ?? [])
                                  .map((media) => media.link!)
                                  .toList(),
                          index: i,
                        ),
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
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AIColors.grey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: MediaCarouselCell(
                            media: viewModel.story.medias![i],
                          ),
                        ),
                        // child: AspectRatio(
                        //   aspectRatio: 3 / 2,
                        //   child: AIImage(
                        //     viewModel.story.medias![i].link,
                        //     fit: BoxFit.cover,
                        //     width: double.infinity,
                        //   ),
                        // ),
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
