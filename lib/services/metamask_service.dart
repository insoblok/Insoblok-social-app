import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MetaMaskService {
  late Client httpClient;
  late WalletConnect connector;
  late EthereumWalletConnectProvider provider;
  Credentials? credentials;
  Web3Client? client;

  Future<void> connect() async {
    httpClient = Client();
    connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'InSoBlok',
        description: 'InSoBlok for image to ai image!',
      ),
    );

    // Subscribe to events
    connector.on('connect', (session) => _onConnect(session));
    connector.on('session_update', (payload) => _onSessionUpdate(payload));
    connector.on('disconnect', (session) => _onDisconnect());

    // Create the provider
    provider = EthereumWalletConnectProvider(connector);

    // Initialize the client
    client =
        Web3Client('https://mainnet.infura.io/v3/$kMetamaskApiKey', httpClient);

    // Check if already connected
    if (connector.connected) {
      // credentials = await provider.getCredentials();
      return;
    } else {
      await connector.createSession(
        // connector.createSession(
        chainId: 1, // Ethereum mainnet
        onDisplayUri: (uri) async {
          // Open MetaMask app with the URI
          await launchUrl(
              Uri.parse('metamask://wc?uri=${Uri.encodeComponent(uri)}'));
        },
      );
    }
  }

  void _onConnect(session) {
    credentials = session.getCredentials();
  }

  void _onSessionUpdate(payload) {
    logger.d(payload.toString());
  }

  void _onDisconnect() {
    credentials = null;
  }

  Future<String?> getWalletAddress() async {
    if (credentials == null) return null;
    final address = await credentials?.extractAddress();
    return address?.hex;
  }

  Future<void> disconnect() async {
    await connector.killSession();
    _onDisconnect();
  }
}
