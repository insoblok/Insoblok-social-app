import 'package:flutter/material.dart';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class HelpProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;
  }

  String _name = '';
  String get name => _name;
  set name(String s) {
    _name = s;
    notifyListeners();
  }

  String _email = '';
  String get email => _email;
  set email(String s) {
    _email = s;
    notifyListeners();
  }

  String _message = '';
  String get message => _message;
  set message(String s) {
    _message = s;
    notifyListeners();
  }

  Future<void> onSendMessage() async {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Email address should not be emapy!');
      return;
    }
    if (!email.isEmailValid) {
      Fluttertoast.showToast(msg: 'Email address was not matched!');
      return;
    }
    if (message.isEmpty) {
      Fluttertoast.showToast(msg: 'The message should not be emapy!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        final Email emailSender = Email(
          body: message,
          subject: 'Help Center',
          recipients: [email],
          cc: [kRecevierEmail],
          // cc: ['cc@example.com'],
          // bcc: ['bcc@example.com'],
          // attachmentPaths: ['/path/to/attachment.zip'],
          isHTML: false,
        );
        await FlutterEmailSender.send(emailSender);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
