import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';

class AppSettingService with ListenableServiceMixin {
  final RxValue<ThemeMode> _themeModeRx = RxValue<ThemeMode>(ThemeMode.light);
  ThemeMode get themeMode => _themeModeRx.value;

  final RxValue<AppSettingModel?> _appSettingModelRx =
      RxValue<AppSettingModel?>(null);
  AppSettingModel? get appSettingModel => _appSettingModelRx.value;

  AppSettingService() {
    listenToReactiveValues([_themeModeRx, _appSettingModelRx]);

    init();
  }

  Future<void> init() async {
    final String response = await rootBundle.loadString(
      'assets/data/tastescore.json',
    );
    final data = (await json.decode(response)) as Map<String, dynamic>;
    Map<String, dynamic> newJson = {};
    for (var key in data.keys) {
      if (key == 'xp_earn') {
        List<dynamic> result = [];
        for (var k in (data[key] as Map<String, dynamic>).keys) {
          Map<String, dynamic> r = {
            ...(data[key] as Map<String, dynamic>)[k],
            'key': k,
          };
          result.add(r);
        }
        newJson[key] = result;
      } else {
        newJson[key] = data[key];
      }
    }
    _appSettingModelRx.value = AppSettingModel.fromJson(newJson);
    notifyListeners();
  }

  void setTheme(ThemeMode model) {
    _themeModeRx.value = model;
    notifyListeners();
  }

  ThemeData get theme => themeMode == ThemeMode.light ? lightTheme : darkTheme;

  ThemeData get lightTheme => ThemeData(
    fontFamily: 'SFProText',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AIColors.pink,
      primary: AIColors.pink,
      onPrimary: AIColors.black,
      secondary: AIColors.black,
      onSecondary: AIColors.white,
      primaryContainer: AIColors.lightBackground,
      onPrimaryContainer: AIColors.lightBackground,
    ),
    scaffoldBackgroundColor: AIColors.lightBackground,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AIColors.lightBackground,
      toolbarHeight: 45.0,
      iconTheme: IconThemeData(color: AIColors.lightIconColor),
      titleTextStyle: TextStyle(
        color: AIColors.lightTextColor,
        fontSize: 17.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AIColors.lightBackground,
      selectedItemColor: AIColors.pink,
      unselectedItemColor: AIColors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        color: AIColors.lightTextColor,
        fontSize: 22.0,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        color: AIColors.lightTextColor,
        fontSize: 19.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleSmall: TextStyle(
        color: AIColors.lightTextColor,
        fontSize: 17.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),

      bodyLarge: TextStyle(
        fontSize: 17.0,
        color: AIColors.lightTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.0,
        color: AIColors.lightTextColor,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
        color: AIColors.lightTextColor,
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
        color: AIColors.lightTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      displayMedium: TextStyle(
        fontSize: 18.0,
        color: AIColors.lightTextColor,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
      ),
      displaySmall: TextStyle(
        fontSize: 10.0,
        color: AIColors.lightTextColor,
        fontWeight: FontWeight.w300,
      ),

      headlineLarge: TextStyle(
        fontSize: 19.0,
        color: AIColors.lightTextColor,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.1,
      ),
      headlineMedium: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
        color: AIColors.lightTextColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: AIColors.lightTextColor,
      ),
    ),
    iconTheme: IconThemeData(color: AIColors.lightIconColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AIColors.pink,
    ),
  );

  ThemeData get darkTheme => ThemeData(
    fontFamily: 'SFProText',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AIColors.pink,
      primary: AIColors.pink,
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
      selectedItemColor: AIColors.pink,
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
        fontSize: 14.0,
        color: AIColors.darkTextColor,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.3,
      ),
      bodySmall: TextStyle(
        fontSize: 12.0,
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
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
        color: AIColors.darkTextColor,
      ),
    ),
    iconTheme: IconThemeData(color: AIColors.darkIconColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AIColors.pink,
    ),
  );

  Color get greyBackground =>
      themeMode == ThemeMode.light
          ? AIColors.lightGreyBackground
          : AIColors.darkGreyBackground;

  Color get transparentBackground =>
      themeMode == ThemeMode.light
          ? AIColors.lightTransparentBackground
          : AIColors.darkTransparentBackground;

  Color get background =>
      themeMode == ThemeMode.light
          ? AIColors.lightBackground
          : AIColors.darkBackground;

  Color get textColor =>
      themeMode == ThemeMode.light
          ? AIColors.lightTextColor
          : AIColors.darkTextColor;
}

class AppSettingHelper {
  static AppSettingService get service => locator<AppSettingService>();

  static ThemeMode get themeMode => service.themeMode;
  static ThemeData get lightTheme => service.lightTheme;
  static ThemeData get darkTheme => service.darkTheme;

  static AppSettingModel? get appSettingModel => service.appSettingModel;

  static void setTheme(ThemeMode model) => service.setTheme(model);

  static Color get greyBackground => service.greyBackground;
  static Color get transparentBackground => service.transparentBackground;
  static Color get background => service.background;
  static Color get textColor => service.textColor;
}
