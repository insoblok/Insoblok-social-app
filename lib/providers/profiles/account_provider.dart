import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/locator.dart';

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

  final globals = GlobalStore();
  bool get enabled => globals.isRRCVideoCapture;

  bool _isRRCImage = false;
  bool get isRRCImage => _isRRCImage;

  void setRRCImage(bool value) {
    if (_isRRCImage == value) return;
    _isRRCImage = value;

    savePreference();
    notifyListeners();
  }

  // Optional helper if you want a toggle
  void toggleRRCImage() => setRRCImage(!_isRRCImage);

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

  final Web3Service _web3Service = locator<Web3Service>();

  List<String> selectedItems = [];
  bool isSelectMode = false;

  void init(BuildContext context, {UserModel? model}) async {
    this.context = context;
    accountUser = model ?? AuthHelper.user;

    logger.d("this is the account user");
    logger.d(accountUser?.toJson());

    _isRRCImage = !enabled;

    await fetchStories();
    await getUserScore();
    await fetchFollowings();
    await getGalleries();
    if (!isMe) await updateViews();
    // logger.d("This is before migrations");
    // await migrateUsersCollection();
  }

  Future<void> migrateUsersCollection() async {
    final collectionRef = FirebaseFirestore.instance.collection('story');

    // Get all documents
    final querySnapshot = await collectionRef.get();

    final batch = FirebaseFirestore.instance.batch();
    int processedCount = 0;
    int batchCount = 0;

    for (final doc in querySnapshot.docs) {
      final data = doc.data();

      // Only process documents that have the 'timestamp' field
      if (data.containsKey('timestamp') && !data.containsKey('created_at')) {
        batch.update(doc.reference, {
          'created_at': data['timestamp'],
          'updated_at': data['update_date'],
          'timestamp': FieldValue.delete(),
        });
        logger.d("This is updating data $data");
        processedCount++;
      }

      // Firestore batches are limited to 500 operations
      if (processedCount % 500 == 0 && processedCount > 0) {
        await batch.commit();
        batchCount++;
        print(
          'Committed batch $batchCount, processed $processedCount documents',
        );
      }
    }

    // Commit any remaining operations
    if (processedCount % 500 != 0) {
      await batch.commit();
      batchCount++;
    }
  }

  final List<StoryModel> stories = [];

  int get userRank => accountService.userRankIndex;

  void setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  Future<void> savePreference() async {
    globals.isRRCVideoCapture = !isRRCImage;

    logger.d("isRRCImage : ${globals.isRRCVideoCapture}");

    await globals.save();
  }

  Future<void> fetchStories() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        logger.d(accountUser?.id);
        logger.d(AuthHelper.user?.id ?? "");
        var s = await storyService.getStoriesById(accountUser?.id ?? "");
        for (var story in s) {
          logger.d("This is fetched stories ${story.id}, ${story.medias}");
        }
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
    await tastScoreService.followScore();

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
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFF30C6C), // pink
        Color(0xFFC739EB), // purple
      ],
    );

    RoomModel? existedRoom;
    try {
      existedRoom = await roomService.getRoomByChatUser(id: accountUser!.id!);
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
                    // color: AIColors.pink,
                    gradient: gradient,
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
          updatedAt: DateTime.now(),
          timestamp: DateTime.now(),
        );
        await roomService.createRoom(room);
        existedRoom = await roomService.getRoomByChatUser(id: accountUser!.id!);
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
        _web3Service.chatRoom = existedRoom;
        _web3Service.chatUser = accountUser ?? UserModel();
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

  final List<GalleryModel> _galleries = [];
  List<GalleryModel> get galleries => _galleries;

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

      logger.d("fetched galleries are $gs");

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
          var existedRoom = await roomService.getRoomByChatUser(
            id: accountUser!.id!,
          );
          if (existedRoom == null) {
            var room = RoomModel(
              userId: user?.id,
              userIds: [user?.id, accountUser?.id],
              content: '${user?.firstName} have created a room',
              updatedAt: DateTime.now(),
              timestamp: DateTime.now(),
            );
            logger.d(room.toJson());
            await roomService.createRoom(room);
            existedRoom = await roomService.getRoomByChatUser(
              id: accountUser!.id!,
            );
          }
          _web3Service.chatRoom = existedRoom ?? RoomModel();
          _web3Service.chatUser = accountUser ?? UserModel();
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

  Future<void> handleClickDeleteGallery() async {
    bool result = await accountService.removeGalleries(
      selectedItems,
      AuthHelper.user!,
    );
    if (result) {
      galleries.removeWhere((element) => selectedItems.contains(element.media));
      selectedItems.clear();
      isSelectMode = false;
      notifyListeners();
      AIHelpers.showToast(msg: 'Galleries deleted successfully');
    } else {
      AIHelpers.showToast(msg: "Failed to delete galleries");
    }
  }

  void handleLongPress(String url) {
    isSelectMode = true;
    selectedItems.add(url);
    notifyListeners();
  }

  void handleClickGallery(String url) {
    if (isSelectMode) {
      if (selectedItems.contains(url)) {
        selectedItems.remove(url);
        if (selectedItems.isEmpty) {
          isSelectMode = false;
        }
      } else {
        selectedItems.add(url);
      }
      notifyListeners();
    } else {
      AIHelpers.goToDetailView(
        context,
        medias: [url],
        index: 0,
        storyID: '',
        storyUser: '',
      );
    }
  }

  Future<void> handleClickDeleteStories() async {
    bool result = await accountService.removeStories(
      selectedItems,
      AuthHelper.user!,
    );
    if (result) {
      stories.removeWhere((element) => selectedItems.contains(element.id));
      selectedItems.clear();
      isSelectMode = false;
      notifyListeners();
      AIHelpers.showToast(msg: 'Stories deleted successfully');
    }
  }

  void resetSelection() {
    isSelectMode = false;
    selectedItems.clear();
    notifyListeners();
  }
}
