import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AccountPublicProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _account;
  UserModel get account => _account;
  set account(UserModel model) {
    _account = model;
    notifyListeners();
  }

  late MediaPickerService _mediaPickerService;

  Future<void> init(BuildContext context) async {
    this.context = context;
    account = AuthHelper.user ?? UserModel();
    _mediaPickerService = MediaPickerService(this.context);
  }

  void updateFirstName(String s) {
    account = account.copyWith(firstName: s);
  }

  void updateLastName(String s) {
    account = account.copyWith(lastName: s);
  }

  void updateNickID(String s) {
    account = account.copyWith(nickId: s);
  }

  Future<void> updateDescription() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var desc = await Routers.goToQuillDescriptionPage(context);
        if (desc != null) {
          final converter = QuillDeltaToHtmlConverter(
            desc,
            ConverterOptions.forEmail(),
          );
          account = account.copyWith(desc: converter.convert());
        }
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

  XFile? _selectedFile;
  XFile? get selectedFile => _selectedFile;
  set selectedFile(XFile? f) {
    _selectedFile = f;
    notifyListeners();
  }

  Future<void> updateDiscovery() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var image = await _mediaPickerService.onPickerSingleMedia(
          isImage: true,
        );
        if (image != null) {
          selectedFile = image;
        }
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

  void onClickUpdateProfile() {
    if (isBusy) return;
    clearErrors();

    Navigator.of(context).pop(account);
  }
}
