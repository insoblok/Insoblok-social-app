import 'package:flutter/material.dart';

import 'package:aiavatar/routers/routers.dart';

class Routers {
  static _pushToRoute(BuildContext context, String route, props) {
    return Navigator.pushNamed(context, route, arguments: props);
  }

  static _pushReplacement(BuildContext context, String route, props) {
    return Navigator.pushReplacementNamed(context, route, arguments: props);
  }

  static void goToRegisterPage(BuildContext context) {
    _pushReplacement(context, kRouterRegister, null);
  }

  static void goToMainPage(BuildContext context) {
    _pushToRoute(context, kRouterMain, null);
  }

  static goToAccountPage(BuildContext context) {
    return _pushToRoute(context, kRouterAccount, null);
  }
}
