import 'package:flutter/material.dart';

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/utils/utils.dart';

class AppSettingService with ListenableServiceMixin {
  final RxValue<ThemeMode> _themeModeRx = RxValue<ThemeMode>(ThemeMode.dark);
  ThemeMode get themeMode => _themeModeRx.value;

  AppSettingService() {
    listenToReactiveValues([_themeModeRx]);
  }

  void setTheme(ThemeMode model) {
    _themeModeRx.value = model;
    notifyListeners();
  }

  ThemeData get theme => themeMode == ThemeMode.light ? lightTheme : darkTheme;

  ThemeData get lightTheme => ThemeData(
    fontFamily: 'Geist',
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    scaffoldBackgroundColor: AIColors.darkScaffoldBackground,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AIColors.darkBar,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: TextTheme(),
  );

  ThemeData get darkTheme => ThemeData(
    fontFamily: 'Geist',
    colorScheme: ColorScheme.fromSeed(seedColor: AIColors.darkPrimaryColor),
    scaffoldBackgroundColor: AIColors.darkScaffoldBackground,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AIColors.darkBar,
      iconTheme: IconThemeData(color: AIColors.darkTextColor),
      titleTextStyle: TextStyle(
        color: AIColors.darkTextColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(fontSize: 14.0, color: AIColors.darkTextColor),
      displaySmall: TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w300,
        color: AIColors.darkTextColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: AIColors.darkTextColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: AIColors.darkTextColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: AIColors.darkTextColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w300,
        color: AIColors.darkTextColor,
      ),
      labelMedium: TextStyle(color: AIColors.darkTextColor),
      labelSmall: TextStyle(fontSize: 12.0, color: AIColors.yellow),
    ),
    iconTheme: IconThemeData(color: AIColors.darkIconColor),
  );
}

class AppSettingHelper {
  static AppSettingService get service => locator<AppSettingService>();

  static ThemeMode get themeMode => service.themeMode;
  static ThemeData get lightTheme => service.lightTheme;
  static ThemeData get darkTheme => service.darkTheme;
}
