// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:stacked/stacked.dart';
import 'package:video_player/video_player.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

const kStoryAvatarSize = 50.0;

class StoryListCell extends StatelessWidget {
  final StoryModel story;
  final bool? enableDetail;
  final bool? enableReaction;
  final double? marginBottom;
  const StoryListCell({
    super.key,
    required this.story,
    this.enableDetail,
    this.enableReaction,
    this.marginBottom,

  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryProvider>.reactive(
      viewModelBuilder: () => StoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return InkWell(
          onTap: () => {viewModel.startRRC()},
          child: Container(
            padding: const EdgeInsets.all(0.0),
            child: Stack(
              children: [
                // ======== MEDIA ========
                if ((story.medias ?? []).isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),  // bottom margin (outside)
                    padding: const EdgeInsets.only(bottom: 24), // bottom padding (inside)
                    child : PageView.builder(
                      itemCount: (viewModel.story.medias ?? []).length,
                      itemBuilder: (context, index) {
                        if (viewModel.videoStoryPath == null) {
                          return StoryMediaView(
                            media: ((viewModel.resultFaceUrl?.isNotEmpty ?? false) &&
                                    viewModel.showFaceDialog)
                                ? MediaStoryModel(
                                    link: viewModel.resultFaceUrl,
                                    type: 'image',
                                    width: (story.medias ?? [])[viewModel.pageIndex].width,
                                    height: (story.medias ?? [])[viewModel.pageIndex].height,
                                  )
                                : (story.medias ?? [])[viewModel.pageIndex],
                          );
                        } else {
                          return _CircularVideoPlayer(videoPath: viewModel.videoStoryPath!);
                        }
                      },
                      onPageChanged: (value) => viewModel.pageIndex = value,
                    )
                  )
                else
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 124.0),
                      child: AIHelpers.htmlRender(
                        story.text,
                        fontSize: FontSize(32.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            
                // ======== BOTTOM GRADIENT OVERLAY (text/info only) ========
                Column(
                  children: [
                    // const Spacer(flex: 2),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00000000), Color(0xCF000000)],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 0.0, bottom: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if(viewModel.showFaceDialog)
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 00, bottom: 0),
                                      child: ZoMultiColorBorder(
                                        // the ring stays mounted; only its child swaps
                                        colors: const [Colors.orange, Colors.white, Colors.green, Colors.indigo, Colors.pink],
                                        strokeWidth: 3,
                                        borderRadius: 75, // if your widget expects a double radius
                                        child: Padding(
                                          // 0.1 px is okay but effectively invisible; keep or set to 1.0
                                          padding: const EdgeInsets.all(0.1),
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            // Only the inside content animates
                                            child: AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 250),
                                              switchInCurve: Curves.easeOut,
                                              switchOutCurve: Curves.easeIn,
                                              layoutBuilder: (currentChild, previousChildren) {
                                                // keeps size stable while animating
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: <Widget>[
                                                    ...previousChildren,
                                                    if (currentChild != null) currentChild,
                                                  ],
                                                );
                                              },
                                              child: viewModel.isCapturingTimer
                                                  ? _ReadyPreview(
                                                      key: const ValueKey('state-ready'),
                                                      isVideo: viewModel.isVideoReaction,
                                                      videoPath: viewModel.videoPath,
                                                      hasFace: viewModel.face != null,
                                                    )
                                                  : _Counting(
                                                      key: const ValueKey('state-count'),
                                                      isVideo: viewModel.isVideoReaction,
                                                      onStartVideo: viewModel.captureReactionVideo,
                                                      onStartImage: viewModel.captureReactionImage,
                                                      onComplete: () {
                                                        // Flip provider flag AFTER this frame; avoids "notify during build"
                                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                                          viewModel.completeTimer(); // sets isCapturingTimer = true + notifyListeners()
                                                        });
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                
                                  if (viewModel.story.category == 'vote') const StoryYayNayWidget(),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Avatar (your existing widget)
                                        SizedBox(
                                          width: kStoryAvatarSize * 0.8,
                                          height: kStoryAvatarSize * 0.8,
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
                                              // Align(
                                              //   alignment: Alignment.bottomCenter,
                                              //   child: Container(
                                              //     width: 16,
                                              //     height: 16,
                                              //     decoration: BoxDecoration(
                                              //       gradient: const LinearGradient(
                                              //         begin: Alignment.topLeft,
                                              //         end: Alignment.bottomRight,
                                              //         colors: [Colors.white, Colors.grey],
                                              //       ),
                                              //       borderRadius: BorderRadius.circular(8.0),
                                              //     ),
                                              //     child: Icon(Icons.add, size: 12, color: AIColors.white),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
            
                                        const SizedBox(width: 10),
            
                                        // Right side: name/timestamp + (optional) progress
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // First row: Name + (optional "Following" pill) + time
                                              Wrap(
                                                crossAxisAlignment: WrapCrossAlignment.center,
                                                alignment: WrapAlignment.start,
                                                spacing: 8,
                                                runSpacing: 4,
                                                children: [
                                                  Text(
                                                    viewModel.owner?.fullName ?? '---',
                                                    style: Theme.of(context).textTheme.headlineSmall,
                                                  ),
            
                                                  
                                                  Text(
                                                    '· ${viewModel.story.timestamp?.timeago}',
                                                    style: Theme.of(context).textTheme.headlineSmall,
                                                  ),
                                                ],
                                              ),
            
                                              const SizedBox(height: 6),
            
                                              // Second line: Progress (with a small avatar dot like the screenshot)
                                              if (viewModel.story.category == 'vote')
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    // tiny avatar beside progress line
                                                    Expanded(
                                                      child: Text(
                                                        'Vybe Virtual Try-On + progress (${viewModel.story.votes?.length ?? 0} / 5 Looks Today)',
                                                        style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.secondary.withAlpha(16),
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            
                // ======== RIGHT ACTIONS ========
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 8.0,
                      bottom: marginBottom != null ? marginBottom! + 5 : 5,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 12.0,
                      children: [
                        
                        StoryActionButton(
                          src: Padding(
                            padding: const EdgeInsets.only(bottom: 6), // <-- gap between icon & count
                            child: AIImage(
                              AIImages.icView,
                              color: Theme.of(context).colorScheme.secondary,
                              width: kStoryAvatarSize * 0.46,
                            ),
                          ),
                          label: '${(viewModel.story.views ?? []).length}',
                        ),
                        StoryActionButton(
                          src: AIImage(
                            AIImages.icComment,
                            color: Theme.of(context).colorScheme.secondary,
                            width: kStoryAvatarSize * 0.5,
                          ),
                          label: '${(viewModel.story.comments ?? []).length}',
                          onTap: () => viewModel.showCommentDialog(),
                        ),
                        StoryActionButton(
                          src: AIImage(
                            AIImages.icShare,
                            color: Theme.of(context).colorScheme.secondary,
                            width: kStoryAvatarSize * 0.4,
                          ),
                          label: '',
                          // onTap: () => AIHelpers.shareStoryToLookbook(context, story: story),
                          onTap: () => viewModel.repost(),
                        ),
                        StoryActionButton(
                          src: AIImage(
                            AIImages.icGallery,
                            color: Theme.of(context).colorScheme.secondary,
                            width: kStoryAvatarSize * 0.5,
                          ),
                          onTap: () => viewModel.showReactions(),
                        ),
            
                        StoryActionButton(
                          src: AIImage(
                            AIImages.icVoteUp,
                            color: AIColors.orange,
                            width: kStoryAvatarSize * 0.5,
                          ),
                          label: '${(viewModel.story.cntNay)}',
                        ),
            
                        StoryActionButton(
                          src: AIImage(
                            AIImages.icVoteDown,
                            color: Colors.blue,
                            width: kStoryAvatarSize * 0.5,
                          ),
                          label: '${(viewModel.story.cntYay)}',
                        ),
                      ],
                    ),
                  ),
                ),
            
                // ======== BOTTOM-LEFT: SLIDER ========
            
                // ======== PAGE INDICATOR ========
                if ((viewModel.story.medias ?? []).length > 1)
                  Positioned(
                    left: 20.0,
                    top: MediaQuery.of(context).padding.top + 90.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary.withAlpha(64),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Text(
                        '${viewModel.pageIndex + 1} / ${(viewModel.story.medias ?? []).length}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
            
                if (viewModel.isBusy) const Center(child: Loader(size: 60.0)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SliderSpotPreview extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const _SliderSpotPreview({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Material(
          color: Colors.transparent,
          elevation: 6,
          shape: const CircleBorder(),
          child: child, 
        ),
      ),
    );
  }
}

class StoryFaceModalView extends ViewModelWidget<StoryProvider> {
  final double? marginBottom;
  const StoryFaceModalView({super.key, this.marginBottom});

  @override
  Widget build(BuildContext context, viewModel) {
    return InkWell(
      onTap: () => Routers.goToFaceDetailPage(
        context,
        viewModel.story.id!,
        (viewModel.story.medias ?? [])[viewModel.pageIndex].link!,
        viewModel.face!,
        viewModel.annotations,
        false,
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
        bottom: marginBottom != null
            ? MediaQuery.of(context).padding.bottom + marginBottom!
            : MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AIColors.speraterColor, width: 0.33)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: AIImage(AIImages.icImage, color: Theme.of(context).colorScheme.secondary, width: 20),
              ),
              IconButton(
                onPressed: () {},
                icon: AIImage(AIImages.icCamera, color: Theme.of(context).colorScheme.secondary, width: 20),
              ),
              Expanded(
                child: QuillSimpleToolbar(
                  controller: controller,
                  config: const QuillSimpleToolbarConfig(
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          const TextStyle(fontSize: 16),
                          HorizontalSpacing.zero,
                          VerticalSpacing.zero,
                          VerticalSpacing.zero,
                          null,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AIColors.pink, borderRadius: BorderRadius.circular(15.0)),
                    child: IconButton(
                      onPressed: onSend,
                      icon: const Icon(Icons.arrow_upward_outlined, size: 15.0),
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
  Widget build(BuildContext context) {
    if (widget.media.type == 'image') {
      return AIImage(
        widget.media.link,
        width: double.infinity,
        height: double.infinity,
        fit: ((widget.media.height ?? 1) / (widget.media.width ?? 1) > 1.2) ? BoxFit.cover : BoxFit.fitWidth,
      );
    }
    return CloudinaryVideoPlayerWidget(videoUrl: widget.media.link!);
  }
}

class StoryYayNayWidget extends ViewModelWidget<StoryProvider> {
  const StoryYayNayWidget({super.key});
  @override
  Widget build(BuildContext context, viewModel) {

    final radius = 24.0;
    logger.d("all votes are ${viewModel.story.votes}, ${viewModel.story.votes?.length}");
    logger.d("current vote status is ${viewModel.story.isVote()}");
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,           
                    colors: [Colors.orange, Colors.deepOrangeAccent],
                  ),
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: 
                  viewModel.story.isVote() == true
                  ? [
                    BoxShadow(
                      color: const Color.fromARGB(255, 180, 109, 3).withOpacity(0.5),
                      blurRadius: 10,                        
                      spreadRadius: 5,                       
                      offset: const Offset(0, 3),            
                    ),
                  ] : [],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(radius),
                  // onTap: () => viewModel.updateVote(false),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: VoteFloatingButton(
                      onTap: () {
                        if(viewModel.story.isVote() != true) {
                          viewModel.updateVote(true);
                        }
                      },
                      text: 'Hot',
                      textColor: AIColors.white,
                      src: AIImages.icFireHot,
                      imgSize: 24,
                      backgroundColor: viewModel.story.isVote() == true ? Colors.orange : Colors.transparent,
                      borderColor: AIColors.orange
                    ),
                  ),
                ),
              ),
      
              const SizedBox(width: 30),
              Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: viewModel.story.isVote() == false 
                  ? [
                    BoxShadow(
                      color: Colors.blue, 
                      blurRadius: 10,                       
                      spreadRadius: 5,                      
                      offset: const Offset(0, 3),           
                    ),
                  ] : [],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(radius),
                  // onTap: () => viewModel.updateVote(true),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    child: VoteFloatingButton(
                      onTap: () {
                        if(viewModel.story.isVote() != false) {
                          viewModel.updateVote(false);
                        }
                      },
                      text: 'Not',
                      textColor: AIColors.white,
                      src: AIImages.icFireNot,
                      imgSize: 24,
                      backgroundColor: viewModel.story.isVote() == false ? AIColors.lightBlue : Colors.transparent,
                      borderColor: AIColors.lightBlue
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

class StoryActionButton extends StatelessWidget {
  final Widget src;
  final String? label;
  final void Function()? onTap;
  const StoryActionButton({super.key, required this.src, this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          src,
          if (label != null) Text(label!, style: Theme.of(context).textTheme.bodySmall),
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

class _StoryCommentDialogState extends State<StoryCommentDialog> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ViewModelBuilder<StoryContentProvider>.reactive(
      viewModelBuilder: () => StoryContentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: widget.story),
      builder: (context, viewModel, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
            gradient: LinearGradient(
              colors: [
                AIColors.lightPurple.withAlpha(32),
                AIColors.lightBlue.withAlpha(32),
                AIColors.lightPurple.withAlpha(32),
                AIColors.lightTeal.withAlpha(32),
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
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
                    Text(' ${viewModel.story.comments?.length ?? 0} comments',
                        style: Theme.of(context).textTheme.bodyMedium),
                    InkWell(onTap: viewModel.popupDialog, child: const Icon(Icons.close, size: 26)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        for (var comment in viewModel.comments)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                            child: StoryDetailCommentCell(
                              key: GlobalKey(debugLabel: '${comment.id} - ${comment.storyId}'),
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
                      ],
                    ),
                  ),
                ),
                StorySendCommentWidget(
                  controller: viewModel.quillController,
                  focusNode: viewModel.focusNode,
                  scrollController: viewModel.quillScrollController,
                  onSend: () => viewModel.sendComment(
                    viewModel.story.id ?? '',
                    commentId: viewModel.replyCommentId,
                  ),
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
              for (var i = 0; i < viewModel.story.medias!.length; i++)
                AspectRatio(
                  aspectRatio: 0.6,
                  child: InkWell(
                    onTap: () => AIHelpers.goToDetailView(
                      context,
                      medias: (viewModel.story.medias ?? []).map((m) => m.link!).toList(),
                      index: i,
                      storyID: viewModel.story.id!,
                      storyUser: viewModel.story.userId!,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.33, color: AIColors.speraterColor),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: AIColors.grey, borderRadius: BorderRadius.circular(6)),
                          child: MediaCarouselCell(media: viewModel.story.medias![i]),
                        ),
                      ),
                    ),
                  ),
                ),
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
    return Container(width: double.infinity, height: 200.0, alignment: Alignment.center, child: Text(description));
  }
}

// ======== FACE CHIP (IMAGE) WITH FADE LOOP (no InkWell so knob remains draggable) ========
class CommentFaceModalView extends ViewModelWidget<StoryProvider> {
  final double? marginBottom;

  /// NEW: control whether the chip is tappable
  final bool tapEnabled;

  /// NEW: optional custom tap callback (defaults to router navigation)
  final VoidCallback? onTap;

  // Animation knobs (unchanged)
  final Duration period;
  final Curve curve;
  final double minOpacity;
  final double maxOpacity;
  final bool alsoPulseScale;
  final double minScale;
  final double maxScale;

  const CommentFaceModalView({
    super.key,
    this.marginBottom,
    this.tapEnabled = true,        // <— default: tappable
    this.onTap,
    this.period = const Duration(milliseconds: 8000),
    this.curve = Curves.easeInOut,
    this.minOpacity = 0.35,
    this.maxOpacity = 1.0,
    this.alsoPulseScale = false,
    this.minScale = 0.95,
    this.maxScale = 1.0,
  });

  @override
  Widget build(BuildContext context, viewModel) {
    final face = viewModel.face;
    final visible = viewModel.showFaceDialog == true;
    if (!visible || face == null) return const SizedBox.shrink();

    // The visual chip
    Widget chip = Container(
      margin: EdgeInsets.only(bottom: marginBottom ?? 0),
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: AIImage(
              face,
              width: 35.0,
              height: 35.0,
              fit: BoxFit.cover,
              key: ValueKey('face-${face.path}-${viewModel.pageIndex}'),
            ),
          ),
        ],
      ),
    );

    // Wrap with InkWell only when tap is enabled
      chip = Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap ??
              () => Routers.goToFaceDetailPage(
                    context,
                    viewModel.story.id!,
                    (viewModel.story.medias ?? [])[viewModel.pageIndex].link!,
                    face,
                    viewModel.annotations,
                    true,
                  ),
          child: chip,
        ),
      );

    return _LoopingFade(
      period: period,
      curve: curve,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      alsoPulseScale: alsoPulseScale,
      minScale: minScale,
      maxScale: maxScale,
      child: chip,
    );
  }
}

class _LoopingFade extends StatefulWidget {
  final Widget child;
  final Duration period;
  final Curve curve;
  final double minOpacity;
  final double maxOpacity;
  final bool alsoPulseScale;
  final double minScale;
  final double maxScale;

  const _LoopingFade({
    required this.child,
    required this.period,
    required this.curve,
    required this.minOpacity,
    required this.maxOpacity,
    required this.alsoPulseScale,
    required this.minScale,
    required this.maxScale,
  });

  @override
  State<_LoopingFade> createState() => _LoopingFadeState();
}

class _LoopingFadeState extends State<_LoopingFade> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _alpha;
  Animation<double>? _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)..repeat(reverse: true);
    _rebuildTweens();
  }

  @override
  void didUpdateWidget(covariant _LoopingFade oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      _ctrl.duration = widget.period;
      _ctrl.reset();
      _ctrl.repeat(reverse: true);
    }
    if (oldWidget.minOpacity != widget.minOpacity ||
        oldWidget.maxOpacity != widget.maxOpacity ||
        oldWidget.curve != widget.curve ||
        oldWidget.alsoPulseScale != widget.alsoPulseScale ||
        oldWidget.minScale != widget.minScale ||
        oldWidget.maxScale != widget.maxScale) {
      _rebuildTweens();
    }
  }

  void _rebuildTweens() {
    final curved = CurvedAnimation(parent: _ctrl, curve: widget.curve);
    _alpha = Tween<double>(begin: widget.minOpacity, end: widget.maxOpacity).animate(curved);
    if (widget.alsoPulseScale) {
      _scale = Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(curved);
    } else {
      _scale = null;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = FadeTransition(opacity: _alpha, child: widget.child);
    if (_scale != null) return ScaleTransition(scale: _scale!, child: content);
    return content;
  }
}

class CommentFaceVideoModalView extends ViewModelWidget<StoryProvider> {
  final double? marginBottom;
  const CommentFaceVideoModalView({super.key, this.marginBottom});

  @override
  Widget build(BuildContext context, viewModel) {
    final path = viewModel.videoPath;
    if (path == null || path.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: marginBottom ?? 0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VideoPreviewWidget(
            key: ValueKey('${path}_${viewModel.refreshCount}'), // force rebuild on change
            videoPath: path,
            onRecapture: viewModel.captureReactionVideo,
            onEditVideo: viewModel.onPostReactionVideoPressed,
            refreshCount: viewModel.refreshCount,
          ),
        ],
      ),
    );
  }
}

