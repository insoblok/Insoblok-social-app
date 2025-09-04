import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kStoryAvatarSize = 50.0;

class StoryListCell extends StatelessWidget {
  final StoryModel story;
  final bool? enableDetail;
  final bool? enableReaction;
  final double? marginBottom;

  const StoryListCell({super.key, required this.story, this.enableDetail, this.enableReaction, this.marginBottom});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryProvider>.reactive(
      viewModelBuilder: () => StoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {

         final canOpen = enableDetail ?? false;
         final canReaction = enableReaction ?? false;

        return InkWell(
          onTap: canOpen
              ? () => viewModel.goToLookbookDetailPage() // or story.id
              : null,
          child: Stack(
            children: [
              if ((story.medias ?? []).isNotEmpty) ...{
                PageView.builder(
                  itemCount: (viewModel.story.medias ?? []).length,
                  itemBuilder: (context, index) {
                    if(viewModel.videoStoryPath == null){
                      return StoryMediaView(
                        media:
                            ((viewModel.resultFaceUrl?.isNotEmpty ?? false) &&
                                    viewModel.showFaceDialog)
                                ? MediaStoryModel(
                                  link: viewModel.resultFaceUrl,
                                  type: 'image',
                                  width:
                                      (story.medias ?? [])[viewModel.pageIndex]
                                          .width,
                                  height:
                                      (story.medias ?? [])[viewModel.pageIndex]
                                          .height,
                                )
                                : (story.medias ?? [])[viewModel.pageIndex],
                      );
                    }else{
                      return _CircularVideoPlayer(videoPath: viewModel.videoStoryPath!);
                    }
                  },
                  onPageChanged: (value) {
                    viewModel.pageIndex = value;
                  },
                ),
              } else ...{
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 124.0,
                      bottom: 124.0,
                    ),
                    child: AIHelpers.htmlRender(
                      story.text,
                      fontSize: FontSize(32.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              },
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
                          colors: [Color(0x00000000), Color(0xcf000000)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12.0,
                        children: [
                          const Spacer(),
                          if(viewModel.isVideoReaction)...{
                            if (viewModel.videoPath != null && viewModel.showFaceDialog && canReaction) ...{
                              CommentFaceVideoModalView(marginBottom: marginBottom)
                            } else ...{
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: marginBottom ?? 0,
                                ),
                                child: Column(
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
                                              ).textTheme.headlineMedium,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                              ),
                            }
                          } else ...{
                            if (viewModel.face != null && viewModel.showFaceDialog && canReaction) ...{
                            CommentFaceModalView(marginBottom: marginBottom),
                            } else ...{
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: marginBottom ?? 0,
                                ),
                                child: Column(
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
                                              ).textTheme.headlineMedium,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                              ),
                            },
                          }
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(
                    right: 8.0,
                    bottom: marginBottom != null ? marginBottom! + 56 : 56,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12.0,
                    children: [
                      SizedBox(
                        width: kStoryAvatarSize * 0.8,
                        height: kStoryAvatarSize,
                        child: Stack(
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Icon(
                                  Icons.add,
                                  size: 12,
                                  color: AIColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      StoryActionButton(
                        src: Icon(Icons.favorite, size: kStoryAvatarSize * 0.5),
                        label: '${(viewModel.story.likes ?? []).length}',
                        onTap: viewModel.updateLike,
                      ),
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icComment,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.5,
                        ),
                        label: '${(viewModel.story.comments ?? []).length}',
                        onTap: () {
                          viewModel.showCommentDialog();
                        },
                      ),
                      
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icView,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.46,
                        ),
                        label: '${(viewModel.story.views ?? []).length}',
                      ),
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icGallery,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.5,
                        ),
                        onTap: () {
                            viewModel.showReactions();
                        }
                      ),
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icShare,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.4,
                        ),
                        label: '',
                        onTap: () {
                          AIHelpers.shareStory(context, story: story);
                        },
                      ),
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icRepost,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.46,
                        ),
                        onTap: viewModel.repost,
                      ),
                      // if (viewModel.face != null) ...{
                      //   const SizedBox(height: 0.0),
                      //   StoryActionButton(
                      //     src: Icon(Icons.face, size: kStoryAvatarSize * 0.5),
                      //     onTap: () {
                      //       viewModel.showFaceDialog = !viewModel.showFaceDialog;
                      //     },
                      //   ),
                      // },
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: EdgeInsets.only(
                    left: 8.0,
                    bottom: marginBottom != null ? marginBottom! + 156 : 156,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12.0,
                    children: [
                      if(canReaction) ...{
                          StoryActionButton(
                          src: AIImage(
                            AIImages.icReactionVideo,
                            color: (viewModel.isVideoReaction && viewModel.showFaceDialog) ? AIColors.pink : AIColors.white,
                            width: kStoryAvatarSize * 0.5,
                          ),
                          label: 'V-React',
                          onTap: () {
                            viewModel.setVideoReaction();
                          },
                        ),
                        StoryActionButton(
                          src: AIImage(
                            AIImages.icReactionImage,
                            color: (viewModel.isVideoReaction && viewModel.showFaceDialog)  ? AIColors.white : AIColors.pink,
                            width: kStoryAvatarSize * 0.5,
                          ),
                          label: 'I-Recat',
                          onTap: () {
                            viewModel.setImageReaction();
                          },
                        ),
                      },
                    ],
                  ),
                ),
              ),
              if ((viewModel.story.medias ?? []).length > 1) ...{
                Positioned(
                  left: 20.0,
                  top: MediaQuery.of(context).padding.top + 40.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withAlpha(64),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Text(
                      '${viewModel.pageIndex + 1} / ${(viewModel.story.medias ?? []).length}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              },
              if (viewModel.isBusy) Center(child: Loader(size: 60.0)),
            ],
          ),
        );
      },
    );
  }
}

