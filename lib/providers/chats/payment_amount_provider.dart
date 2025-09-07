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

  final ReactiveValue<String> _selectedNetwork = ReactiveValue<String>(kWalletTokenList[0]["chain"].toString());
  String get selectedNetwork =>  _selectedNetwork.value;
  set selectedNetwork(String s) {
    _selectedNetwork.value = s;
    notifyListeners();
  }

  Map<String, double> get allBalances => _web3Service.allBalances;

  final Web3Service _web3Service = locator<Web3Service>();
  TextEditingController amountController = TextEditingController();

  double get amount => _web3Service.paymentAmount;

  @override
  List<ListenableServiceMixin> get listenableServices => [_web3Service];

  final NumberPlateController controller = NumberPlateController();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await _web3Service.getBalances(cryptoService.privateKey!.address.hex);
    logger.d("Balances are ${_web3Service.allBalances}");
  }

  void setPaymentSelectedNetwork(String network) {
    _web3Service.paymentSelectedNetwork = network;
  }

  void setPaymentAmount(double amount) {
    _web3Service.paymentAmount = amount;
  }

  void updateAmount(String amount) {
    if(amount.isEmpty || double.tryParse(amount) == null) {
      AIHelpers.showToast(msg: "Please enter valid amount.");
      return;
    }
    _web3Service.paymentAmount = double.parse(amount); 
  }

  void handleClickPreview(BuildContext context) {
    if (amount > allBalances[selectedNetwork]!) {
      AIHelpers.showToast(msg: "Please enter valid amount");
      return;
    }
    setPaymentSelectedNetwork(selectedNetwork);
    Routers.goToPaymentConfirmPage(context);
  }
}