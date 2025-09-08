import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/utils/base_view_model.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/utils/const.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/widgets/widgets.dart';


class PaymentAmountProvider extends InSoBlokViewModel{
  
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  String get selectedNetwork => _web3Service.paymentNetwork;
  set selectedNetwork(String network) {
    _web3Service.paymentNetwork = network;
    notifyListeners();
  }

  Map<String, double> get allBalances => _web3Service.allBalances;

  final Web3Service _web3Service = locator<Web3Service>();
  TextEditingController amountController = TextEditingController();

  double get amount => _web3Service.paymentAmount;
  set amount(double a) {
    _web3Service.paymentAmount = a;
    notifyListeners();
  }

  @override
  List<ListenableServiceMixin> get listenableServices => [_web3Service];

  final NumberPlateController controller = NumberPlateController();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await _web3Service.getBalances(cryptoService.privateKey!.address.hex);
    logger.d("Balances are ${_web3Service.allBalances}");
  }


  void updateAmount(String amount) {
    if(amount.isEmpty || double.tryParse(amount) == null) {
      AIHelpers.showToast(msg: "Please enter valid amount.");
      return;
    }
    _web3Service.paymentAmount = double.parse(amount); 
  }

  void handleClickPreview(BuildContext context) {
    if (amount > (allBalances[selectedNetwork] ?? 0).toDouble()) {
      AIHelpers.showToast(msg: "Please enter valid amount");
      return;
    }
    Routers.goToPaymentConfirmPage(context);
  }
}