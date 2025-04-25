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
    fontFamily: 'SFProText',
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
    fontFamily: 'SFProText',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AIColors.blue,
      primary: AIColors.black,
      onPrimary: AIColors.white,
      secondary: AIColors.white,
      onSecondary: AIColors.black,
      primaryContainer: AIColors.darkBackground,
      onPrimaryContainer: AIColors.lightBackground,
    ),
    scaffoldBackgroundColor: AIColors.darkBackground,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AIColors.darkBackground,
      toolbarHeight: 45.0,
      iconTheme: IconThemeData(color: AIColors.darkIconColor),
      titleTextStyle: TextStyle(
        color: AIColors.darkTextColor,
        fontSize: 17.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AIColors.darkBackground,
      selectedItemColor: AIColors.blue,
      unselectedItemColor: AIColors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AIColors.darkTextColor,
        fontSize: 22.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        color: AIColors.darkTextColor,
        fontSize: 19.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleSmall: TextStyle(
        color: AIColors.darkTextColor,
        fontSize: 17.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),

      bodyLarge: TextStyle(
        fontSize: 17.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      bodySmall: TextStyle(
        fontSize: 16.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
      ),

      labelLarge: TextStyle(
        fontSize: 16.0,
        color: AIColors.greyTextColor,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
      labelMedium: TextStyle(
        fontSize: 14.0,
        color: AIColors.greyTextColor,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.15,
      ),
      labelSmall: TextStyle(
        fontSize: 12.0,
        color: AIColors.greyTextColor,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),

      displayLarge: TextStyle(
        fontSize: 19.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      displayMedium: TextStyle(
        fontSize: 18.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
      ),
      displaySmall: TextStyle(
        fontSize: 10.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w300,
      ),

      headlineLarge: TextStyle(
        fontSize: 19.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
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
