import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';

class SearchProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void init(BuildContext context) async {
    this.context = context;
  }
}
