import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class ChatProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  Future<void> init(BuildContext context) async {
    this.context = context;

    FirebaseHelper.getRoomsStream().listen((queryRooms) {
      _rooms.clear();
      _rooms.addAll(
        queryRooms.docs.map((e) => e.data()).where((e) =>
            e.senderId == AuthHelper.user?.uid ||
            e.receiverId == AuthHelper.user?.uid),
      );
      logger.d(_rooms.length);
      notifyListeners();
    });
  }
}
