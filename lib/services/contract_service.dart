import 'package:web3dart/web3dart.dart';

class ContractService {
  final Web3Client _client;
  final String _contractAddress;
  final String _abi;

  late DeployedContract _contract;
  late ContractFunction _balanceOf;
  late ContractFunction _transfer;

  ContractService(this._client, this._contractAddress, this._abi) {
    _initializeContract();
  }

  void _initializeContract() {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abi, 'MyToken'),
      EthereumAddress.fromHex(_contractAddress),
    );

    _balanceOf = _contract.function('balanceOf');
    _transfer = _contract.function('transfer');
  }

  Future<BigInt> getBalance(EthereumAddress address) async {
    final result = await _client.call(
      contract: _contract,
      function: _balanceOf,
      params: [address],
    );
    return result.first as BigInt;
  }

  Future<String> transfer({
    required EthPrivateKey privateKey,
    required EthereumAddress to,
    required BigInt amount,
    required EtherAmount gasPrice,
    required int gasLimit,
  }) async {
    final transaction = Transaction.callContract(
      contract: _contract,
      function: _transfer,
      parameters: [to, amount],
      gasPrice: gasPrice,
      maxGas: gasLimit,
    );

    final result = await _client.sendTransaction(
      privateKey,
      transaction,
      chainId: (await _client.getChainId()).toInt(),
    );

    return result;
  }
}
