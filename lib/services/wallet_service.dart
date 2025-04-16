import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class WalletService {
  Future<String> generateMnemonic() async {
    return bip39.generateMnemonic();
  }

  Future<EthPrivateKey> getPrivateKeyFromMnemonic(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = EthPrivateKey.fromHex(bytesToHex(seed.sublist(0, 32)));
    return hdWallet;
  }

  Future<EthereumAddress> getPublicKey(EthPrivateKey privateKey) async {
    return await privateKey.extractAddress();
  }

  Future<String> signTransaction({
    required EthPrivateKey privateKey,
    required Transaction transaction,
  }) async {
    final signature = await privateKey.signTransaction(transaction);
    return bytesToHex(signature);
  }
}
