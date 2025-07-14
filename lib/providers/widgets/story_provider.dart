import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

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

  late QuillController quillController;
  var quillScrollController = ScrollController();
  var focusNode = FocusNode();

  void init(BuildContext context, {required StoryModel model}) async {
    this.context = context;
    story = model;

    quillController = () {
      return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
        ),
      );
    }();

    fetchUser();
  }

  @override
  void dispose() {
    quillController.dispose();
    quillScrollController.dispose();
    focusNode.dispose();

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

  Offset _dragStart = Offset(0, 0);
  Offset get dragStart => _dragStart;
  set dragStart(Offset o) {
    _dragStart = o;
    notifyListeners();
  }

  bool openDialog = false;

  Future<void> showDetailDialog() async {
    if (openDialog) return;
    openDialog = true;

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
        return StoryDetailDialog(story: story);
      },
    );
    openDialog = false;
    fetchStory();
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
    var data = await Routers.goToStoryDetailPage(context, story);
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

  Future<void> sendComment() async {
    if (isBusy) return;
    clearErrors();
    await runBusyFuture(() async {
      try {
        var quillData = quillController.document.toDelta().toJson();
        logger.d(quillController.document);
        logger.d(quillData);
        if (quillData.isNotEmpty) {
          var converter = QuillDeltaToHtmlConverter(
            quillData,
            ConverterOptions.forEmail(),
          );
          var comment = StoryCommentModel(
            userId: user?.id,
            content: converter.convert(),
            timestamp: DateTime.now(),
          );
          var comments = List<StoryCommentModel>.from(story.comments ?? []);

          comments.add(comment);
          story = story.copyWith(
            comments: comments,
            updateDate: DateTime.now(),
          );
          await storyService.addComment(story: story);
          quillController.document = Document();
        } else {
          AIHelpers.showToast(msg: 'Your comment is empty!');
        }
      } catch (e, s) {
        setError(e);
        logger.e(e);
        logger.e(s);
      } finally {
        notifyListeners();
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   if (_scrollController.hasClients) {
        //     _scrollController.animateTo(
        //       _scrollController.position.maxScrollExtent,
        //       duration: Duration(milliseconds: 300),
        //       curve: Curves.easeOut,
        //     );
        //   }
        // });
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
