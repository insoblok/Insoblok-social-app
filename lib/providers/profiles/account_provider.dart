import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  UserModel? _accountUser;
  UserModel? get accountUser => _accountUser;
  set accountUser(UserModel? model) {
    _accountUser = model;
    notifyListeners();
  }

  bool get isMe => accountUser?.id == AuthHelper.user?.id;

  int _pageIndex = 3;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  List<String> _followingList = [];
  List<String> get followingList => _followingList;
  set followingList(List<String> i) {
    _followingList = i;
    notifyListeners();
  }

  bool get isFollowing =>
      (accountUser?.follows ?? []).contains(AuthHelper.user?.id);

  bool get isViewing =>
      (accountUser?.views ?? []).contains(AuthHelper.user?.id);

  void init(BuildContext context, {UserModel? model}) async {
    this.context = context;
    accountUser = model ?? AuthHelper.user;

    await fetchStories();
    await getUserScore();
    await fetchFollowings();
    await getGalleries();
    if (!isMe) await updateViews();
  }

  final List<StoryModel> stories = [];

  void setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  Future<void> fetchStories() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        logger.d(accountUser?.id);
        var s = await storyService.getStoriesById(accountUser!.id!);

        if (s.isNotEmpty) {
          stories.clear();
          stories.addAll(s);
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

  Future<void> fetchFollowings() async {
    try {
      _followingList = await userService.getFollowingUserIds(
        userid: accountUser!.id!,
      );
      logger.d(_followingList);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateFollow() async {
    var follows = List<String>.from(accountUser?.follows ?? []);
    if (isFollowing) {
      follows.remove(AuthHelper.user!.id!);
    } else {
      follows.add(AuthHelper.user!.id!);
    }
    accountUser = accountUser?.copyWith(follows: follows);
    await userService.updateUser(accountUser!);
    notifyListeners();
  }

  Future<void> updateViews() async {
    var views = List<String>.from(accountUser?.views ?? []);
    if (isViewing) {
      return;
    } else {
      views.add(AuthHelper.user!.id!);
    }
    accountUser = accountUser?.copyWith(views: views);
    await userService.updateUser(accountUser!);
    notifyListeners();
  }

  Future<void> updateStoryView(StoryModel story) async {
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

  Future<void> gotoNewChat() async {
    RoomModel? existedRoom;
    try {
      existedRoom = await roomService.getRoomByChatUesr(id: accountUser!.id!);
      if (existedRoom == null) {
        var dialog = await showDialog<bool>(
          context: context,
          builder: (context) {
            return Scaffold(
              backgroundColor: AIColors.transparent,
              body: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  decoration: BoxDecoration(
                    color: AIColors.pink,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Create Room",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AIColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close, color: AIColors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "Are you sure want to chat with the selected user?",
                        style: TextStyle(fontSize: 16.0, color: AIColors.white),
                      ),
                      const SizedBox(height: 24.0),
                      TextFillButton(
                        onTap: () => Navigator.of(context).pop(true),
                        text: 'Create',
                        color: AIColors.pink,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

        if (dialog != true) return;

        var room = RoomModel(
          userId: user?.id,
          userIds: [user?.id, accountUser!.id!],
          content: '${user?.fullName} have created a room',
          updateDate: DateTime.now(),
          timestamp: DateTime.now(),
        );
        await roomService.createRoom(room);
        existedRoom = await roomService.getRoomByChatUesr(id: accountUser!.id!);
        messageService.setInitialTypeStatus(existedRoom!.id!, accountUser!.id!);
      }
    } catch (e) {
      logger.e(e);
      setError(e);
    } finally {
      notifyListeners();
    }

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      if (existedRoom != null) {
        await Routers.goToMessagePage(
          context,
          MessagePageData(room: existedRoom, chatUser: accountUser!),
        );
      }
    }
  }

  Future<void> goToDetailPage(int index) async {
    if (!isMe) updateStoryView(stories[index]);
    Routers.goToPostDetailPage(context, {
      'userid': accountUser?.id,
      'index': index,
    });
  }

  final List<TastescoreModel> _scores = [];
  List<TastescoreModel> get scores => _scores;

  int get totalScore {
    var result = 0;
    for (var score in scores) {
      result += (score.bonus ?? 0);
    }
    return result;
  }

  List<UserLevelModel> get userLevels =>
      AppSettingHelper.appSettingModel?.userLevel ?? [];

  UserLevelModel get userLevel {
    for (var userLevel in userLevels) {
      if ((userLevel.min ?? 0) <= totalScore &&
          totalScore < (userLevel.max ?? 1000000000)) {
        return userLevel;
      }
    }
    return userLevels.first;
  }

  double get indicatorValue {
    var min = userLevel.min ?? 0;
    var max = userLevel.max ?? 0;
    return (totalScore - min) / (max - min);
  }

  bool _isLoadingScore = false;
  bool get isLoadingScore => _isLoadingScore;
  set isLoadingScore(bool f) {
    _isLoadingScore = f;
    notifyListeners();
  }

  Future<void> getUserScore() async {
    _isLoadingScore = true;
    try {
      _scores.clear();
      var s = await tastScoreService.getScoresByUser(accountUser!.id!);
      _scores.addAll(s);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isLoadingScore = false;
    }
  }

  final List<String> _galleries = [];
  List<String> get galleries => _galleries;

  bool _isFetchingGallery = false;
  bool get isFetchingGallery => _isFetchingGallery;
  set isFetchingGallery(bool f) {
    _isFetchingGallery = f;
    notifyListeners();
  }

  Future<void> getGalleries() async {
    if (isBusy) return;
    clearErrors();

    isFetchingGallery = true;
    try {
      _galleries.clear();
      var gs = await FirebaseHelper.service.fetchGalleries(accountUser!.id!);
      
      logger.d("fetchGalleries");
      logger.d(gs);

      _galleries.addAll(gs);
      notifyListeners();
    } catch (e) {
      logger.e(e);
      setError(e);
    } finally {
      isFetchingGallery = false;
    }
  }
  
  bool _isCreatingRoom = false;
  bool get isCreatingRoom => _isCreatingRoom;
  set isCreatingRoom(bool flag) {
    _isCreatingRoom = flag;
    notifyListeners();
  }

  Future<void> onClickMoreButton() async {
    if (isMe) {
      var result = await Routers.goToAccountUpdatePage(context);
      if (result != null) {
        accountUser = result;
        notifyListeners();
      }
    } else {
      if (isBusy) return;
      clearErrors();

      isCreatingRoom = true;
      await runBusyFuture(() async {
        try {
          var existedRoom = await roomService.getRoomByChatUesr(
            id: accountUser!.id!,
          );
          if (existedRoom == null) {
            var room = RoomModel(
              userId: user?.id,
              userIds: [user?.id, accountUser?.id],
              content: '${user?.firstName} have created a room',
              updateDate: DateTime.now(),
              timestamp: DateTime.now(),
            );
            logger.d(room.toJson());
            await roomService.createRoom(room);
            existedRoom = await roomService.getRoomByChatUesr(
              id: accountUser!.id!,
            );
          }
          Routers.goToMessagePage(
            context,
            MessagePageData(room: existedRoom!, chatUser: accountUser!),
          );
        } catch (e) {
          logger.e(e);
          setError(e);
        } finally {
          isCreatingRoom = false;
        }
      }());

      if (hasError) {
        AIHelpers.showToast(msg: modelError.toString());
      }
    }
  }

  Future<void> onClickInfo(int index) async {
    Routers.goToAccountWalletPage(context);
  }

}
