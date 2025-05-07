// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:web3dart/web3dart.dart';

// class MetaMaskService {
//   static const String _rpcUrl = "https://mainnet.infura.io/v3/kMetamaskApiKey";

//   Web3Client? _web3client;
//   String? _currentAddress;
//   bool _isConnected = false;

//   Future<void> init() async {
//     _web3client = Web3Client(_rpcUrl, http.Client());
//     await _loadSession();
//   }

//   Future<void> _loadSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     _currentAddress = prefs.getString('walletAddress');
//     _isConnected = _currentAddress != null;
//   }

//   Future<void> _saveSession(String address) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('walletAddress', address);
//     _currentAddress = address;
//     _isConnected = true;
//   }

//   Future<void> disconnect() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('walletAddress');
//     _currentAddress = null;
//     _isConnected = false;
//   }

//   Future<void> connectToMetaMask() async {
//     try {
//       final url = 'https://metamask.app.link/dapp/www.insoblokai.io';

//       if (await canLaunchUrl(Uri.parse(url))) {
//         await launchUrl(Uri.parse(url));
//       } else {
//         throw 'Could not launch $url';
//       }

//       // In a real app, you would use WalletConnect or similar for proper connection
//       // This is a simplified version
//     } catch (e) {
//       throw 'Error connecting to MetaMask: $e';
//     }
//   }

//   Future<String> getWalletAddress() async {
//     if (_currentAddress != null) return _currentAddress!;
//     throw 'Not connected to any wallet';
//   }

//   Future<bool> isConnected() async {
//     return _isConnected;
//   }

//   // Add more methods for signing messages, transactions, etc.
// }
