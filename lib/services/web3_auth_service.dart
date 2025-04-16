import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:insoblok/services/services.dart';

class Web3AuthService {
  late InAppWebViewController _webViewController;

  Future<void> connectToMetaMask() async {
    InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri('https://metamask.app.link/connect?redirect=insoblok://'),
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: (controller, url) {
        if (url?.toString().startsWith('insoblok://') ?? false) {
          _handleDeepLink(url!);
        }
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    final params = uri.queryParameters;
    if (params.containsKey('address')) {
      final address = params['address']!;
      logger.d('Connected address: $address');
    }
  }

  Future<String> signMessage(String message) async {
    final script = '''
      window.ethereum.request({
        method: 'personal_sign',
        params: [
          '${message.replaceAll("'", "\\'")}',
          window.ethereum.selectedAddress
        ]
      })
    ''';

    final result = await _webViewController.evaluateJavascript(source: script);
    return result.toString();
  }
}
