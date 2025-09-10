import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
// import 'package:media_kit/media_kit.dart';
import 'package:flutter/services.dart';
import 'package:insoblok/locator.dart';
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

final Navigation _navigation = Navigation();
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // REQUIRED for media_kit: platform libs must be in pubspec (see above).
  // MediaKit.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('FlutterError: $details');
  };

  
  // If you need to listen before runApp, keep it simple & guarded.
  try {
    AppLinks().uriLinkStream.listen((uri) {
      logger.d('onAppLink: $uri');
    });
  } catch (e) {
    logger.w('AppLinks init failed: $e');
  }

  runApp(const InSoBlokApp());
}

class InSoBlokApp extends StatelessWidget {
  const InSoBlokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: ViewModelBuilder<AppProvider>.reactive(
        viewModelBuilder: () => AppProvider(),
        onViewModelReady: (viewModel) => viewModel.init(context),
        builder: (context, viewModel, _) {
          return MaterialApp(
            title: 'InSoBlok',
            debugShowCheckedModeBanner: false,

            // THEMING
            themeMode: AppSettingHelper.themeMode,
            theme: AppSettingHelper.lightTheme,
            darkTheme: AppSettingHelper.darkTheme,

            // ROUTING
            initialRoute: kRouterBase,
            onGenerateRoute: _navigation.router.generator,
            scaffoldMessengerKey: scaffoldKey,

            // If you also want to show SplashPage by route, put it in the router.
            // Otherwise, uncomment next line to force a home page:
            // home: SplashPage(),

            // LOCALIZATION
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US')],
          );
        },
      ),
    );
  }
}
