import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/utils/base_view_model.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/pages/chats/message_page.dart';


class PaymentResultProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final Web3Service _web3Service = locator<Web3Service>();
  Map<String, double> get allBalances => _web3Service.allBalances;
  Map<String, double> get allPrices => _web3Service.allPrices;

  String get selectedNetwork => _web3Service.paymentNetwork;
  double get amount => _web3Service.paymentAmount;
  String get toAddress => _web3Service.paymentToAddress;
  double get transactionFee => _web3Service.transactionFee;

  String get transactionHash => _web3Service.paymentTransactionHash; 

  @override
  List<ListenableServiceMixin> get listenableServices => [_web3Service];
  


  Future<void> init(BuildContext context) async {
    this.context = context;
    await _web3Service.getBalances(cryptoService.privateKey!.address.hex);
    await _web3Service.getPrices();
    await _web3Service.getTransactionFee(cryptoService.privateKey!, _web3Service.paymentNetwork, EthereumAddress.fromHex(_web3Service.paymentToAddress), _web3Service.paymentAmount);
    logger.d("Balances are ${_web3Service.allBalances}");
  }

  void handleClickReturn(BuildContext context) {
    Routers.goToMessagePage(context, MessagePageData(room: _web3Service.chatRoom, chatUser: _web3Service.chatUser));
  }
}