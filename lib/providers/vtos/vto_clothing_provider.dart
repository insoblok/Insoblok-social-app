import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VTOClothingProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late MediaPickerService _mediaPickerService;
  void init(BuildContext context) async {
    this.context = context;
    _mediaPickerService = MediaPickerService(this.context);
  }

  String _photoModel = '';
  String get photoModel => _photoModel;
  set photoModel(String s) {
    _photoModel = s;
    notifyListeners();
  }

  XFile? _selectedFile;
  XFile? get selectedFile => _selectedFile;
  set selectedFile(XFile? f) {
    _selectedFile = f;
    notifyListeners();
  }

  Future<void> onClickAddPhoto() async {
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

  String _resultModel = '';
  String get resultModel => _resultModel;
  set resultModel(String s) {
    _resultModel = s;
    notifyListeners();
  }

  bool _isConverting = false;
  bool get isConverting => _isConverting;
  set isConverting(bool f) {
    _isConverting = f;
    notifyListeners();
  }

  Future<void> onClickConvert() async {
    if (selectedFile == null) {
      Fluttertoast.showToast(msg: 'Please select a model photo!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        isConverting = true;
        var result = await VTOService.convertVTOClothing(
          path: selectedFile!.path,
          clothingLink: kDefaultClothesModelLink,
        );
        if (result != null) {
          resultModel = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isConverting = false;
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
