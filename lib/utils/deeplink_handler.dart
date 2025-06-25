// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';

// import 'package:insoblok/services/services.dart';

// class DeepLinkHandler {
//   static const _eventChannel = EventChannel('insoblok.social.app/events');
//   static late IReownAppKitModal _appKitModal;

//   static void init(IReownAppKitModal appKitModal) {
//     if (kIsWeb) return;

//     try {
//       _appKitModal = appKitModal;
//       _eventChannel.receiveBroadcastStream().listen(_onLink, onError: _onError);
//     } catch (e) {
//       debugPrint('[SampleDapp] checkInitialLink $e');
//     }
//   }

//   static void _onLink(dynamic link) async {
//     try {
//       logger.d(link);
//       _appKitModal.dispatchEnvelope(link);
//     } catch (e) {
//       logger.d(e);
//     }
//   }

//   static void _onError(dynamic error) {
//     logger.d(error);
//   }
// }
