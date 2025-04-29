import 'package:flutter/material.dart';
import 'package:insoblok/services/app_sertting_service.dart';

import 'package:insoblok/utils/utils.dart';

class AppProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  void updateTheme() {
    AppSettingHelper.setTheme(
      AppSettingHelper.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light,
    );
    notifyListeners();
  }
}
