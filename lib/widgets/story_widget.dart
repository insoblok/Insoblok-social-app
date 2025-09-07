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
          onTap: () => AIHelpers.goToDetailView(
            context,
            medias: (viewModel.story.medias ?? []).map((m) => m.link!).toList(),
            index: viewModel.pageIndex,
            storyID: viewModel.story.id!,
            storyUser: viewModel.story.userId!,
          ),
          child: Stack(
            children: [
              // ======== MEDIA ========
              if ((story.medias ?? []).isNotEmpty)
                PageView.builder(
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
                  const Spacer(flex: 2),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x00000000), Color(0xCF000000)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12.0,
                        children: [
                          const Spacer(),
                          Container(
                            margin: EdgeInsets.only(bottom: marginBottom ?? 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 12.0,
                              children: [
                                if (viewModel.story.category == 'vote') const StoryYayNayWidget(),
                                Row(
                                  spacing: 12.0,
                                  children: [
                                    Text(viewModel.owner?.fullName ?? '---',
                                        style: Theme.of(context).textTheme.headlineMedium),
                                    Text('· ${viewModel.story.timestamp?.timeago}',
                                        style: Theme.of(context).textTheme.headlineMedium),
                                  ],
                                ),
                                if (viewModel.story.category == 'vote')
                                  Column(
                                    children: [
                                      const SizedBox(height: 3.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Vybe Virtual Try-On + progress (${viewModel.story.votes?.length ?? 0} / 5 Looks Today)',
                                            style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                                          ),
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
                    bottom: marginBottom != null ? marginBottom! + 56 : 56,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16.0),
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
                                child: Icon(Icons.add, size: 12, color: AIColors.white),
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
                        onTap: () => viewModel.showCommentDialog(),
                      ),
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icShare,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.4,
                        ),
                        label: '',
                        onTap: () => AIHelpers.shareStory(context, story: story),
                      ),
                      StoryActionButton(
                        src: AIImage(
                          AIImages.icGallery,
                          color: Theme.of(context).colorScheme.secondary,
                          width: kStoryAvatarSize * 0.5,
                        ),
                        onTap: () => viewModel.showReactions(),
                      ),
                    ],
                  ),
                ),
              ),

              // ======== BOTTOM-LEFT: SLIDER ========
              if(viewModel.showFaceDialog)
                Positioned(
                  left: 8.0,
                  bottom: marginBottom != null ? marginBottom! + 140 : 140,
                  child: FaceReactionSlider(
                    width: 90,
                    height: 40,
                    textIdle: 'Video',
                    textAfterImage: 'Video',
                    textRecording: 'Recording…',
                    onStartPressed: () async {
                      // await viewModel.prepareCamera();
                    },
                    onStillCountdownFinished: () async {
                      // show loader while capturing (handled inside slider)
                      // viewModel.showFaceDialog = true;
                      await viewModel.captureReactionImage();
                    },
                    onVideoCountdownFinished: () async {
                      await viewModel.captureReactionVideo();
                    },
                  ),
                ),

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
        fit: ((widget.media.height ?? 1) / (widget.media.width ?? 1) > 1.2) ? BoxFit.cover : BoxFit.contain,
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
            onTap: () => viewModel.updateVote(false),
            text: viewModel.story.cntNay == 0 ? 'Hot' : 'Hot (${viewModel.story.cntNay})',
            textColor: AIColors.pink,
            src: AIImages.icNot,
            imgSize: 35,
            backgroundColor: viewModel.story.isVote() == false ? AIColors.pink.withAlpha(64) : AIColors.transparent,
            borderColor: AIColors.pink,
          ),
        ),
        const SizedBox(width: 30),
        IntrinsicWidth(
          child: VoteFloatingButton(
            onTap: () => viewModel.updateVote(true),
            text: viewModel.story.cntYay == 0 ? 'Not' : 'Not (${viewModel.story.cntYay})',
            textColor: AIColors.lightBlue,
            src: AIImages.icHot,
            imgSize: 35,
            backgroundColor: viewModel.story.isVote() == true ? AIColors.green.withAlpha(64) : Colors.transparent,
            borderColor: AIColors.lightBlue,
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
    this.period = const Duration(milliseconds: 800),
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
              width: 48.0,
              height: 48.0,
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

    logger.d("video path: $path");
    if (path == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: marginBottom ?? 0),
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VideoPreviewWidget(
            videoPath: path,
            onRecapture: viewModel.captureReactionVideo,
            onEditVideo: viewModel.onEditReactionVideoPressed,
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

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: ClipOval(
        child: _initialized
            ? VideoPlayer(_controller)
            : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
    this.textIdle = 'Start',
    this.textAfterImage = 'Video',
    this.textRecording = 'Recording…',
    this.onStartPressed,
    this.onStillCountdownFinished,
    this.onVideoCountdownFinished,
  });

  final double width;
  final double height;
  final String textIdle;
  final String textAfterImage;
  final String textRecording;

  final Future<void> Function()? onStartPressed;
  final Future<void> Function()? onStillCountdownFinished;
  final Future<void> Function()? onVideoCountdownFinished;

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
        return 'Preview ready';
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

  Future<void> _startFirstCountdown() async {
    if (widget.onStartPressed != null) {
      await widget.onStartPressed!();
    }
    setState(() => _stage = _ReactionStage.countingStill);
    await _runCountdown(
      onTickEndSetStage: () => setState(() => _stage = _ReactionStage.stillLoading),
      afterCountdownWork: () async {
        if (widget.onStillCountdownFinished != null) {
          await widget.onStillCountdownFinished!(); // capture still
        }
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
        if (widget.onVideoCountdownFinished != null) {
          await widget.onVideoCountdownFinished!(); // do recording
        }
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
                  decoration: BoxDecoration(color: Colors.red.withOpacity(value), shape: BoxShape.circle),
                ),
              ),
              const SizedBox(width: 6),
              const Text('REC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
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
        content = Material(
          color: Colors.pink,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: _startFirstCountdown,
            child: SizedBox(
              width: knobSize,
              height: knobSize,
              child: const Center(
                child: Text('Start', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        );
        break;

      case _ReactionStage.stillLoading:
        content = Container(
          width: knobSize,
          height: knobSize,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
          alignment: Alignment.center,
          child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
        );
        break;

      case _ReactionStage.stillReady:
        content = const CommentFaceModalView(marginBottom: 0);
        break;

      case _ReactionStage.recording:
        content = _buildRecIndicator(knobSize);
        break;

      case _ReactionStage.videoReady:
        logger.d("CommentFaceVideoModalView123");

        content = const CommentFaceVideoModalView(marginBottom: 0);
        break;
    }

    return ClipOval(
      child: SizedBox(
        width: knobSize,
        height: knobSize,
        child: FittedBox(fit: BoxFit.cover, child: content),
      ),
    );
  }

  Future<void> _handleSubmit() async {

    _stage = _ReactionStage.stillReady;
    // Only when still is visible do we accept the slide
    if (_stage != _ReactionStage.stillReady) {
      _resetSlider(); // bounce back, no check
      return;
    }

    // Hide the package's success state right away
    _resetSlider();
    // give the reset one frame
    await Future.microtask(() {});

    await _startSecondCountdownAndRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /*
        GradientSlideToAct(
          key: _sliderKey,
          width: widget.width,
          height: widget.height,
          text: '', // <- leave empty so we can draw our own label
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: Colors.purple,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red, Colors.purple],
          ),
          draggableWidget: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _buildKnob(),
          ),
          onSubmit: _handleSubmit,
        ),
        */
        // right-aligned label
        Positioned.fill(
          child: IgnorePointer( // so drags still work
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _trackText,                  // your label (textIdle/textAfterImage/…)
                  textAlign: TextAlign.right,  // <- alignment lives here
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
