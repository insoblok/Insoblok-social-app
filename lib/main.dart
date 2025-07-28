import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app_links/app_links.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('Error: $details');
  };

  setupLocator();

  AppLinks().uriLinkStream.listen((uri) {
    logger.d('onAppLink: $uri');
  });

  runApp(MaterialApp(home: const InSoBlokApp()));
}

final Navigation _navigation = Navigation();

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

class InSoBlokApp extends StatelessWidget {
  const InSoBlokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AppProvider())],
      child: ViewModelBuilder<AppProvider>.reactive(
        viewModelBuilder: () => AppProvider(),
        onViewModelReady: (viewModel) => viewModel.init(context),
        builder: (context, viewModel, _) {
          return MaterialApp(
            title: 'InSoBlok',
            debugShowCheckedModeBanner: false,
            themeMode: AppSettingHelper.themeMode,
            theme: AppSettingHelper.lightTheme,
            darkTheme: AppSettingHelper.darkTheme,
            initialRoute: kRouterBase,
            onGenerateRoute: _navigation.router.generator,
            scaffoldMessengerKey: scaffoldKey,
            home: SplashPage(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: [Locale('en', 'US')],
          );
        },
      ),
    );
  }
}
