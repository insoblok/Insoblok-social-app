import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:insoblok/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/locator.dart';

class ChatProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  // Suggested users (no existing room with current user)
  final List<UserModel> _suggestedUsers = [];
  List<UserModel> get suggestedUsers => _suggestedUsers;

  // Pagination controls
  static const int _roomsPageSize = 20;
  static const int _usersPageSize = 20;
  int _roomsVisibleCount = 0;
  int _usersVisibleCount = 0;
  int get roomsVisibleCount => _roomsVisibleCount;
  int get usersVisibleCount => _usersVisibleCount;

  // Firestore paging cursor for rooms
  DocumentSnapshot<Map<String, dynamic>>? _lastRoomDoc;
  bool _hasMoreRooms = true;
  bool get hasMoreRooms => _hasMoreRooms;

  String? _balance;
  String? get balance => _balance;
  set balance(String? s) {
    _balance = s;
    notifyListeners();
  }

  final Web3Service _web3Service = locator<Web3Service>();

  // Avoid per-getter allocations; sort once when data changes
  List<RoomModel> get sortedRooms => _rooms;
  // StreamSubscription? _roomsSubscription;
  
  Future<void> init(BuildContext context) async {
    this.context = context;

    await runBusyFuture(() async {
      await fetchData();
    }());

    // roomService.getRoomsStream().listen((queryRooms) {
    //   for (var doc in queryRooms.docs) {
    //     var json = doc.data();
    //     json['id'] = doc.id;
    //     var room = RoomModel.fromJson(json);
    //     if (rooms.map((r) => r.id).toList().contains(room.id)) {
    //       continue;
    //     }
    //     if ((room.userIds?.isNotEmpty ?? false) &&
    //         room.userIds!.contains(AuthHelper.user?.id)) {
    //       logger.d(room.id);
    //       _rooms.add(room);
    //     }
    //   }
    //   fetchData();
    // });
  }

  Future<void> fetchData() async {
    _rooms.clear();
    _suggestedUsers.clear();
    _lastRoomDoc = null;
    _hasMoreRooms = true;

    await _loadMoreRoomsFromServer();
    await geChatList();
  }

  Future<void> _loadMoreRoomsFromServer() async {
    if (!_hasMoreRooms) return;
    try {
      final snap = await roomService.getRoomsPage(
        limit: _roomsPageSize,
        startAfter: _lastRoomDoc,
      );

      if (snap.docs.isEmpty) {
        _hasMoreRooms = false;
        return;
      }

      for (final doc in snap.docs) {
        try {
          final json = doc.data();
          json['id'] = doc.id;
          final room = RoomModel.fromJson(json);
          if (room.userId != null && (room.userIds?.contains(AuthHelper.user?.id) ?? false)) {
            _rooms.add(room);
          }
        } catch (_) {}
      }

      _lastRoomDoc = snap.docs.last;

      // sort once after page append by updateDate desc
      _rooms.sort((a, b) {
        if (a.updateDate == null && b.updateDate == null) return 0;
        if (a.updateDate == null) return 1;
        if (b.updateDate == null) return -1;
        return (b.updateDate!.compareTo(a.updateDate!));
      });

      // update visible count window
      _roomsVisibleCount = _rooms.length;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> geChatList() async {
    logger.d('This is geChatList');

    try {
      var keyUsers = await userService.getAllUsers();

      // Use Set for O(1) lookup of userIds already in rooms
      final Set<String?> userIds = {};
      for (final room in _rooms) {
        userIds.addAll(room.userIds ?? []);
      }
      logger.d(keyUsers.length);

      for (final user in keyUsers) {
        if (user == null) continue;
        if (user.id == AuthHelper.user?.id) continue;
        if (userIds.contains(user.id)) continue;
        _suggestedUsers.add(user);
      }

      // Initialize suggested users pagination
      _usersVisibleCount = (_suggestedUsers.length < _usersPageSize)
          ? _suggestedUsers.length
          : _usersPageSize;
    } catch (e) {
      logger.e(e);
      setError(e);
    } finally {
      notifyListeners();
    }

  }

  // Pagination: increment visible windows
  void loadMoreRooms() {
    // Load next page from server if we've revealed all loaded rooms
    if (_roomsVisibleCount >= _rooms.length) {
      _loadMoreRoomsFromServer().then((_) => notifyListeners());
      return;
    }
    // Otherwise expand visible window locally
    _roomsVisibleCount = (_roomsVisibleCount + _roomsPageSize)
        .clamp(0, _rooms.length);
    notifyListeners();
  }

  void loadMoreSuggestedUsers() {
    if (_usersVisibleCount >= _suggestedUsers.length) return;
    _usersVisibleCount = (_usersVisibleCount + _usersPageSize)
        .clamp(0, _suggestedUsers.length);
    notifyListeners();
  }

  Future<void> gotoNewChat(UserModel? chatUser) async {
    if (isBusy || chatUser == null) return;
    clearErrors();
    RoomModel? existedRoom;
    
    // Gradient previously used in a confirmation dialog; kept here for reference
    
    await runBusyFuture(() async {
      try {
        existedRoom = await roomService.getRoomByChatUesr(id: chatUser.id!);
        if (existedRoom == null) {
          /*
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
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AIColors.white,
                          ),
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
          */
          var room = RoomModel(
            userId: user?.id,
            userIds: [user?.id, chatUser.id],
            content: '${user?.fullName} have created a room',
            updateDate: DateTime.now(),
            timestamp: DateTime.now(),
          );
          await roomService.createRoom(room);
          existedRoom = await roomService.getRoomByChatUesr(id: chatUser.id!);
          messageService.setInitialTypeStatus(existedRoom!.id!, chatUser.id!);
        }
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      if (existedRoom != null) {
        _web3Service.chatRoom = existedRoom ?? RoomModel();
        _web3Service.chatUser = chatUser;
        await Routers.goToMessagePage(
          context,
          MessagePageData(room: existedRoom!, chatUser: chatUser),
        );
      }

      fetchData();
    }
  }
}
