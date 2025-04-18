import 'package:http/http.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:web3dart/web3dart.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/services/services.dart';

class EthereumService with ListenableServiceMixin {
  final RxValue<Web3Client?> _clientRx = RxValue<Web3Client?>(null);
  Web3Client? get client => _clientRx.value;

  final RxValue<Credentials?> _credentialsRx = RxValue<Credentials?>(null);
  Credentials? get credentials => _credentialsRx.value;

  final RxValue<EthereumAddress?> _addressRx = RxValue<EthereumAddress?>(null);
  EthereumAddress? get address => _addressRx.value;

  final RxValue<String?> _rpcUrlRx = RxValue<String?>(null);
  String? get rpcUrl => _rpcUrlRx.value;

  EthereumService() {
    listenToReactiveValues([
      _clientRx,
      _credentialsRx,
      _addressRx,
      _rpcUrlRx,
    ]);
  }

  void init(String rpcUrl) async {
    _rpcUrlRx.value = rpcUrl;
    _clientRx.value = Web3Client(rpcUrl, Client());

    notifyListeners();
  }

  Future<void> connectWithPrivateKey(String privateKey) async {
    _credentialsRx.value = EthPrivateKey.fromHex(privateKey);
    _addressRx.value = credentials?.address;
    logger.d(address);

    notifyListeners();
  }

  Future<String?> getBalance() async {
    if (address == null) throw Exception('Not connected');
    final balance = await client?.getBalance(address!);
    return balance?.getValueInUnit(EtherUnit.ether).toStringAsFixed(4);
  }

  Future<String> sendTransaction({
    required String to,
    required String amount,
    EtherAmount? gasPrice,
    int? gasLimit,
  }) async {
    if (credentials == null) throw Exception('Not connected');

    final tx = Transaction(
      to: EthereumAddress.fromHex(to),
      value: EtherAmount.fromBase10String(
        EtherUnit.ether,
        amount,
      ),
      gasPrice: gasPrice ?? await client?.getGasPrice(),
      maxGas: gasLimit ?? 21000,
    );

    return await client!.sendTransaction(credentials!, tx);
  }

  Future<dynamic> callContract({
    required String contractAddress,
    required String functionName,
    required ContractAbi abi,
    required List<dynamic> params,
  }) async {
    final contract =
        DeployedContract(abi, EthereumAddress.fromHex(contractAddress));
    final function = contract.function(functionName);

    return await client?.call(
      contract: contract,
      function: function,
      params: params,
    );
  }
}

class EthereumHelper {
  static EthereumService get service => locator<EthereumService>();

  static Web3Client? get client => service.client;
  static EthereumAddress? get address => service.address;
  static Credentials? get credentials => service.credentials;

  static void init(String rpcUrl) => service.init(rpcUrl);
  static Future<void> connectWithPrivateKey(String privateKey) =>
      service.connectWithPrivateKey(privateKey);
  static Future<String?> getBalance() => service.getBalance();
  static Future<String> sendTransaction({
    required String to,
    required String amount,
    EtherAmount? gasPrice,
    int? gasLimit,
  }) =>
      service.sendTransaction(
        to: to,
        amount: amount,
        gasPrice: gasPrice,
        gasLimit: gasLimit,
      );
  static Future<dynamic> callContract({
    required String contractAddress,
    required String functionName,
    required ContractAbi abi,
    required List<dynamic> params,
  }) =>
      service.callContract(
        contractAddress: contractAddress,
        functionName: functionName,
        abi: abi,
        params: params,
      );
}
