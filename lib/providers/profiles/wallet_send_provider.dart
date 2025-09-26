import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletSendProvider extends InSoBlokViewModel {
  // late BuildContext _context;
  // BuildContext get context => _context;
  // set context(BuildContext context) {
  //   _context = context;
  //   notifyListeners();
  // }

  final TextEditingController senderController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();

  final NumberPlateController controller = NumberPlateController();

  late FocusNode _focusNode;
  final Web3Service web3Service = locator<Web3Service>();
  Map<String, double> get allBalances => web3Service.allBalances;
  Map<String, double> get allPrices => web3Service.allPrices;

  @override
  List<ListenableServiceMixin> get listenableServices => [web3Service];

  String? get address => cryptoService.privateKey!.address.hex;  

  String? sender;
  String? receiver;
  String? network;
  double? amount;
  Map<String, dynamic> selectedNetwork = {};
  
  Future<void> _empty() async {}

  Future<void> init(BuildContext context, String s, String r, String n, double amt) async {
    // this.context = context;
    _focusNode = FocusNode();
    sender = s;
    receiver = r;
    if(n.isEmpty) network = kWalletTokenList.first["chain"].toString();
    else network = n;
    amount = amt;
    senderController.text = s;
    receiverController.text = r;
    setBusy(true);
    await Future.wait([
      web3Service.getBalances(address!),
      web3Service.getPrices(),
      web3Service.getTransactions(address!),
      s.isNotEmpty && r.isNotEmpty && n.isNotEmpty && amt > 0 ? web3Service.getTransactionFee(cryptoService.privateKey!, n, EthereumAddress.fromHex(r), amt) :  _empty()
    ]);
    allBalances["xp"] = (accountService.availableXP).toDouble();
    notifyListeners(); 
    setBusy(false);
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


  double get transactionFee => web3Service.transactionFee;

  Future<void> handleClickSend(BuildContext ctx) async {
    try {

      await sendToken(sender ?? "", receiver ?? "", network ?? "", amount ?? 0, cryptoService.privateKey!);
      logger.d("Network is $network");
      final selectedNetwork = kWalletTokenList.firstWhere((tk)=>tk["chain"] == network!);
      final CoinModel coin = CoinModel(icon: selectedNetwork["icon"].toString(), type: "paid", unit: selectedNetwork["short_name"].toString(), amount: web3Service.paymentAmount.toString());
      messageService.sendPaidMessage(chatRoomId: web3Service.chatRoom.id ?? "", coin: coin);
      Routers.goToPaymentResultPage(ctx);
    } catch (e) {
      logger.d("Exception raised while sending ${e.toString()}");
    }
  }

  Future<void> sendToken(String s, String r, String n, double amt, EthPrivateKey pk) async {
    if (isBusy) return;
    setBusy(true);
    if ((s).trim() == "" || r.trim() == "" || amt == 0) {
      AIHelpers.showToast(msg: "Please enter valid information.");
      setError("Please enter valid information.");
      return;
    }
    if ((allBalances[network] ?? 0) < amt) {
      logger.d("Insufficient balance.");
      AIHelpers.showToast(msg: "Insufficient Token Balance.");
      setError("Insufficient Token Balance.");
      return;
    }
    cryptoService.to_address = r;
    // cryptoService.from_address = cryptoService.privateKey!.address.hex;
    cryptoService.from_address = s;

    clearErrors();

    await runBusyFuture(() async {
      try {
        currentTransaction = await web3Service.sendEvmToken(r, amt, kWalletTokenList[selectedFromToken], pk);
        // var model = transferService.getTransferModel(
        //   fromToken: fromToken,
        //   toToken: toToken,
        //   from: (double.tryParse(fromTokenTextController.text) ?? 0),
        //   to: (double.tryParse(toTokenTextController.text) ?? 0),
        // );
        // await transferService.addTransfer(transfer: model);
        if(currentTransaction.isEmpty) { 
          setError("Failed to send token due to internal server error");
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        setBusy(false);
      }
    }());
    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
      return;
    }
    AIHelpers.showToast(msg: 'Successfully sent!');
    web3Service.getTransactionStatus(currentTransaction["tx_hash"], kWalletTokenList[selectedFromToken]["chain"].toString(), cryptoService.privateKey!.address.hex);
    web3Service.addTransaction(currentTransaction);
  }

  void handleClickNextOnSendPage(BuildContext ctx) {
    Routers.goToChatPaymentPage(ctx, cryptoService.privateKey!.address.hex, "");
  }

  void handleClickMax() {
    controller.value = (allBalances[network!] ?? 0).toString();
    amount = allBalances[network!] ?? 0;
  }

  void handleClickPreview(BuildContext context) {
    if ((amount ?? 0) > (allBalances[network] ?? 0).toDouble()) {
      AIHelpers.showToast(msg: "Please enter valid amount");
      return;
    }
    Routers.goToPaymentConfirmPage(context, sender ?? "", receiver ?? "", network ?? "", amount ?? 0);
  }

  void updateAmount(String amt) {
    if(amt.isEmpty || double.tryParse(amt) == null) {
      AIHelpers.showToast(msg: "Please enter valid amount.");
      return;
    }
    amount = double.parse(amt);
    web3Service.paymentAmount = double.parse(amt); 
  }

  void handleClickNextOnReceivePage(BuildContext ctx) {
    Routers.goToWalletReceiveConfirmPage(ctx);
  }
  @override
  void dispose() {
    // Clean up any resources
    senderController.dispose();
    receiverController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
}
