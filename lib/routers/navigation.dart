import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart' as fluro;

import 'package:aiavatar/pages/pages.dart';

const kRouterBase = '/';
const kRouterRegister = '/register';
const kRouterMain = '/main';
const kRouterAccount = '/account';

class Navigation {
  final router = fluro.FluroRouter();

  Navigation() {
    defineRoutes();
  }

  defineRoutes() {
    initRoute<T>(
      String route,
      Function(T? props) init, {
      fluro.TransitionType? transitionType,
    }) {
      router.define(
        route,
        handler: fluro.Handler(handlerFunc: (BuildContext? context, _) {
          final T? props = ModalRoute.of(context!)?.settings.arguments as T?;
          return init(props);
        }),
        transitionType: transitionType ?? fluro.TransitionType.native,
      );
    }

    // * StartPage
    initRoute<List<dynamic>>(
      kRouterBase,
      (props) => LoginPage(),
    );

    // * RegisterPage
    initRoute<List<dynamic>>(
      kRouterRegister,
      (props) => RegisterPage(),
    );

    // * MainPage
    initRoute<List<dynamic>>(
      kRouterMain,
      (props) => AIAvatarPage(),
    );

    // * AccountPage
    initRoute<List<dynamic>>(
      kRouterAccount,
      (props) => AccountPage(),
    );
  }
}
