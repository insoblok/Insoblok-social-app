// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// // import 'package:walletconnect_dart/walletconnect_dart.dart';

// import 'package:insoblok/services/services.dart';
// import 'package:insoblok/utils/utils.dart';

// // const kWalletPeerMeta = PeerMeta(
// //   name: 'AIAvatar',
// //   description: 'A decentralized Flutter application',
// //   url: 'https://insoblokai.io/',
// //   icons: ['https://insoblokai.firebaseapp.com/assets/inso_logo-BZ2uTUHI.webp'],
// // );

// const kWalletPeerMeta = PeerMeta(
//   name: 'WalletConnect',
//   description: 'WalletConnect Developer App',
//   url: 'https://walletconnect.com/',
//   icons: [
//     'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media',
//   ],
// );

// class WalletService {
//   WalletConnect? _connector;

//   Future<void> connectWithMetaMask() async {
//     await _connectMetaMaskMobile();
//   }

//   Future<void> connectWithWalletConnect() async {
//     try {
//       _connector = WalletConnect(
//         bridge: 'https://bridge.walletconnect.org',
//         clientMeta: kWalletPeerMeta,
//       );

//       if (!_connector!.connected) {
//         final session = await _connector!.createSession(
//           onDisplayUri: (uri) async {
//             logger.d(uri);
//             // await launchUrlString(uri, mode: LaunchMode.externalApplication);
//             final url = 'https://metamask.app.link/dapp/$uri';
//             if (await canLaunchUrl(Uri.parse(url))) {
//               await launchUrl(Uri.parse(url));
//             }
//           },
//         );
//         logger.d('session created');
//         logger.d(session.accounts[0]);
//         logger.d(session.chainId);
//       }

//       _connector!.on('connect', (session) => _onConnect(session));
//       _connector!.on('session_update', (payload) => _onSessionUpdate(payload));
//       _connector!.on('disconnect', (session) => _onDisconnect(session));
//     } catch (e) {
//       logger.e(e);
//     }
//   }

//   void _onConnect(dynamic session) {
//     logger.d(session);
//     final address = session.accounts[0];
//     logger.d(address);
//     EthereumHelper.service.connectWithPrivateKey(kMetamaskApiKey);
//   }

//   void _onSessionUpdate(dynamic payload) {
//     logger.d(payload);
//   }

//   void _onDisconnect(dynamic payload) {
//     logger.d(payload);
//   }

//   Future<void> _connectMetaMaskMobile() async {
//     final url = 'https://metamask.app.link/connect?redirect=insoblock://';
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     }
//   }

//   Future<String> signMessage(String message) async {
//     // if (_connector != null) {
//     //   return await _connector!.signPersonalMessage(
//     //     message: message,
//     //     address: _ethereum.address!.hex,
//     //   );
//     // } else {
//     //   throw Exception('No wallet connected');
//     // }
//     throw Exception('No wallet connected');
//   }

//   Future<void> disconnect() async {
//     if (_connector != null) {
//       await _connector!.killSession();
//     }
//   }
// }
