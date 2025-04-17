import 'package:http/http.dart';
import 'package:insoblok/locator.dart';
import 'package:web3dart/web3dart.dart';

class EthereumService {
  late Web3Client _client;
  Credentials? _credentials;
  EthereumAddress? _address;
  String _rpcUrl;

  EthereumService(this._rpcUrl) {
    _client = Web3Client(_rpcUrl, Client());
  }

  Future<void> connectWithPrivateKey(String privateKey) async {
    _credentials = EthPrivateKey.fromHex(privateKey);
    _address = await _credentials!.extractAddress();
  }

  Future<void> connectWithMnemonic(String mnemonic) async {
    // final seed = bip39.mnemonicToSeed(mnemonic);
    // _credentials = EthPrivateKey.fromHex(bytesToHex(seed.sublist(0, 32)));
    // _address = await _credentials!.extractAddress();
  }

  Future<String> getBalance() async {
    if (_address == null) throw Exception('Not connected');
    final balance = await _client.getBalance(_address!);
    return balance.getValueInUnit(EtherUnit.ether).toStringAsFixed(4);
  }

  Future<String> sendTransaction({
    required String to,
    required String amount,
    EtherAmount? gasPrice,
    int? gasLimit,
  }) async {
    if (_credentials == null) throw Exception('Not connected');

    final tx = Transaction(
      to: EthereumAddress.fromHex(to),
      value:
          EtherAmount.fromUnitAndValue(EtherUnit.ether, double.parse(amount)),
      gasPrice: gasPrice ?? await _client.getGasPrice(),
      maxGas: gasLimit ?? 21000,
    );

    return await _client.sendTransaction(_credentials!, tx);
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

    return await _client.call(
      contract: contract,
      function: function,
      params: params,
    );
  }

  void dispose() {
    _client.dispose();
  }
}

class EthereumHelper {
  static EthereumService get service => locator<EthereumService>();
}
