import 'package:web3dart/web3dart.dart';

class TokenService {
  final Web3Client _client;
  final String _tokenAddress;
  final String _tokenAbi;

  TokenService(this._client, this._tokenAddress, this._tokenAbi);

  Future<BigInt> getBalance(EthereumAddress address) async {
    final contract = DeployedContract(
      ContractAbi.fromJson(_tokenAbi, 'ERC20'),
      EthereumAddress.fromHex(_tokenAddress),
    );

    final balanceFunction = contract.function('balanceOf');
    final result = await _client.call(
      contract: contract,
      function: balanceFunction,
      params: [address],
    );

    return result.first as BigInt;
  }

  Future<String> transfer({
    required EthPrivateKey privateKey,
    required EthereumAddress to,
    required BigInt amount,
    required EtherAmount gasPrice,
    required BigInt gasLimit,
  }) async {
    final contract = DeployedContract(
      ContractAbi.fromJson(_tokenAbi, 'ERC20'),
      EthereumAddress.fromHex(_tokenAddress),
    );

    final transferFunction = contract.function('transfer');

    final transaction = Transaction.callContract(
      contract: contract,
      function: transferFunction,
      parameters: [to, amount],
      from: await privateKey.extractAddress(),
      gasPrice: gasPrice,
      maxGas: gasLimit.toInt(),
    );

    return await _client.sendTransaction(
      privateKey,
      transaction,
      chainId: (await _client.getChainId()).toInt(),
    );
  }
}