class _VideoPreviewWidget extends StatefulWidget {
  final String videoPath;
  final VoidCallback onRecapture;
  final VoidCallback onEditVideo;
  final int refreshCount;

  const _VideoPreviewWidget({
    super.key,
    required this.videoPath,
    required this.onRecapture,
    required this.onEditVideo,
    required this.refreshCount,
  });

  @override
  State<_VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<_VideoPreviewWidget> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initWith(widget.videoPath);
  }

  @override
  void didUpdateWidget(covariant _VideoPreviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize if path or refreshCount changed
    if (oldWidget.videoPath != widget.videoPath ||
        oldWidget.refreshCount != widget.refreshCount) {
      _disposeController();
      _initialized = false;
      _initWith(widget.videoPath);
    }
  }

  Future<void> _initWith(String path) async {
    try {
      final isNetwork = path.startsWith('http');
      final controller = isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(path))
          : VideoPlayerController.file(File(path));

      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _initialized = true;
      });
    } catch (e) {
      // Optional: log or show a fallback UI
      debugPrint('Video init failed: $e');
      if (mounted) {
        setState(() {
          _initialized = false;
        });
      }
    }
  }

  void _disposeController() {
    try {
      _controller?.pause();
      _controller?.dispose();
    } catch (_) {}
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return SizedBox(
    width: 35,
    height: 45,
    child: GestureDetector(
      onTap: widget.onEditVideo,
      child: ClipOval(
        child: _initialized && _controller != null
            ? VideoPlayer(_controller!)
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
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

    logger.d("videoPath : ${widget.videoPath}");

    if (widget.videoPath.startsWith('http')) {
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
    }).catchError((e) => debugPrint("Video init error: $e"));
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
          border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
        ),
        child: _initialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    );
  }
}

