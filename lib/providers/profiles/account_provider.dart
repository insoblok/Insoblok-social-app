import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AccountProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  UserModel? _accountUser;
  UserModel? get accountUser => _accountUser;
  set accountUser(UserModel? model) {
    _accountUser = model;
    notifyListeners();
  }

  bool get isMe => accountUser?.uid == AuthHelper.user?.uid;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  void init(BuildContext context, {UserModel? model}) async {
    this.context = context;
    accountUser = model ?? AuthHelper.user;

    await fetchStories();
    await getUserScore();
  }

  final List<StoryModel> stories = [];

  Future<void> fetchStories() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var s = await storyService.getStoriesByUid(accountUser!.uid!);
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
      var s = await tastScoreService.getScoresByUser(accountUser!.uid!);
      _scores.addAll(s);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isLoadingScore = false;
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
            uid: accountUser!.uid!,
          );
          if (existedRoom == null) {
            var room = RoomModel(
              uid: user?.uid,
              uids: [user?.uid, accountUser?.uid],
              content: '${user?.firstName} have created a room',
              updateDate: DateTime.now(),
              timestamp: DateTime.now(),
            );
            logger.d(room.toJson());
            await roomService.createRoom(room);
            existedRoom = await roomService.getRoomByChatUesr(
              uid: accountUser!.uid!,
            );
          }
          Routers.goToMessagePage(
            context,
            MessagePageData(room: existedRoom!, chatUser: user!),
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
