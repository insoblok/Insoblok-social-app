import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as iaw;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/locator.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  var widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.e('Error: $details');
  };

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  setupLocator();

  EthereumHelper.init(kEthereumRpcUrl);
  await FirebaseHelper.init();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider()..init(context),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadMediaProvider()..init(context),
        ),
      ],
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
            home: LoginPage(),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}
