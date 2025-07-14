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
          onTap: viewModel.showDetailDialog,
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
                      InkWell(
                        onTap: viewModel.onTapUserAvatar,
                        child: AIAvatarImage(
                          viewModel.owner?.avatar,
                          width: kStoryAvatarSize,
                          height: kStoryAvatarSize,
                          fullname: viewModel.owner?.fullName ?? 'Test',
                          textSize: 24,
                          isBorder: true,
                          borderWidth: 2,
                          borderRadius: kStoryAvatarSize / 2,
                        ),
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
                              'Vybe Virtual Try-On',
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
                                    ' ${viewModel.story.votes?.length ?? 0} / 5 Looks Today',
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
                  const SizedBox(height: 12.0),
                  StoryMediaCellView(models: story.medias ?? []),
                  const SizedBox(height: 16),
                  if (viewModel.story.category != null &&
                      viewModel.story.category == 'vote') ...{
                    StoryYayNayWidget(),
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

class StoryPageableCell extends StatelessWidget {
  final StoryModel story;

  const StoryPageableCell({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryProvider>.reactive(
      viewModelBuilder: () => StoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        var media = (story.medias ?? [])[viewModel.pageIndex];
        logger.d(media.toJson());
        return Stack(
          children: [
            AIImage(
              media.link,
              width: double.infinity,
              height: double.infinity,
              // fit: BoxFit.contain,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                const Spacer(flex: 2),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00ffffff), Color(0xcfffffff)],
                      ),
                    ),
                    child: InkWell(
                      onTap: viewModel.showDetailDialog,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.0,
                        children: [
                          const Spacer(),
                          if (viewModel.isComment) ...{
                            Container(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom,
                              ),
                              decoration: BoxDecoration(
                                // color: Theme.of(context).colorScheme.onSecondary,
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
                                          color: AIColors.black,
                                          width: 20,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: AIImage(
                                          AIImages.icCamera,
                                          color: AIColors.black,
                                          width: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: QuillSimpleToolbar(
                                          controller: viewModel.quillController,
                                          config: QuillSimpleToolbarConfig(
                                            toolbarIconAlignment:
                                                WrapAlignment.start,
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
                                      border: Border.all(color: AIColors.grey),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: QuillEditor(
                                            focusNode: viewModel.focusNode,
                                            scrollController:
                                                viewModel.quillScrollController,
                                            controller:
                                                viewModel.quillController,

                                            config: QuillEditorConfig(
                                              autoFocus: false,
                                              expands: false,
                                              placeholder: 'Comments...',
                                              padding: const EdgeInsets.all(12),
                                              customStyles: DefaultStyles(
                                                placeHolder:
                                                    DefaultTextBlockStyle(
                                                      TextStyle(
                                                        fontSize: 16,
                                                        color: AIColors.grey,
                                                      ),
                                                      HorizontalSpacing.zero,
                                                      VerticalSpacing.zero,
                                                      VerticalSpacing.zero,
                                                      null,
                                                    ),
                                                paragraph:
                                                    DefaultTextBlockStyle(
                                                      TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onPrimary,
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
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
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
                          } else ...{
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12.0,
                              children: [
                                if (viewModel.story.category != null &&
                                    viewModel.story.category == 'vote') ...{
                                  StoryYayNayWidget(),
                                },
                                Row(
                                  spacing: 12.0,
                                  children: [
                                    Text(
                                      viewModel.owner?.fullName ?? '---',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.headlineMedium,
                                    ),
                                    Text(
                                      '· ${viewModel.story.timestamp?.timeago}',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                                if (viewModel.story.category != null &&
                                    viewModel.story.category == 'vote') ...{
                                  Column(
                                    children: [
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Vybe Virtual Try-On',
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(16),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.leaderboard_outlined,
                                                  size: 18,
                                                ),
                                                Text(
                                                  ' ${viewModel.story.votes?.length ?? 0} / 5 Looks Today',
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                },
                              ],
                            ),
                          },
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(right: 8.0, bottom: 56),
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 16.0,
                ),
                // decoration: BoxDecoration(
                //   color: Theme.of(context).colorScheme.secondary.withAlpha(64),
                //   borderRadius: BorderRadius.circular(36.0),
                // ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20.0,
                  children: [
                    InkWell(
                      onTap: viewModel.onTapUserAvatar,
                      child: AIAvatarImage(
                        key: GlobalKey(debugLabel: 'story-${story.id}'),
                        viewModel.owner?.avatar,
                        width: kStoryAvatarSize * 0.8,
                        height: kStoryAvatarSize * 0.8,
                        fullname: viewModel.owner?.fullName ?? 'Test',
                        textSize: 24,
                        isBorder: true,
                        borderWidth: 2,
                        borderRadius: kStoryAvatarSize / 2,
                      ),
                    ),
                    StoryActionButton(
                      src: Icons.favorite,
                      label: '${(viewModel.story.likes ?? []).length}',
                      onTap: () {},
                    ),
                    StoryActionButton(
                      src: Icons.share,
                      label: '${(viewModel.story.follows ?? []).length}',
                      onTap: () {},
                    ),
                    StoryActionButton(
                      src: Icons.comment,
                      label: '${(viewModel.story.comments ?? []).length}',
                      onTap: () {
                        viewModel.isComment = !viewModel.isComment;
                      },
                    ),
                    StoryActionButton(src: Icons.post_add, onTap: () {}),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class StoryYayNayWidget extends ViewModelWidget<StoryProvider> {
  const StoryYayNayWidget({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Padding(
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
    );
  }
}

class StoryActionButton extends StatelessWidget {
  final IconData src;
  final String? label;
  final void Function()? onTap;

  const StoryActionButton({
    super.key,
    required this.src,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        spacing: 2.0,
        children: [
          Icon(
            src,
            size: kStoryAvatarSize * 0.6,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          if (label != null) ...{
            Text(
              label!,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          },
        ],
      ),
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
                if (notification is ScrollUpdateNotification) {
                  if (viewModel.scrollController.offset < -50) {
                    viewModel.popupDialog();
                  }
                  return false;
                }
                return true;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                  controller: viewModel.scrollController,
                  physics: BouncingScrollPhysics(),
                  child: AppBackgroundView(
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
                              if ((viewModel.story.medias ?? [])
                                  .isNotEmpty) ...{
                                const SizedBox(height: 8.0),
                                StoryDialogMediaView(),
                              },
                              const SizedBox(height: 8.0),
                              Text(
                                viewModel.story.shownHMDate,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Divider(
                                thickness: 0.2,
                                height: 24.0,
                                color: AIColors.speraterColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                thickness: 0.2,
                                height: 24.0,
                                color: AIColors.speraterColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        width: 20.0,
                                        height: 20.0,
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
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: viewModel.onClickRepost,
                                    child: AIImage(
                                      AIImages.icRetwitter,
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
                              Divider(
                                thickness: 0.2,
                                height: 24.0,
                                color: AIColors.speraterColor,
                              ),
                            ],
                          ),
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
                                in (viewModel.story.comments?.reversed
                                        .toList() ??
                                    [])) ...{
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 4.0,
                                ),
                                child: StoryDetailCommentCell(
                                  key: GlobalKey(
                                    debugLabel:
                                        '${comment.userId} - ${viewModel.story.comments?.reversed.toList().indexOf(comment)}',
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
                        SizedBox(height: 198.0),
                      ],
                    ),
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
                    // color: Theme.of(context).colorScheme.onSecondary,
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
