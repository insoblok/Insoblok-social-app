import 'package:flutter/material.dart';

import 'package:fluro/fluro.dart' as fluro;

import 'package:insoblok/pages/pages.dart';

const kRouterBase = '/';
const kRouterLogin = '/login';
const kRouterRegister = '/register';
const kRouterMain = '/main';
const kRouterAccount = '/account';
const kRouterCreateRoom = '/create_room';
const kRouterMessage = '/message';

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

    // * LoginPage
    initRoute(
      kRouterLogin,
      (props) => LoginPage(),
    );

    // * RegisterPage
    initRoute(
      kRouterRegister,
      (props) => RegisterPage(),
    );

    // * MainPage
    initRoute(
      kRouterMain,
      (props) => InSoBlokPage(),
    );

    // * AccountPage
    initRoute(
      kRouterAccount,
      (props) => AccountPage(),
    );

    // * CreateRoomPage
    initRoute(
      kRouterCreateRoom,
      (props) => CreateRoomPage(),
    );

    // * MessagePage
    initRoute<MessagePageData>(
      kRouterMessage,
      (props) => MessagePage(data: props!),
    );
  }
}
