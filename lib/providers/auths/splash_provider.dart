import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as iaw;
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';

class SplashProvider extends ReactiveViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
    initAppConfig();
  }

  Future<void> initAppConfig() async {
    setupLocator();

    await FirebaseHelper.init();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await iaw.InAppWebViewController.setWebContentsDebuggingEnabled(
        kDebugMode,
      );
    }

    await Future.delayed(const Duration(milliseconds: 3000));

    Routers.goToLoginPage(context);
  }
}