class StoryFaceModalView extends ViewModelWidget<StoryProvider> {
  final double? marginBottom;
  const StoryFaceModalView({super.key, this.marginBottom});

  @override
  Widget build(BuildContext context, viewModel) {
    return InkWell(
      onTap:
          () => Routers.goToFaceDetailPage(
            context,
            viewModel.story.id!,
            (viewModel.story.medias ?? [])[viewModel.pageIndex].link!,
            viewModel.face!,
            viewModel.annotations,
            false
          ),
          
      child: Container(
        margin: EdgeInsets.only(bottom: marginBottom ?? 0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(64.0),
        ),
        child: Row(
          children: [
            ClipOval(
              child: AIImage(
                viewModel.face,
                width: 64.0,
                height: 64.0,
                fit: BoxFit.cover,
              ),
            ),
            for (var content in viewModel.annotations) ...{
              Expanded(
                child: Column(
                  spacing: 4.0,
                  children: [
                    AIImage(content.icon, width: 32.0, height: 32.0),
                    Text(
                      '${content.title}\n${content.desc}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

class StorySendCommentWidget extends StatelessWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;
  final double? marginBottom;
  final void Function()? onSend;

  const StorySendCommentWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrollController,
    this.onSend,
    this.marginBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom:
            marginBottom != null
                ? MediaQuery.of(context).padding.bottom + marginBottom!
                : MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AIColors.speraterColor, width: 0.33),
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
                  color: Theme.of(context).colorScheme.secondary,
                  width: 20,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: AIImage(
                  AIImages.icCamera,
                  color: Theme.of(context).colorScheme.secondary,
                  width: 20,
                ),
              ),
              Expanded(
                child: QuillSimpleToolbar(
                  controller: controller,
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
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: AIColors.grey),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: QuillEditor(
                    focusNode: focusNode,
                    scrollController: scrollController,
                    controller: controller,
                    config: QuillEditorConfig(
                      autoFocus: false,
                      expands: false,
                      placeholder: 'Comments...',
                      padding: const EdgeInsets.all(12),
                      // textInputAction: TextInputAction.send,
                      onKeyPressed: (event, node) {
                        if (event.logicalKey == LogicalKeyboardKey.enter) {
                          onSend;
                        }
                        return null;
                      },
                      customStyles: DefaultStyles(
                        placeHolder: DefaultTextBlockStyle(
                          TextStyle(fontSize: 16, color: AIColors.grey),
                          HorizontalSpacing.zero,
                          VerticalSpacing.zero,
                          VerticalSpacing.zero,
                          null,
                        ),
                        paragraph: DefaultTextBlockStyle(
                          TextStyle(fontSize: 16),
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
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AIColors.pink,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: IconButton(
                      onPressed: onSend,
                      icon: Icon(Icons.arrow_upward_outlined, size: 15.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoryMediaView extends StatefulWidget {
  final MediaStoryModel media;

  const StoryMediaView({super.key, required this.media});

  @override
  State<StoryMediaView> createState() => _StoryMediaViewState();
}

class _StoryMediaViewState extends State<StoryMediaView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.type == 'image') {
      return AIImage(
        widget.media.link,
        width: double.infinity,
        height: double.infinity,
        fit:
            ((widget.media.height ?? 1) / (widget.media.width ?? 1) > 1.2)
                ? BoxFit.cover
                : BoxFit.contain,
      );
    }
    debugPrint("THis is media link ${widget.media.link}");
    return CloudinaryVideoPlayerWidget(videoUrl: widget.media.link!);
  }
}

class StoryYayNayWidget extends ViewModelWidget<StoryProvider> {
  const StoryYayNayWidget({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: VoteFloatingButton(
            onTap: () {
              viewModel.updateVote(true);
            },
            text:
                viewModel.story.cntYay == 0
                    ? 'Hot'
                    : 'Hot (${viewModel.story.cntYay})',
            textColor: AIColors.green,
            src: AIImages.icHot,
            imgSize: 28,
            backgroundColor:
                viewModel.story.isVote() == true
                    ? AIColors.green.withAlpha(64)
                    : Colors.transparent,
            borderColor: AIColors.green,
          ),
        ),
        const SizedBox(width: 30),
        IntrinsicWidth(
          child: VoteFloatingButton(
            onTap: () {
              viewModel.updateVote(false);
            },
            text:
                viewModel.story.cntNay == 0
                    ? 'Not'
                    : 'Not (${viewModel.story.cntNay})',
            textColor: AIColors.pink,
            src: AIImages.icNot,
            imgSize: 28,
            backgroundColor:
                viewModel.story.isVote() == false
                    ? AIColors.pink.withAlpha(64)
                    : AIColors.transparent,
            borderColor: AIColors.pink,
          ),
        ),
      ],
    );
  }
}

class StoryActionButton extends StatelessWidget {
  final Widget src;
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
        children: [
          src,
          if (label != null) ...{
            Text(label!, style: Theme.of(context).textTheme.bodySmall),
          },
        ],
      ),
    );
  }
}

class StoryCommentDialog extends StatefulWidget {
  final StoryModel story;

  const StoryCommentDialog({super.key, required this.story});

  @override
  State<StoryCommentDialog> createState() => _StoryCommentDialogState();
}

class _StoryCommentDialogState extends State<StoryCommentDialog>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<StoryContentProvider>.reactive(
      viewModelBuilder: () => StoryContentProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, model: widget.story),
      builder: (context, viewModel, _) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            gradient: LinearGradient(
              colors: [
                AIColors.lightPurple.withAlpha(32),
                AIColors.lightBlue.withAlpha(32),
                AIColors.lightPurple.withAlpha(32),
                AIColors.lightTeal.withAlpha(32),
              ],
              stops: [0.0, 0.4, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AIColors.transparent,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text(
                      ' ${viewModel.story.comments?.length ?? 0} comments',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    InkWell(
                      onTap: viewModel.popupDialog,
                      child: Icon(Icons.close, size: 26),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        for (var comment in viewModel.comments) ...{
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 4.0,
                            ),
                            child: StoryDetailCommentCell(
                              key: GlobalKey(
                                debugLabel:
                                    '${comment.id} - ${comment.storyId}',
                              ),
                              comment: comment,
                              selected: viewModel.replyCommentId == comment.id,
                              onTap: () {
                                if (viewModel.replyCommentId == comment.id) {
                                  viewModel.replyCommentId = null;
                                } else {
                                  viewModel.replyCommentId = comment.id;
                                }
                              },
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                StorySendCommentWidget(
                  controller: viewModel.quillController,
                  focusNode: viewModel.focusNode,
                  scrollController: viewModel.quillScrollController,
                  onSend: () {
                    viewModel.sendComment(
                      viewModel.story.id ?? '',
                      commentId: viewModel.replyCommentId,
                    );
                  },
                ),
              ],
            ),
          ),
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

class CommentFaceModalView extends ViewModelWidget<StoryProvider> {
  final double? marginBottom;
  const CommentFaceModalView({super.key, this.marginBottom});
  
  @override
  Widget build(BuildContext context, viewModel) {
    logger.d("CommentFaceModalView");
    return InkWell(
      
      onTap: () => Routers.goToFaceDetailPage(
        context,
        viewModel.story.id!,
        (viewModel.story.medias ?? [])[viewModel.pageIndex].link!,
        viewModel.face!,
        viewModel.annotations,
        true
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: marginBottom ?? 0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Original content row
            Row(
              children: [
                ClipOval(
                  child: AIImage(
                    viewModel.face!,
                    width: 64.0,
                    height: 64.0,
                    fit: BoxFit.cover,
                    key: ValueKey(viewModel.face!.path + DateTime.now().millisecondsSinceEpoch.toString()),
                  ),
                ),
                for (var content in viewModel.annotations) ...{
                  Expanded(
                    child: Column(
                      spacing: 4.0,
                      children: [
                        AIImage(content.icon, width: 32.0, height: 32.0),
                        Text(
                          '${content.title}\n${content.desc}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                },
              ],
            ),
            
            // Spacing between content and buttons
            const SizedBox(height: 5.0),
            
            // Button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => viewModel.onPostReactionPressed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => viewModel.onPostDeclinePressed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentFaceVideoModalView extends ViewModelWidget<StoryProvider> {
  final double? marginBottom;
  const CommentFaceVideoModalView({super.key, this.marginBottom});

  @override
  Widget build(BuildContext context, viewModel) {
    return InkWell(
      onTap: () => (),
      child: Container(
        margin: EdgeInsets.only(bottom: marginBottom ?? 0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                if (viewModel.videoPath != null)
                _VideoPreviewWidget(videoPath: viewModel.videoPath!, onRecapture: viewModel.captureReactionVideo, onEditVideo: viewModel.onEditReactionVideoPressed, refreshCount: viewModel.refreshCount),

                ElevatedButton(
                  onPressed: () => viewModel.onPostReactionVideoPressed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => viewModel.onPostDeclinePressed(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPreviewWidget extends StatefulWidget {
  final String videoPath;
  final VoidCallback onRecapture; // Callback to trigger re-capture
  final VoidCallback onEditVideo;
  final int refreshCount;

  const _VideoPreviewWidget({
    required this.videoPath,
    required this.onRecapture,
    required this.onEditVideo,
    required this.refreshCount,
  });

  @override
  State<_VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<_VideoPreviewWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    logger.d("path replaced at widget.videoPath : ${widget.videoPath}");
    _initializeVideo(widget.videoPath);
  }

  void _initializeVideo(String path) {
    _controller = VideoPlayerController.file(File(path))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleRecapture() {
    widget.onRecapture(); // Calls parent method to recapture
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64.0,
      height: 64.0,
      
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          
          ClipOval(
            child: Material(
              color: Colors.transparent,                     // needed for ripple
              child: InkWell(
                customBorder: const CircleBorder(),          // ripple clipped to circle
                onTap: widget.onEditVideo,
                child: SizedBox.expand(                      // fill 64x64
                  child: _initialized
                      ? VideoPlayer(_controller)
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                ),
              ),
            ),
          ),
          // ...[if(widget.refreshCount < 3)
          //       Positioned(
          //         top: -6,
          //         right: -6,
          //         child: InkWell(
          //           onTap: _handleRecapture,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               color: Colors.black.withOpacity(0.6),
          //               shape: BoxShape.circle,
          //             ),
          //             padding: const EdgeInsets.all(4),
          //             child: const Icon(
          //               Icons.refresh,
          //               size: 16,
          //               color: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ),
          // ]
        ],
      ),
    );
  }
}

class _CircularVideoPlayer extends StatefulWidget {
  final String videoPath;
  
  const _CircularVideoPlayer({required this.videoPath});

  @override
  State<_CircularVideoPlayer> createState() => _CircularVideoPlayerState();
}

class _CircularVideoPlayerState extends State<_CircularVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.videoPath.startsWith('http') || widget.videoPath.startsWith('https')) {
      _controller = VideoPlayerController.network(widget.videoPath);
    } else {
      _controller = VideoPlayerController.file(File(widget.videoPath));
    }

    _controller.initialize().then((_) {
      setState(() {
        _initialized = true;
        _controller.setLooping(true);
        _controller.play();
      });
    }).catchError((error) {
      // Handle errors if needed, e.g. show error UI
      print("Video initialization error: $error");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.7;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        child: _initialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }

}
