import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class WalletService {
  final EthereumService _ethereum = EthereumService(kMetamaskApiUrl);
  WalletConnect? _connector;

  Future<void> connectWithMetaMask() async {
    await _connectMetaMaskMobile();
  }

  Future<void> connectWithWalletConnect() async {
    _connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'InSoBlok',
        description: 'A decentralized Flutter application',
        url: 'https://insoblokai.firebaseapp.com/',
        icons: [
          'https://insoblokai.firebaseapp.com/assets/inso_logo-BZ2uTUHI.webp'
        ],
      ),
    );

    await _connector!.createSession(
      chainId: 1,
      onDisplayUri: (uri) async {
        // Show QR code or deep link
        final deepLink = 'wc://wc?uri=${Uri.encodeComponent(uri)}';
        if (await canLaunch(deepLink)) {
          await launch(deepLink);
        } else {
          // Show QR code
        }
      },
    );

    _connector!.on('connect', (session) => _onConnect(session));
    _connector!.on('session_update', (payload) => _onSessionUpdate(payload));
    _connector!.on('disconnect', (session) => _onDisconnect(session));
  }

  void _onConnect(dynamic session) {
    logger.d(session);
    final address = session.accounts[0];
    _ethereum.connectWithPrivateKey(''); // WalletConnect manages keys
  }

  void _onSessionUpdate(dynamic payload) {
    logger.d(payload);
  }

  void _onDisconnect(dynamic payload) {
    logger.d(payload);
  }

  Future<void> _connectMetaMaskMobile() async {
    final url = 'https://metamask.app.link/connect?redirect=insoblock://';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<String> signMessage(String message) async {
    // if (_connector != null) {
    //   return await _connector!.signPersonalMessage(
    //     message: message,
    //     address: _ethereum.address!.hex,
    //   );
    // } else {
    //   throw Exception('No wallet connected');
    // }
    throw Exception('No wallet connected');
  }

  Future<void> disconnect() async {
    if (_connector != null) {
      await _connector!.killSession();
    }
    _ethereum.dispose();
  }
}
