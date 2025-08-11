import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    await FirebaseHelper.init();
    AuthHelper.service.init();
    await NetworkHelper.service.init();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );

    var reownService = locator<ReownService>();
    await reownService.init(context);

    AuthHelper.updateStatus('Online');
    Routers.goToLoginPage(context);
    // Routers.goToMainPage(context);
  }
}
