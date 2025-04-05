import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart' as iaw;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:aiavatar/generated/l10n.dart';
import 'package:aiavatar/locator.dart';
import 'package:aiavatar/pages/pages.dart';
import 'package:aiavatar/routers/routers.dart';
import 'package:aiavatar/services/services.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  setupLocator();

  await DBHelper.service.init();
  await AuthHelper.service.init();

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('Error: $details');
  };

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await iaw.InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const AIAvatarApp());
}

final Navigation _navigation = Navigation();

class AIAvatarApp extends StatelessWidget {
  const AIAvatarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIAvatar',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueAccent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withAlpha(127),
        ),
      ),
      initialRoute: kRouterBase,
      onGenerateRoute: _navigation.router.generator,
      home: LoginPage(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
