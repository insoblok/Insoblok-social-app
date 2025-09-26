import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/locator.dart';

class ChatPaymentProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  String _fromAddress = "";
  String get fromAddress => _fromAddress;
  set fromAddress(String adr) {
    _fromAddress = adr;
    notifyListeners();
  }

  String _toAddress = "";
  String get toAddress => _toAddress;
  set toAddress(String adr) {
    _toAddress = adr;
    notifyListeners();
  }

  TextEditingController fromAddressTextEditingController = TextEditingController();
  TextEditingController toAddressTextEditingController = TextEditingController();

  final Web3Service web3Service = locator<Web3Service>();

  Future<void> init(BuildContext context) async {
    this.context = context;
  }



}