/// =====================
/// FaceReactionSlider
/// Start → 3,2,1 → loader → show still (draggable) → SLIDE (no check) → 3,2,1 → recording → video preview
/// =====================

enum _ReactionStage {
  idleStart,
  countingStill,
  stillLoading,
  stillReady,
  countingVideo,
  recording,
  videoReady,
}

class FaceReactionSlider extends StatefulWidget {
  const FaceReactionSlider({
    super.key,
    this.width = 150,
    this.height = 50,
    this.axis = Axis.horizontal,
    this.textIdle = 'Start',
    this.textAfterImage = 'Video',
    this.textRecording = 'Rec',
    this.backgroundColor = const Color(0x66000000),
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.red, Colors.purple],
    ),
    this.labelTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),

    /// Hooks
    this.onStartPressed,
    this.onStillCountdownFinished,
    this.onVideoCountdownFinished,

    /// Optional custom knob content for stages:
    /// - shown when _stage == stillReady
    this.stillReadyKnobChild,
    /// - shown when _stage == videoReady
    this.videoReadyKnobChild,
  });

  final double width;
  final double height;

  /// Layout direction
  final Axis axis;

  /// Track labels
  final String textIdle;
  final String textAfterImage;
  final String textRecording;

  /// Track visuals
  final Color backgroundColor;
  final LinearGradient gradient;
  final TextStyle labelTextStyle;

  /// Callbacks
  final Future<void> Function()? onStartPressed;
  final Future<void> Function()? onStillCountdownFinished;
  final Future<void> Function()? onVideoCountdownFinished;

  /// Optional custom knob children for specific stages
  final Widget? stillReadyKnobChild;
  final Widget? videoReadyKnobChild;

  @override
  State<FaceReactionSlider> createState() => _FaceReactionSliderState();
}

