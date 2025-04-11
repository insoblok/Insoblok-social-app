import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:insoblok/services/services.dart';

import 'package:insoblok/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kScrappingUrl = 'https://genimg.ai/';

class AccountProvider extends InSoBlokViewModel {
  var stateListener = ValueNotifier(AccountProviderState.init);

  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  InAppWebViewController? webViewController;

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  Future<void> setWebview() async {
    webViewController?.scrollTo(x: 0, y: 800);

    // Inject CSS to disable scrolling
    await webViewController?.injectCSSCode(source: """
      html, body {
        overflow: hidden !important;
        overscroll-behavior: none !important;
      }
    """);

    // Additional JavaScript to prevent touch events
    await webViewController?.evaluateJavascript(source: """
      document.addEventListener('touchmove', function(e) {
        e.preventDefault();
      }, { passive: false });
      
      document.documentElement.style.overscrollBehavior = 'none';
    """);

    stateListener.value = AccountProviderState.loaded;
    getOrgImageData();
  }

  String? _base64Org;
  String? get base64Org => _base64Org;

  Future<void> getOrgImageData() async {
    var imageTag = await webViewController?.callAsyncJavaScript(
      functionBody: """
const images = document.getElementsByClassName("max-h-[200px] rounded-lg object-contain shadow-md");
if (images.length > 0) {
  const image = images[0];
  return image.getAttribute("src");
}
return null;
    """,
    );
    if (imageTag?.value != null) {
      _base64Org = imageTag?.value;
      stateListener.value = AccountProviderState.ready;
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      getOrgImageData();
    }
  }

  Future<void> onClickClearButton() async {
    var receiveOnClickEvent = '''
  const buttons = document.getElementsByClassName('inline-flex items-center justify-center gap-2 whitespace-nowrap text-sm font-medium focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0 hover:text-accent-foreground h-9 w-9 absolute -right-2 -top-2 rounded-full bg-white/80 backdrop-blur-sm border shadow hover:bg-white/90 transition-all hover:scale-105');
  var button = buttons[0];
  button.click();
''';
    await webViewController?.callAsyncJavaScript(
      functionBody: receiveOnClickEvent,
    );
    stateListener.value = AccountProviderState.loaded;
    _base64Org = null;
    getOrgImageData();
  }

  Future<void> onClickConvertImage() async {
    if (_base64Org == null) {
      Fluttertoast.showToast(msg: 'Please choose an origin image.');
      return;
    }
    var receiveOnClickEvent = '''
  const buttons = document.getElementsByTagName('button');
  var button = buttons[5];
  button.click();
''';
    await webViewController?.callAsyncJavaScript(
      functionBody: receiveOnClickEvent,
    );
    stateListener.value = AccountProviderState.creating;
    Future.delayed(const Duration(seconds: 15), getAIImageData);
  }

  String? _aiImageUrl;
  String? get aiImageUrl => _aiImageUrl;

  Future<void> getAIImageData() async {
    var imageTag = await webViewController?.callAsyncJavaScript(
      functionBody: """
const images = document.getElementsByClassName("aspect-square h-[200px] w-[200px] object-cover hover:scale-105 transition-transform duration-200 cursor-zoom-in");
if (images.length > 0) {
  const image = images[0];
  return image.getAttribute("src");
}
return null;
    """,
    );
    if (imageTag?.value != null) {
      _aiImageUrl = imageTag?.value;
      stateListener.value = AccountProviderState.done;
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      getAIImageData();
    }
  }

  Future<void> onClickConfirm() async {
    if (aiImageUrl == null) {
      Fluttertoast.showToast(
        msg: 'We didn\'t get an AI image yet. Please try to create image',
      );
      return;
    }
    var url = await FirebaseHelper.uploadImage(imageUrl: aiImageUrl!);
    Navigator.of(context).pop(url);
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }
}

enum AccountProviderState {
  init,
  loaded,
  ready,
  creating,
  done,
}
