import 'package:insoblok/services/services.dart';

class MetaMaskUtils {
  static bool isValidAddress(String address) {
    return RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);
  }

  static String formatAddress(String address) {
    if (!isValidAddress(address)) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  static String formatSignature(String signature) {
    if (signature.length < 10) return signature;
    return '${signature.substring(0, 10)}...${signature.substring(signature.length - 8)}';
  }

  static Future<void> validateMetaMaskInstalled() async {
    if (!(await MetaMaskService.isAvailable())) {
      throw Exception(
        'MetaMask mobile app not installed',
      );
    }
  }
}
