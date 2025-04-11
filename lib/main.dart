import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as iaw;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  HttpOverrides.global = MyHttpOverrides();

  setupLocator();

  await FirebaseHelper.init();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('Error: $details');
  };

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await iaw.InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const InSoBlokApp());
}

final Navigation _navigation = Navigation();

class InSoBlokApp extends StatelessWidget {
  const InSoBlokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InSoBlok',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
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
