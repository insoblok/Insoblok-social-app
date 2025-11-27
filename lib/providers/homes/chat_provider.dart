import 'package:flutter/material.dart';

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

  final RoomService roomService = RoomService(AuthHelper.user?.id ?? "");

  final List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  List<ChatRoomWithSettings> archivedRooms = [];
  List<ChatRoomWithSettings> _activeRooms = [];
  List<ChatRoomWithSettings> get activeRooms => _activeRooms;
  set activeRooms(List<ChatRoomWithSettings> rooms) {
    _activeRooms = rooms;
    notifyListeners();
  }

  List<ChatRoomWithSettings> mutedRooms = [];
  List<ChatRoomWithSettings> deletedRooms = [];

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

  final Set<String> _selectedRoomIds = {};
  Set<String> get selectedRoomIds => _selectedRoomIds;
  bool get isSelectionMode => _selectedRoomIds.isNotEmpty;

  List<RoomModel> get sortedRooms => _rooms;
  // StreamSubscription? _roomsSubscription;
  bool _isOptimisticUpdate = false;

  Future<void> init(BuildContext context) async {
    this.context = context;

    await runBusyFuture(() async {
      await fetchData();
    }());
    logger.d("init called");
    setupStreams();

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
    logger.d("This is loadmorefromserver");
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
          if (room.userId != null &&
              (room.userIds?.contains(AuthHelper.user?.id) ?? false)) {
            _rooms.add(room);
          }
        } catch (_) {}
      }

      _lastRoomDoc = snap.docs.last;

      // sort once after page append by updateDate desc
      // _rooms.sort((a, b) {
      //   if (a.updatedAt == null && b.updatedAt == null) return 0;
      //   if (a.updatedAt == null) return 1;
      //   if (b.updatedAt == null) return -1;
      //   return (b.updatedAt!.compareTo(a.updatedAt!));
      // });

      // update visible count window
      _roomsVisibleCount = _rooms.length;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> geChatList() async {
    try {
      var keyUsers = await userService.getAllUsers();

      final Set<String?> userIds = {};
      for (final room in _rooms) {
        userIds.addAll(room.userIds ?? []);
      }

      for (final user in keyUsers) {
        if (user == null) continue;
        if (user.id == AuthHelper.user?.id) continue;
        if (userIds.contains(user.id)) continue;
        // Skip users where both firstName and lastName are empty
        final firstName = user.firstName?.trim() ?? '';
        final lastName = user.lastName?.trim() ?? '';
        if (firstName.isEmpty && lastName.isEmpty) continue;
        _suggestedUsers.add(user);
      }

      // Initialize suggested users pagination
      _usersVisibleCount =
          (_suggestedUsers.length < _usersPageSize)
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
    _roomsVisibleCount = (_roomsVisibleCount + _roomsPageSize).clamp(
      0,
      _rooms.length,
    );
    notifyListeners();
  }

  void loadMoreSuggestedUsers() {
    if (_usersVisibleCount >= _suggestedUsers.length) return;
    _usersVisibleCount = (_usersVisibleCount + _usersPageSize).clamp(
      0,
      _suggestedUsers.length,
    );
    notifyListeners();
  }

  Future<void> gotoNewChat(BuildContext ctx, UserModel? chatUser) async {
    if (isBusy || chatUser == null) return;
    clearErrors();

    // Check if a room already exists between current user and chatUser
    final existingRoom = await roomService.getRoomByChatUser(
      id: chatUser.id ?? '',
    );

    RoomModel room;
    if (existingRoom != null &&
        existingRoom.id != null &&
        existingRoom.id!.isNotEmpty) {
      // Use existing room
      logger.d('Using existing room: ${existingRoom.id}');
      room = existingRoom;
    } else {
      // Create new room only if one doesn't exist
      logger.d('No existing room found, creating new room');
      room = RoomModel(
        userId: user?.id,
        userIds: [user?.id, chatUser.id],
        updatedAt: DateTime.now(),
        timestamp: DateTime.now(),
      );
      String roomId = await roomService.createRoom(room);
      if (roomId.isEmpty) {
        AIHelpers.showToast(
          msg: 'Failed to create chat room. Please try again.',
        );
        return;
      }
      room = room.copyWith(id: roomId);
    }

    Routers.goToMessagePage(
      ctx,
      MessagePageData(room: room, chatUser: chatUser),
    );
    // messageService.setInitialTypeStatus(roomId, chatUser.id!);
  }

  void toggleRoomSelection(RoomModel room) {
    if (_selectedRoomIds.contains(room.id)) {
      _selectedRoomIds.remove(room.id);
    } else {
      _selectedRoomIds.add(room.id!);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedRoomIds.clear();
    notifyListeners();
  }

  bool get isFirstSelectedRoomMuted {
    if (_selectedRoomIds.isEmpty) return false;
    final firstSelectedId = _selectedRoomIds.first;

    // Check in active rooms
    final activeRoom = _activeRooms.firstWhere(
      (room) => room.chatroom.id == firstSelectedId,
      orElse:
          () => ChatRoomWithSettings(
            chatroom: RoomModel(),
            userSettings: UserChatRoomModel(),
          ),
    );
    if (activeRoom.chatroom.id != null) {
      return activeRoom.userSettings.isMuted ?? false;
    }

    // Check in archived rooms
    final archivedRoom = archivedRooms.firstWhere(
      (room) => room.chatroom.id == firstSelectedId,
      orElse:
          () => ChatRoomWithSettings(
            chatroom: RoomModel(),
            userSettings: UserChatRoomModel(),
          ),
    );
    if (archivedRoom.chatroom.id != null) {
      return archivedRoom.userSettings.isMuted ?? false;
    }
    return false;
  }

  void deleteSelectedRooms() async {
    await roomService.deleteRooms(AuthHelper.user?.id ?? '', _selectedRoomIds);
    AIHelpers.showToast(msg: 'Deleted ${_selectedRoomIds.length} Chats');
    clearSelection();
  }

  void muteSelectedRooms() async {
    // Update local state optimistically
    _isOptimisticUpdate = true;
    _updateLocalMuteStatus(_selectedRoomIds, true);
    notifyListeners();
    await roomService.muteRooms(AuthHelper.user?.id ?? '', _selectedRoomIds);
    _isOptimisticUpdate = false;
    AIHelpers.showToast(msg: '${_selectedRoomIds.length} Chats muted');
    clearSelection();
  }

  void unMuteSelectedRooms() async {
    // Update local state optimistically
    _isOptimisticUpdate = true;
    _updateLocalMuteStatus(_selectedRoomIds, false);
    notifyListeners();
    for (int i = 0; i < _activeRooms.length; i++) {
      logger.d(
        "active rooms mute state is : ${_activeRooms[i].userSettings.isMuted}",
      );
    }
    await roomService.unMuteRooms(AuthHelper.user?.id ?? '', _selectedRoomIds);
    _isOptimisticUpdate = false;
    AIHelpers.showToast(msg: 'UnMuted ${_selectedRoomIds.length} Chats');
    clearSelection();
  }

  void _updateLocalMuteStatus(Set<String> roomIds, bool isMuted) {
    // Update active rooms
    for (int i = 0; i < _activeRooms.length; i++) {
      if (roomIds.contains(_activeRooms[i].chatroom.id)) {
        _activeRooms[i] = ChatRoomWithSettings(
          chatroom: _activeRooms[i].chatroom,
          userSettings: _activeRooms[i].userSettings.copyWith(isMuted: isMuted),
        );
      }
    }

    // Update archived rooms
    for (int i = 0; i < archivedRooms.length; i++) {
      if (roomIds.contains(archivedRooms[i].chatroom.id)) {
        archivedRooms[i] = ChatRoomWithSettings(
          chatroom: archivedRooms[i].chatroom,
          userSettings: archivedRooms[i].userSettings.copyWith(
            isMuted: isMuted,
          ),
        );
      }
    }
  }

  void archiveSelectedRooms() async {
    await roomService.archive(AuthHelper.user?.id ?? '', _selectedRoomIds);
    AIHelpers.showToast(msg: 'Archived ${_selectedRoomIds.length} Chats');
    clearSelection();
  }

  void unarchiveSelectedRooms() async {
    await roomService.unArchive(AuthHelper.user?.id ?? '', _selectedRoomIds);
    AIHelpers.showToast(msg: 'Unarchived ${_selectedRoomIds.length} Chats');
    clearSelection();
  }

  void setupStreams() {
    roomService.getActiveChatrooms().listen((chatrooms) {
      if (_isOptimisticUpdate) return;
      for (var room in chatrooms) {
        // logger.d("active chats: ${room.id}");
      }
      _activeRooms = chatrooms;
      notifyListeners();
    });

    // Archived chatrooms
    roomService.getArchivedChatrooms().listen((chatrooms) {
      for (var room in chatrooms) {
        // logger.d("archived chats: ${room.id}");
      }
      archivedRooms = chatrooms;
      notifyListeners();
    });

    // Muted chatrooms
    roomService.getMutedChatrooms().listen((chatrooms) {
      mutedRooms = chatrooms;
      notifyListeners();
    });

    // Deleted chatrooms
    roomService.getDeletedChatrooms().listen((chatrooms) {
      deletedRooms = chatrooms;
      notifyListeners();
    });
  }

  /// Refresh the chat list data
  Future<void> refreshChatList() async {
    await fetchData();
  }
}
