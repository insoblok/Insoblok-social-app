import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';


class WalletSendProvider extends InSoBlokViewModel {
  // late BuildContext _context;
  // BuildContext get context => _context;
  // set context(BuildContext context) {
  //   _context = context;
  //   notifyListeners();
  // }

  final TextEditingController _sendTokenTextController = TextEditingController();
  final TextEditingController _receiverTextController = TextEditingController();
  TextEditingController get sendTokenTextController => _sendTokenTextController;
  TextEditingController get receiverTextController => _receiverTextController;


  late FocusNode _focusNode;
  final Web3Service _web3Service = locator<Web3Service>();
  Map<String, double>? get allBalances => _web3Service.allBalances;
  Map<String, double>? get allPrices => _web3Service.allPrices;

  @override
  List<ListenableServiceMixin> get listenableServices => [_web3Service];

  String? get address => cryptoService.privateKey!.address.hex;  

  Future<void> init(BuildContext context) async {
    // this.context = context;
    _focusNode = FocusNode();

    getTransfers();
    // setBalances(balances);
    logger.d("THis is before get balances and prices");
    await Future.wait([
      _web3Service.getBalances(address!),
      _web3Service.getPrices(),
      _web3Service.getTransactions(address!)
    ]);
    notifyListeners(); 

  }

  final List<TransferModel> _transfers = [];
  
  List<double> get transferXpToInsoValues =>
      transferService.getXpToInsoBalance(_transfers);

  List<double> get transferInsoToUsdtValues =>
      transferService.getInsoToUsdtBalance(_transfers);

  double get balanceInso =>
      transferXpToInsoValues[1] - transferInsoToUsdtValues[0];
  double get balanceUsdt => transferInsoToUsdtValues[1];

  double _availableValue = 0;
  double get availableValue => _availableValue;
  set availableValue(double f) {
    _availableValue = f;
    notifyListeners();
  }

  Map<String, double> _balances = {};
  Map<String, double> get balances => _balances;
  void setBalances(Map<String, double> newBalances) {
    _balances = newBalances;
    notifyListeners();
  }

  double getBalance(String chain) {
    return _balances[chain] ?? 0.0;
  }

  bool _isInitLoading = false;
  bool get isInitLoading => _isInitLoading;
  set isInitLoading(bool f) {
    _isInitLoading = f;
    notifyListeners();
  }

  int _selectedFromToken = 0;
  int get selectedFromToken => _selectedFromToken;
  set selectedFromToken(int f) {
    _selectedFromToken = f;
    notifyListeners();
  }

  int _selectedToToken = 0;
  int get selectedToToken => _selectedToToken;
  set selectedToToken(int f) {
    _selectedToToken = f;
    notifyListeners();
  }

  double _convertRate = 0.0;
  double get convertRate => _convertRate;
  set convertRate(double f) {
    _convertRate = f;
    notifyListeners();
  }

  bool _isPossibleConvert = false;
  bool get isPossibleConvert => _isPossibleConvert;
  set isPossibleConvert(bool f) {
    _isPossibleConvert = f;
    notifyListeners();
  }


  Map<String, dynamic> currentTransaction = {};

  final api = ApiService(baseUrl: INSOBLOK_WALLET_URL);

  void selectFromToken(int index) {
    selectedFromToken = index;
    switch (kWalletTokenList[index]['name']) {
      case 'inso':
        availableValue = allBalances!["insoblok"] ?? 0;
        break;
      case 'usdt':
        availableValue = allBalances!["usdt"] ?? 0;
        break;
      case 'xrp':
        availableValue = allBalances!["xrp"] ?? 0;
      case 'eth':
        availableValue = allBalances!["ethereum"] ?? 0;
      case 'seth':
        availableValue = allBalances!["sepolia"] ?? 0;
        break;
    }
    logger.d("Available Value is $availableValue");
    getRate(
      kWalletTokenList[index]['name'].toString(),
      kWalletTokenList[selectedToToken]['name'].toString(),
    );
    if ((double.tryParse(_sendTokenTextController.text) ?? 0) > availableValue) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }
    notifyListeners();
  }

  void selectToToken(int index) {
    selectedToToken = index;
    getRate(
      kWalletTokenList[selectedFromToken]['name'].toString(),
      kWalletTokenList[index]['name'].toString(),
    );
    notifyListeners();
  }

  void getRate(String? from, String? to) {
    // for (var rate in kSwapRate) {
    //   if (rate['from'] == from && rate['to'] == to) {
    //     convertRate = rate['rate'] as double;
    //   }
    // }
  }

  void changingSendTokenValue(String? fromToken) {
    if (fromToken == null) return;
    if ((double.tryParse(fromToken) ?? 0) > availableValue ||
        (double.tryParse(fromToken) ?? 0) == 0) {
      isPossibleConvert = false;
    } else {
      isPossibleConvert = true;
    }

    _sendTokenTextController.text =
        ((double.tryParse(fromToken) ?? 0) * convertRate).toString();
    notifyListeners();
  }

  Future<void> getTransfers() async {
    isInitLoading = true;
    try {
      _transfers.clear();
      var t = await transferService.getTransfers(user!.id!);
      _transfers.addAll(t);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isInitLoading = false;
      selectFromToken(0);
    }
  }

  Future<void> sendToken() async {
    if (isBusy) return;
    setBusy(true);
    if (_receiverTextController.text.trim() == "") {
      AIHelpers.showToast(msg: "Please enter the receiver address.");
      setError("Please enter the receiver address.");
      return;
    }
    if (availableValue < double.parse(_sendTokenTextController.text.trim())) {
      logger.d("Insufficient balance.");
      AIHelpers.showToast(msg: "Insufficient Token Balance.");
      setError("Insufficient Token Balance.");
      return;
    }
    cryptoService.to_address = _receiverTextController.text.trim();
    cryptoService.from_address = cryptoService.privateKey!.address.hex;

    clearErrors();

    await runBusyFuture(() async {
      try {
        currentTransaction = await web3Service.sendEvmToken(_receiverTextController.text.trim(), double.parse(_sendTokenTextController.text.trim()), kWalletTokenList[selectedFromToken], cryptoService.privateKey);
        // var model = transferService.getTransferModel(
        //   fromToken: fromToken,
        //   toToken: toToken,
        //   from: (double.tryParse(fromTokenTextController.text) ?? 0),
        //   to: (double.tryParse(toTokenTextController.text) ?? 0),
        // );
        // await transferService.addTransfer(transfer: model);
        logger.d("This is before add Transaction $currentTransaction");
        if(currentTransaction.isEmpty) { 
          setError("Failed to send token due to internal server error");
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        getTransfers();
        setBusy(false);
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
      return;
    }
    AIHelpers.showToast(msg: 'Successfully sent!');
    _web3Service.getTransactionStatus(currentTransaction["tx_hash"], kWalletTokenList[selectedFromToken]["chain"].toString(), cryptoService.privateKey!.address.hex);
    _web3Service.addTransaction(currentTransaction);
    logger.d("Web3Service transaction length is ${_web3Service.transactions!.length}");
  }

  @override
  void dispose() {
    // Clean up any resources
    _sendTokenTextController.dispose();
    _receiverTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
}