class _FaceReactionSliderState extends State<FaceReactionSlider> {

  final GlobalKey _sliderKey = GlobalKey();
  int _sliderNonce = 0;

  _ReactionStage _stage = _ReactionStage.idleStart;
  int _count = 3;
  Timer? _timer;

  String get _trackText {
    switch (_stage) {
      case _ReactionStage.idleStart:
      case _ReactionStage.countingStill:
      case _ReactionStage.stillLoading:
        return widget.textIdle;
      case _ReactionStage.stillReady:
      case _ReactionStage.countingVideo:
        return widget.textAfterImage;
      case _ReactionStage.recording:
        return widget.textRecording;
      case _ReactionStage.videoReady:
        return 'REC';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _runCountdown({
    required void Function() onTickEndSetStage,
    required Future<void> Function()? afterCountdownWork,
  }) async {
    setState(() => _count = 3);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) return;
      if (_count <= 1) {
        t.cancel();
        onTickEndSetStage();
        if (afterCountdownWork != null) {
          await afterCountdownWork();
        }
        return;
      }
      setState(() => _count -= 1);
    });
  }

  Future<void> _startStillCountdown() async {
    // optional hook when user first engages
    await widget.onStartPressed?.call();

    setState(() => _stage = _ReactionStage.countingStill);
    await _runCountdown(
      onTickEndSetStage: () => setState(() => _stage = _ReactionStage.stillLoading),
      afterCountdownWork: () async {
        await widget.onStillCountdownFinished?.call(); // capture still here
        if (!mounted) return;
        setState(() => _stage = _ReactionStage.stillReady);
      },
    );
  }

  Future<void> _startSecondCountdownAndRecord() async {
    
    setState(() => _stage = _ReactionStage.countingVideo);
    await _runCountdown(
      onTickEndSetStage: () => setState(() => _stage = _ReactionStage.recording),
      afterCountdownWork: () async {
        await widget.onVideoCountdownFinished?.call(); // do recording
        if (!mounted) return;
        setState(() => _stage = _ReactionStage.videoReady);
      },
    );
  }

  void _resetSlider() {
    final st = _sliderKey.currentState;
    try {
      // ignore: invalid_use_of_protected_member
      (st as dynamic).reset?.call();
    } catch (_) {
      // if the lib blocks access, force rebuild
      setState(() => _sliderNonce++);
    }
  }

  Widget _buildRecIndicator(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.3, end: 1.0),
                curve: Curves.easeInOut,
                builder: (_, value, __) => Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(value),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'REC',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKnob() {

    logger.d("_stage : $_stage");

    final knobSize = widget.height - 4.0;

    Widget content;
    switch (_stage) {
      case _ReactionStage.idleStart:
        // NOTE: no onTap here; sliding is what triggers the flow
        content = Material(
          color: Colors.white.withOpacity(0.5),
          shape: const CircleBorder(),
          child: SizedBox(
            width: knobSize,
            height: knobSize,
            child: const Center(
              child: Text(
                'Start',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 10),
              ),
            ),
          ),
        );
        break;

      case _ReactionStage.countingStill:
      case _ReactionStage.countingVideo:
        content = Container(
          width: knobSize,
          height: knobSize,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
          alignment: Alignment.center,
          child: Text(
            '$_count',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        );
        break;

      case _ReactionStage.stillLoading:
        content = Container(
          width: knobSize,
          height: knobSize,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
        );
        break;

      case _ReactionStage.stillReady:
        content = widget.stillReadyKnobChild ??
            const Icon(Icons.tag_faces, size: 22, color: Colors.white);
        break;

      case _ReactionStage.recording:
        content = _buildRecIndicator(knobSize);
        break;

      case _ReactionStage.videoReady:
        content = widget.videoReadyKnobChild ??
            const Icon(Icons.play_circle_fill, size: 22, color: Colors.white);
        break;
    }

    return KeyedSubtree( // let AnimatedSwitcher see stage changes
      key: ValueKey(_stage),
      child: ClipOval(
        child: SizedBox(
          width: knobSize,
          height: knobSize,
          // Only fit for non-video custom content if needed
          child: content,
        ),
      ),
    );
  }

  /// We start the flows on SLIDE COMPLETE, not on tapping "Start"
  Future<void> _handleSubmit() async {
    // Instantly reset the 3rd-party slider's success state so its check icon never shows
    _resetSlider();
    await Future.microtask(() {}); // let it rebuild one frame

    if (_stage == _ReactionStage.idleStart) {
      // First slide => still countdown/capture
      await _startStillCountdown();
      return;
    }

    if (_stage == _ReactionStage.stillReady) {
      // Second slide => video countdown/record
      await _startSecondCountdownAndRecord();
      return;
    }

    // Otherwise: ignore/bounce back
  }

  @override
  Widget build(BuildContext context) {
    // Build the original (horizontal) slider stack
    Widget core = Stack(
      alignment: Alignment.center,
      children: [
        // Hide the package's green "check" icon by making default icon color transparent
        Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.transparent),
          ),
          child: KeyedSubtree(
            key: ValueKey(_sliderNonce),
            
            child: _GradientSlideToAct(
              key: _sliderKey,
              width: widget.width,
              height: widget.height,
              backgroundColor: widget.backgroundColor,
              gradient: widget.gradient,
              onSubmit: _handleSubmit,
              draggable: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                // keep the knob upright when we rotate the whole slider to vertical
                child: widget.axis == Axis.vertical
                    ? RotatedBox(quarterTurns: 1, child: _buildKnob())
                    : _buildKnob(),
              ),
            ),
          ),
        ),

        // Track label (horizontal by default).
        // When the whole slider is rotated to vertical, this text turns vertical too.
        Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _trackText,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.labelTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // If vertical, rotate the whole slider -90° and swap the outer box sizes
    if (widget.axis == Axis.vertical) {
      core = SizedBox(
        width: widget.height, // thickness becomes on-screen width
        height: widget.width, // long dimension becomes on-screen height
        child: RotatedBox(quarterTurns: 3, child: core), // rotate whole control
      );
    }

    return core;
  }
}

