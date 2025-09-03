import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:insoblok/utils/background_camera_capture.dart';
import 'package:insoblok/utils/background_camera_video_capture.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class StoryProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late StoryModel _story;
  StoryModel get story => _story;
  set story(StoryModel model) {
    _story = model;
    notifyListeners();
  }

  bool _isComment = false;
  bool get isComment => _isComment;
  set isComment(bool f) {
    _isComment = f;
    notifyListeners();
  }

  bool _isVideoReaction = false;
  bool get isVideoReaction => _isVideoReaction;
  set isVideoReaction(bool f) {
    _isVideoReaction = f;
    notifyListeners();
  }

  String? _videoPath;
  String? get videoPath => _videoPath;
  set videoPath(String? f) {
    _videoPath = f;
    notifyListeners();
  }

  String? _videoStoryPath;
  String? get videoStoryPath => _videoStoryPath;
  set videoStoryPath(String? f) {
    _videoStoryPath = f;
    notifyListeners();
  }

  File? _face;
  File? get face => _face;
  set face(File? f) {
    _face = f;
    notifyListeners();
  }

  bool _showFaceDialog = true;
  bool get showFaceDialog => _showFaceDialog;
  set showFaceDialog(bool f) {
    _showFaceDialog = f;
    notifyListeners();
  }

  String? _faceStatus;
  String? get faceStatus => _faceStatus;
  set faceStatus(String? s) {
    _faceStatus = s;
    notifyListeners();
  }

  String? _resultFaceUrl;
  String? get resultFaceUrl => _resultFaceUrl;
  set resultFaceUrl(String? s) {
    _resultFaceUrl = s;
    notifyListeners();
  }

  late QuillController? quillController;
  var quillScrollController = ScrollController();
  var focusNode = FocusNode();

  final camera = BackgroundCameraCapture(
    maxCaptures: 3,              // exactly 3 captures
    stopStreamOnMax: true, 
  );
  final videoCapture = BackgroundCameraVideoCapture();
  late int refreshCount = 0;

  Timer? capture_timer;

  final globals = GlobalStore();
  bool get vybeCamEnabled => globals.isVybeCamEnabled;

  void init(BuildContext context, {required StoryModel model}) async {
    this.context = context;
    story = model;

    logger.d("id of story: $story");

    refreshCount = 0;
    _videoPath = null;

    final mediaPath = story.medias?[0].link;
    if (mediaPath!.contains('.mov') || mediaPath.contains('.mp4')) {
      _videoStoryPath = story.medias?[0].link;
    } else {
      _videoStoryPath = null;
    }

    final auth = AuthHelper.user?.id;

    if((auth == story.userId)){

      logger.d("resumeCapturing");
      camera.resumeCapturing();
    }

    if(vybeCamEnabled && (auth != story.userId)){
      showFaceDialog = true;

      camera.onFrame = (String? path) {
        logger.d("Trying to detect user expressions");
        if (path != null) {
          detectFace(path);
        }
      };

      await camera.initialize();
    }

    quillController = () {
        return QuillController.basic(
          config: QuillControllerConfig(
            clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
          ),
        );
      }();
    fetchUser();
  }

  Future<void> captureReactionImage() async {
    _isVideoReaction = false;
    showFaceDialog = true;

    final hadVideoPreview = _videoPath != null;
    if (hadVideoPreview) {
      _videoPath = null;
      refreshCount++; 
      notifyListeners();

      // Allow a frame to pass so Flutter disposes the video widget & decoder
      try {
        await WidgetsBinding.instance.endOfFrame;
      } catch (_) {}
      await Future.delayed(const Duration(milliseconds: 120));
    }

    // 1) Ensure the video recorder controller is released
    await videoCapture.stopAndDispose();

    // 2) Re-grab camera for image stream
    if (!camera.isInitialized) {
      await camera.initialize();
    } else if (!camera.isStreaming) {
      await camera.restartStream();
    }

    // 3) Resume throttled frame processing
    camera.resumeCapturing();
  }

  /// Switch to VIDEO capture mode
  Future<void> captureReactionVideo() async {
    _isVideoReaction = true;
    showFaceDialog = true;

    // 1) Release the image stream completely to avoid buffer/ownership conflicts
    await camera.stopAndDispose();

    // 2) Record short clip
    videoCapture.onVideoRecorded = (String path) {
      refreshCount++;
      scheduleMicrotask(() {
        videoPath = path;
      });
    };

    await videoCapture.initialize();
    await videoCapture.recordShortVideo(seconds: 2.0);

    // 3) Optionally release video controller now; we keep preview in UI via file.
    await videoCapture.stopAndDispose();
  }

  List<AIFaceAnnotation> annotations = [];

  Future<void> detectFace(String link) async {

    link = '/data/data/insoblok.social.app/cache/SnapImage.jpg';

    var faces = await GoogleVisionHelper.getFacesFromImage(link: link);
    var _annotations = await GoogleVisionHelper.analyzeLocalImage(link: link);

    if (faces.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/face.png';

      final file = File(filePath);

      try {
        if (await file.exists()) {
          await file.delete();
        }

        final encoded = img.encodePng(faces[0]);
        _face = await file.writeAsBytes(encoded, flush: true);
        await FileImage(_face!).evict();

        annotations.clear();
        annotations.addAll(_annotations);

        logger.d('✅ face.png replaced at $filePath');
      } catch (e) {
        logger.e('❌ Failed to write new face.png: $e');
        AIHelpers.showToast(msg: 'Failed to write new reaction image');
      }

      notifyListeners();
    } else {
      logger.e("No face detected!");
      AIHelpers.showToast(msg: 'No face detected!');
    }
  }

  @override
  void dispose() {
    quillController?.dispose();
    quillScrollController.dispose();
    focusNode.dispose();

    // Fire-and-forget disposals
    camera.dispose();
    videoCapture.dispose();

    super.dispose();
  }

  Future<void> fetchStory() async {
    try {
      story = await storyService.getStory(story.id!);
    } catch (e, s) {
      logger.e(e);
      logger.e(s);
    } finally {
      notifyListeners();
    }
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? model) {
    _owner = model;
    notifyListeners();
  }

  Offset _dragStart = const Offset(0, 0);
  Offset get dragStart => _dragStart;
  set dragStart(Offset o) {
    _dragStart = o;
    notifyListeners();
  }

  bool openCommentDialog = false;

  Future<void> setVideoReaction() async {
    await captureReactionVideo();
  }

  Future<void> setImageReaction() async {
    await captureReactionImage();
  }

  Future<void> showCommentDialog() async {
    if (openCommentDialog) return;

    openCommentDialog = true;
    showFaceDialog = false;
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppSettingHelper.background,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => StoryCommentDialog(story: story),
      ),
    );

    openCommentDialog = false;
    fetchStory();
  }

  Future<void> onPostReactionPressed() async {
    Routers.goToFaceDetailPage(
        context,
        story.id!,
        (story.medias ?? [])[pageIndex].link!,
        face!,
        annotations,
        false);
  }

  Future<void> onPostReactionVideoPressed() async {
    Routers.goToReactionVideoDetailPage(
        context,
        story.id!,
        (story.medias ?? [])[pageIndex].link!,
        videoPath!,
        false);
  }

  Future<void> onEditReactionVideoPressed() async {
    Routers.goToReactionVideoDetailPage(
        context,
        story.id!,
        (story.medias ?? [])[pageIndex].link!,
        videoPath!,
        false);
  }

  Future<void> onPostDeclinePressed() async {
    showFaceDialog = false;
  }

  Future<void> fetchUser() async {
    try {
      owner = await userService.getUser(story.userId!);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  Future<void> goToDetailPage() async {
    await updateView();
    var data = await Routers.goToStoryDetailPage(context, story);
    if (data != null) {
      story = data;
      notifyListeners();
    }
  }

  Future<void> goToLookbookDetailPage() async {
    await updateView();

    var data = await Routers.goToLookbookDetailPage(context, story);
    if (data != null) {
      story = data;
      notifyListeners();
    }
  }

  Future<void> onTapUserAvatar() async {
    Routers.goToAccountPage(context, user: owner);
  }

  bool _isVote = false;
  bool get isVote => _isVote;
  set isVote(bool f) {
    _isVote = f;
    notifyListeners();
  }

  Future<void> updateVote(bool isVote) async {
    if (isBusy) return;
    clearErrors();

    if (story.userId == user?.id) {
      AIHelpers.showToast(msg: 'You can\'t vote to your feed!');
      return;
    }
    var votes = List<StoryVoteModel>.from(story.votes ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isVote() == null) {
          votes.add(
            StoryVoteModel(
              userId: user?.id,
              vote: isVote,
              timestamp: DateTime.now(),
            ),
          );
        } else {
          for (var i = 0; i < votes.length; i++) {
            var vote = votes[i];
            if (vote.userId == user?.id) {
              votes[i] = StoryVoteModel(
                userId: user?.id,
                vote: isVote,
                timestamp: DateTime.now(),
              );
            }
          }
        }
        await storyService.updateVoteStory(
          story: story.copyWith(votes: votes, updateDate: DateTime.now()),
          user: owner,
          isVote: isVote,
        );

        if (isVote) {
          tastScoreService.voteScore(story);
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {}
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
      notifyListeners();
    } else {
      story = story.copyWith(votes: votes);
      if (story.isVote() != null && story.isVote() == true) {
        AIHelpers.showToast(msg: 'Vote Yes. Earn +1 TasteScore');
      } else {
        AIHelpers.showToast(msg: 'Vote No. Feedback stays private');
      }
      notifyListeners();
    }
  }

  bool _isLiking = false;
  bool get isLiking => _isLiking;
  set isLiking(bool f) {
    _isLiking = f;
    notifyListeners();
  }

  Future<void> updateLike() async {
    if (isBusy) return;
    clearErrors();

    if (story.userId == user?.id) {
      AIHelpers.showToast(msg: 'You can\'t like to your feed!');
      return;
    }

    isLiking = true;
    var likes = List<String>.from(story.likes ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isLike()) {
          likes.remove(user!.id);
        } else {
          likes.add(user!.id!);
        }
        await storyService.updateLikeStory(
          story: story.copyWith(likes: likes, updateDate: DateTime.now()),
          user: owner,
        );
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isLiking = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      story = story.copyWith(likes: likes);
      if (story.isLike()) {
        AIHelpers.showToast(msg: 'You liked to a feed!');
      } else {
        AIHelpers.showToast(msg: 'You unliked to a feed!');
      }
      notifyListeners();
    }
  }

  Future<void> updateView() async {
    if (story.userId == user?.id || story.isView()) {
      return;
    }
    var views = List<String>.from(story.views ?? []);
    try {
      views.add(user!.id!);
      await storyService.updateStory(story: story.copyWith(views: views));
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      story = story.copyWith(views: views);
      notifyListeners();
    }
  }

  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;
  set isFollowing(bool f) {
    _isFollowing = f;
    notifyListeners();
  }

  Future<void> updateFollow() async {
    if (isBusy) return;
    clearErrors();

    if (story.userId == user?.id) {
      AIHelpers.showToast(msg: 'You can\'t follow to your feed!');
      return;
    }

    isFollowing = true;
    var follows = List<String>.from(story.follows ?? []);
    await runBusyFuture(() async {
      try {
        if (story.isFollow()) {
          follows.remove(user!.id);
        } else {
          follows.add(user!.id!);
        }
        await storyService.updateFollowStory(
          story: story.copyWith(follows: follows, updateDate: DateTime.now()),
          user: owner,
        );
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isFollowing = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      story = story.copyWith(follows: follows);
      if (story.isFollow()) {
        AIHelpers.showToast(msg: 'You followed to a feed!');
      } else {
        AIHelpers.showToast(msg: 'You unfollowed to a feed!');
      }
      notifyListeners();
    }
  }

  Future<void> showReactions() async {
    Routers.goToReactionPage(context, story);
  }

  Future<void> repost() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();
        logger.d("hasDescription: $hasDescription");

        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
          if (description == null) {
            description = "";
            throw ('empty description!');
          }

          var newStory = StoryModel(
            title: 'Repost',
            text: description,
            status: 'private',
            category: 'vote',
            medias: ((resultFaceUrl?.isNotEmpty ?? false) && showFaceDialog)
                ? [
                    MediaStoryModel(
                      link: resultFaceUrl,
                      type: 'image',
                      width: (story.medias ?? [])[pageIndex].width,
                      height: (story.medias ?? [])[pageIndex].height,
                    ),
                  ]
                : story.medias,
            updateDate: DateTime.now(),
            timestamp: DateTime.now(),
            connects: [
              ...(story.connects ?? []),
              if (!containedConnect())
                ConnectedStoryModel(postId: story.id, userId: story.userId),
            ],
          );

          await storyService.postStory(story: newStory);
          await tastScoreService.repostScore(story);

          AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onProcessFace(Map<String, String> content) async {
    if (isBusy) return;
    clearErrors();

    logger.d(content);

    faceStatus = 'Generating...';

    await runBusyFuture(() async {
      try {
        var media = (story.medias ?? [])[pageIndex];

        var resultUrl = await NetworkUtil.getVTOEditImage(
          model: media.link!,
          prompt: content['name']!,
        );

        if (resultUrl == null) throw ('AI service error!');

        resultFaceUrl = await storyService.uploadResult(
          resultUrl,
          folderName: 'face',
        );
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  bool containedConnect() {
    var connects = story.connects ?? [];
    for (var connect in connects) {
      if (connect.postId == story.id && connect.userId == story.userId) {
        return true;
      }
    }
    return false;
  }

  Future<bool?> _showDescriptionDialog() => showDialog<bool>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Repost Story',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Do you want to repost this story to your LOOKBOOK post?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24.0),
              Row(
                spacing: 24.0,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Skip',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context).primaryColor),
                        ),
                      ),
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
