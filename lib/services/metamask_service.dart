import 'package:url_launcher/url_launcher.dart';

class MetaMaskService {
  static const String _metamaskUniversalLink = 'https://metamask.app.link';
  static const String _dappUrl = 'https://yourdapp.com';
  static const String _callbackScheme = 'insoblok';

  /// Checks if MetaMask is installed (web) or available (mobile)
  static Future<bool> isAvailable() async {
    return await _canLaunchMetaMaskMobile();
  }

  /// Connects to MetaMask and returns the wallet address
  static Future<String> connect() async {
    return await _connectMobile();
  }

  /// Signs a message with MetaMask
  static Future<String> signMessage(String message) async {
    return await _signMessageMobile(message);
  }

  /// Gets the current wallet address
  static Future<String> getWalletAddress() async {
    // Get from local storage in mobile
    return ''; // Implement storage retrieval
  }

  // Mobile-specific implementations
  static Future<bool> _canLaunchMetaMaskMobile() async {
    final url = Uri.parse('$_metamaskUniversalLink/connect');
    return await canLaunchUrl(url);
  }

  static Future<String> _connectMobile() async {
    final callbackUrl = '$_callbackScheme://metamask';
    final url = Uri.parse(
        '$_metamaskUniversalLink/connect?redirect=${Uri.encodeComponent('$_dappUrl?callback=${Uri.encodeComponent(callbackUrl)}')}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      // Handle the response via deep link
      return ''; // Return actual address from deep link handler
    }
    throw Exception('Could not launch MetaMask');
  }

  static Future<String> _signMessageMobile(String message) async {
    final callbackUrl = '$_callbackScheme://sign';
    final url = Uri.parse(
        '$_metamaskUniversalLink/sign?message=${Uri.encodeComponent(message)}&redirect=${Uri.encodeComponent('$_dappUrl?callback=${Uri.encodeComponent(callbackUrl)}')}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      // Handle the response via deep link
      return ''; // Return actual signature from deep link handler
    }
    throw Exception('Could not launch MetaMask');
  }
}
