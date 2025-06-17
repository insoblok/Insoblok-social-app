import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryContentProvider extends InSoBlokViewModel {
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

  var textController = TextEditingController();

  late QuillController quillController;
  var quillScrollController = ScrollController();
  var focusNode = FocusNode();

  final _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final _userService = UserService();

  void init(BuildContext context, {required StoryModel model}) async {
    this.context = context;
    story = model;

    if (story.category != null && story.category == 'vote') {
      actionType('vote');
    } else {
      actionType('comment');
    }

    quillController = () {
      return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
        ),
      );
    }();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 300), () {
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }
    });
    owner = await _userService.getUser(story.id!);

    notifyListeners();
  }

  @override
  void dispose() {
    quillController.dispose();
    scrollController.dispose();
    quillScrollController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  UserModel? _owner;
  UserModel? get owner => _owner;
  set owner(UserModel? model) {
    _owner = model;
    notifyListeners();
  }

  bool get isMine => owner?.id == AuthHelper.user?.id;

  bool _isLiking = false;
  bool get isLiking => _isLiking;
  set isLiking(bool f) {
    _isLiking = f;
    notifyListeners();
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

  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;
  set isFollowing(bool f) {
    _isFollowing = f;
    notifyListeners();
  }

  bool _isVote = false;
  bool get isVote => _isVote;
  set isVote(bool f) {
    _isVote = f;
    notifyListeners();
  }

  bool _isComment = false;
  bool get isComment => _isComment;
  set isComment(bool f) {
    _isComment = f;
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
        AIHelpers.showToast(msg: 'Yay!');
      } else {
        AIHelpers.showToast(msg: 'Nay!');
      }
      notifyListeners();
    }
  }

  void actionType(String actionType) {
    if (actionType == 'vote') {
      _isVote = true;
      _isComment = false;
    } else {
      _isVote = false;
      _isComment = true;
    }
    notifyListeners();
  }

  Future<void> addComment() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var desc = await AIHelpers.goToDescriptionView(context);
        logger.d(desc);
        if (desc != null) {
          var comment = StoryCommentModel(
            userId: user?.id,
            content: desc,
            timestamp: DateTime.now(),
          );
          final comments = List<StoryCommentModel>.from(story.comments ?? []);
          comments.add(comment);

          story = story.copyWith(
            comments: comments,
            updateDate: DateTime.now(),
          );
          await storyService.addComment(story: story);

          AIHelpers.showToast(msg: 'Successfully add your comment!');
        } else {
          setError('Your comment is empty!');
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

  String? _commentContent;
  String? get commentContent => _commentContent;
  set commentContent(String? s) {
    _commentContent = s;
    notifyListeners();
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
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

  Future<void> onClickRepost() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();

        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
          if (description == null) {
            throw ('empty description!');
          }
        }
        var newStory = StoryModel(
          title: 'Repost',
          text: description,
          category: 'vote',
          medias: story.medias,
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

        Navigator.of(context).pop(true);
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

  Future<void> onClickSaveToLookBook() async {
    if (isBusy) return;
    clearErrors();
    if (story.status != null && story.status == 'public') {
      AIHelpers.showToast(msg: 'This post saved to LOOKBOOK already!');
      return;
    }

    await runBusyFuture(() async {
      try {
        story = story.copyWith(status: 'public', updateDate: DateTime.now());
        await storyService.updateStory(story: story);
      } catch (e) {
        setError(e);
        logger.e(e);
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      AIHelpers.showToast(msg: 'You saved this post to LOOKBOOK');
      notifyListeners();
    }
  }

  Future<bool?> _showDescriptionDialog() => showDialog<bool>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).primaryColor),
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

  bool alreadyPop = false;

  void popupDialog() {
    if (alreadyPop) return;
    alreadyPop = true;
    Navigator.of(context).pop();
    Future.delayed(const Duration(milliseconds: 1000), () {
      alreadyPop = false;
    });
  }
}
