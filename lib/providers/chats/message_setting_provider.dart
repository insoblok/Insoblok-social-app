import 'package:flutter/material.dart';

import 'package:insoblok/utils/utils.dart';

const kMessageSetting = [
  {
    'title': 'Receive messages from anyone',
    'desc':
        'You will be able to receive Direct Message requests from anyone on Twitter, even if you don’t follow them. ',
  },
  {
    'title': 'Quality filter',
    'desc':
        'Filters lower-quality messages from your Direct Message requests. ',
  },
  {
    'title': 'Show read receipts',
    'desc':
        'When someone sends you a message, peopla in the conversation will know when you’ve seen it. If you turn off this setting, you won’t be able to see read receipts from others. ',
  },
];

class MessageSettingProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }
}
