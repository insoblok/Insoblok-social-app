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

  String? _balance;
  String? get balance => _balance;
  set balance(String? s) {
    _balance = s;
    notifyListeners();
  }

  final RoomService _roomService = RoomService();
  RoomService get roomService => _roomService;

  Future<void> init(BuildContext context) async {
    this.context = context;

    await runBusyFuture(() async {
      _rooms.clear();
      _rooms.addAll(await roomService.getRooms());
    }());

    roomService.getRoomsStream().listen((queryRooms) {
      for (var doc in queryRooms.docs) {
        var json = doc.data();
        json['id'] = doc.id;
        var room = RoomModel.fromJson(json);
        if (rooms.map((r) => r.id).toList().contains(room.id)) {
          continue;
        }
        if (room.uids != null && room.uids!.contains(AuthHelper.user?.uid)) {
          _rooms.add(room);
        }
      }
      logger.d(_rooms.length);
      notifyListeners();
    });

    balance = await EthereumHelper.getBalance();
  }
}
