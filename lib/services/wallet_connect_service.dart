import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:insoblok/services/services.dart';

class WalletConnectService {
  late WalletConnect _connector;

  Future<void> connect() async {
    _connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'My Flutter DApp',
        description: 'A Web3 Flutter Application',
        url: 'https://myflutterdapp.com',
        icons: ['https://myflutterdapp.com/icon.png'],
      ),
    );

    await _connector.createSession(
      chainId: 1,
      onDisplayUri: (uri) async {
        // Show QR code or deep link
        logger.d(uri);
      },
    );

    _connector.on('connect', (session) => _onConnect(session));
    _connector.on('session_update', (payload) => _onSessionUpdate(payload));
    _connector.on('disconnect', (session) => _onDisconnect(session));
  }

  void _onConnect(dynamic session) {
    logger.d('Connected: ${session.accounts[0]}');
  }

  void _onSessionUpdate(dynamic payload) {
    logger.d('Session updated: $payload');
  }

  void _onDisconnect(dynamic session) {
    logger.d('Disconnected: $session');
  }

  // Future<String> personalSign({
  //   required String message,
  //   required String address,
  // }) async {
  //   return await _connector.signPersonalMessage(
  //     message: message,
  //     address: address,
  //   );
  // }

  Future<void> disconnect() async {
    await _connector.killSession();
  }
}
