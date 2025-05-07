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

    balance = await EthereumHelper.getBalance();

    roomService.getRoomsStream().listen((queryRooms) {
      _rooms.clear();
      for (var doc in queryRooms.docs) {
        var json = doc.data();
        _rooms.add(RoomModel.fromJson(json));
      }
      logger.d(_rooms.length);
      notifyListeners();
    });
  }
}
