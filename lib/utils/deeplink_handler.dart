// import 'package:uni_links3/uni_links.dart';

// class DeepLinkHandler {
//   static Stream<String> get onWalletConnected {
//     return uriLinkStream
//         .where((uri) => uri?.path == '/metamask')
//         .map((uri) => uri?.queryParameters['address'] ?? '');
//   }

//   static Stream<String> get onMessageSigned {
//     return uriLinkStream
//         .where((uri) => uri?.path == '/sign')
//         .map((uri) => uri?.queryParameters['signature'] ?? '');
//   }

//   static Future<void> init() async {
//     // Handle initial link if app was opened via deep link
//     final initialUri = await getInitialUri();
//     if (initialUri != null) {
//       _handleDeepLink(initialUri);
//     }
//   }

//   static void _handleDeepLink(Uri uri) {
//     // Handle different deep link paths
//     if (uri.path == '/metamask') {
//       final address = uri. ['address'];
//       // Save address to local storage
//     } else if (uri.path == '/sign') {
//       final signature = uri.queryParameters['signature'];
//       // Process signature
//     }
//   }
// }
