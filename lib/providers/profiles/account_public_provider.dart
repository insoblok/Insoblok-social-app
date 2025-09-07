import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
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
    _mediaPickerService = locator<MediaPickerService>();
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
        var desc = await AIHelpers.goToDescriptionView(context);
        if (desc != null) {
          account = account.copyWith(desc: desc);
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
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
          context,
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
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  void onClickUpdateProfile() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (selectedFile != null) {
          MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(XFile(selectedFile!.path));
          account = account.copyWith(discovery: model.link);
        }
        await AuthHelper.updateUser(account);
        AIHelpers.showToast(msg: 'Successfully updated user profile!');
        Navigator.of(context).pop(account);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