///
/// A tiny wrapper around the third-party slider so we can keep this file self-contained.
/// Replace this with your package widget, for example `GradientSlideToAct` from
/// `gradient_slide_to_act`, wiring the same props.
///
class _GradientSlideToAct extends StatelessWidget {
  const _GradientSlideToAct({
    super.key,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.gradient,
    required this.onSubmit,
    required this.draggable,
  });

  final double width;
  final double height;
  final Color backgroundColor;
  final LinearGradient gradient;
  final Future<void> Function() onSubmit;
  final Widget draggable;

  @override
  Widget build(BuildContext context) {
    // ↓↓↓ Replace this Container with your real `GradientSlideToAct` usage ↓↓↓
    // I mimic the look (background + gradient) and accept the same callbacks.
    return GestureDetector(
      onHorizontalDragEnd: (_) async => await onSubmit(),
      onVerticalDragEnd: (_) async => await onSubmit(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            // The "draggable" knob sits on the leading side visually
            SizedBox(width: height - 4, height: height - 4, child: draggable),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}


class _KnobVideoPreview extends ViewModelWidget<StoryProvider> {
  final double size;
  const _KnobVideoPreview({super.key, required this.size});

  @override
  Widget build(BuildContext context, StoryProvider vm) {
    final path = vm.videoPath;
    if (path == null || path.isEmpty) {
      return const Center(
        child: SizedBox(width: 18, height: 18,
          child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return _TinyVideo(path: path, size: size, refresh: vm.refreshCount);
  }
}

class _TinyVideo extends StatefulWidget {
  final String path;
  final double size;
  final int refresh;
  const _TinyVideo({super.key, required this.path, required this.size, required this.refresh});

  @override
  State<_TinyVideo> createState() => _TinyVideoState();
}

class _TinyVideoState extends State<_TinyVideo> {
  VideoPlayerController? _c;

  @override
  void initState() { super.initState(); _init(); }

  @override
  void didUpdateWidget(covariant _TinyVideo old) {
    super.didUpdateWidget(old);
    if (old.path != widget.path || old.refresh != widget.refresh) {
      _disposeC(); _init();
    }
  }

  Future<void> _init() async {
    final isNet = widget.path.startsWith('http');
    final c = isNet
        ? VideoPlayerController.networkUrl(Uri.parse(widget.path))
        : VideoPlayerController.file(File(widget.path));
    await c.initialize();
    await c.setLooping(true);
    await c.play();
    if (!mounted) { await c.dispose(); return; }
    setState(() => _c = c);
  }

  void _disposeC() { try { _c?.dispose(); } catch (_) {} _c = null; }

  @override
  void dispose() { _disposeC(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _c == null
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : VideoPlayer(_c!),
    );
  }
}


class MiniCountdownTimer extends StatefulWidget {
  const MiniCountdownTimer({
    super.key,
    this.size = 64,                // <- small size
    this.duration = 3,             // <- 3,2,1
    this.autoStart = true,
    this.onStart,
    this.onChange,
    this.onComplete,
  });

  final double size;
  final int duration;
  final bool autoStart;
  final VoidCallback? onStart;
  final void Function(String timeStamp)? onChange;
  final VoidCallback? onComplete;

  @override
  State<MiniCountdownTimer> createState() => _MiniCountdownTimerState();
}

class _MiniCountdownTimerState extends State<MiniCountdownTimer> {
  final CountDownController _controller = CountDownController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularCountDownTimer(
        duration: widget.duration,
        initialDuration: 0,
        controller: _controller,

        // Small circle
        width: widget.size,
        height: widget.size,

        // Visuals (no page background — only the ring)
        ringColor: Colors.white24,
        ringGradient: null,
        fillColor: Colors.pink,
        fillGradient: null,
        backgroundColor: Colors.transparent,   // <- transparent behind the ring
        backgroundGradient: null,
        strokeWidth: 4,
        strokeCap: StrokeCap.round,

        // Text in the center
        textStyle: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        textFormat: CountdownTextFormat.S,

        // Count down (3 -> 2 -> 1 -> 0)
        isReverse: true,
        isReverseAnimation: true,
        isTimerTextShown: true,
        autoStart: widget.autoStart,

        // Optional: hide "0" at the very end (shows blank instead of 0)
        timeFormatterFunction: (defaultFormatterFunction, duration) {
        
          return Function.apply(defaultFormatterFunction, [duration]);
        },

        onStart: () => widget.onStart?.call(),
        onChange: (ts) => widget.onChange?.call(ts),
        onComplete: () => widget.onComplete?.call(),
      ),
    );
  }
}

class _Counting extends StatefulWidget {
  const _Counting({
    super.key,
    required this.isVideo,
    required this.onStartVideo,
    required this.onStartImage,
    required this.onComplete,
    this.size = 40,      // optional: visual size of the circle
    this.startFrom = 3,  // optional: start number (defaults to 3)
  });

  final bool isVideo;
  final Future<void> Function() onStartVideo;
  final Future<void> Function() onStartImage;
  final VoidCallback onComplete;

  final double size;
  final int startFrom;

  @override
  State<_Counting> createState() => _CountingState();
}

class _CountingState extends State<_Counting> {
  late int _left;              // 3 -> 2 -> 1
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _left = widget.startFrom <= 0 ? 1 : widget.startFrom;

    // Tick every 1 second to show 3,2,1.
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (_left > 1) {
        setState(() => _left--); // 3->2, 2->1
        return;
      }

      // _left == 1 just finished its full second on screen.
      t.cancel();

      // Start the capture AFTER the countdown.
      // Fire-and-forget so UI can swap immediately.
      unawaited(_startCapture());

      // Let the final "1" paint, then notify completion.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onComplete();
      });
    });
  }

  Future<void> _startCapture() async {
    try {
      if (widget.isVideo) {
        await widget.onStartVideo();
      } else {
        await widget.onStartImage();
      }
    } catch (_) {
      // swallow errors; the caller can show a fallback if needed
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Center(
          child: Text(
            '$_left',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

// Tiny helper to silence "unawaited" lint; or use package:pedantic if you have it.
void unawaited(Future<void> future) {}

/// The “ready” content (video/face preview inside the ring).
class _ReadyPreview extends StatelessWidget {
  const _ReadyPreview({
    super.key,
    required this.isVideo,
    required this.videoPath,
    required this.hasFace,
  });

  final bool isVideo;
  final String? videoPath;
  final bool hasFace;

  @override
  Widget build(BuildContext context) {
    if (isVideo) {
      return SizedBox(
        width: 35,
        height: 45,
        child: _SliderSpotPreview(
          key: const ValueKey('preview-video'),
          width: 35,
          height: 45,
          child: (videoPath != null)
              ? const CommentFaceVideoModalView(marginBottom: 0)
              : const Center(child: Loader(size: 40.0)),
        ),
      );
    }

    return SizedBox(
      width: 35,
      height: 45,
      child: _SliderSpotPreview(
        key: const ValueKey('preview-face'),
        width: 35,
        height: 45,
        child: hasFace
            ? const CommentFaceModalView(marginBottom: 0)
            : const Center(child: Loader(size: 40.0)),
      ),
    );
  }
}