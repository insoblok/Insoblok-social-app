import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class EthereumClient {
  late Web3Client _client;
  final String _rpcUrl;

  EthereumClient(String rpcUrl) : _rpcUrl = rpcUrl {
    _client = Web3Client(_rpcUrl, Client());
  }

  Future<String> getClientVersion() async {
    return await _client.getClientVersion();
  }

  Future<EtherAmount> getBalance(EthereumAddress address) async {
    return await _client.getBalance(address);
  }

  Future<BigInt> getChainId() async {
    return await _client.getChainId();
  }

  void dispose() {
    _client.dispose();
  }
}
