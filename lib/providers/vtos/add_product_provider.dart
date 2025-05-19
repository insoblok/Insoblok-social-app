import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AddProductProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  ProductModel _product = ProductModel();
  ProductModel get product => _product;

  late MediaPickerService _mediaPicker;

  Future<void> init(BuildContext context) async {
    this.context = context;
    _mediaPicker = MediaPickerService(context);
  }

  void updateName(String s) {
    _product = product.copyWith(name: s);
    notifyListeners();
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
          _product = product.copyWith(description: converter.convert());
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

  String _selectedTag = '';
  String get selectedTag => _selectedTag;
  set selectedTag(String s) {
    _selectedTag = s;
    notifyListeners();
  }

  void addTag() {
    if (selectedTag.isEmpty) {
      Fluttertoast.showToast(msg: 'Tag name should be not empty!');
      return;
    }
    var list = List<String>.from(product.tags ?? []);
    if (list.contains(selectedTag)) {
      Fluttertoast.showToast(msg: 'Tag name already added empty!');
      return;
    }
    if (selectedTag.length > 15) {
      Fluttertoast.showToast(msg: 'Tag name can\'t be over 15 characters!');
      return;
    }
    list.add(selectedTag);
    _product = product.copyWith(tags: list);
    notifyListeners();
  }

  void removeTag(int i) {
    var list = List<String>.from(product.tags ?? []);
    list.removeAt(i);
    _product = product.copyWith(tags: list);
    notifyListeners();
  }

  XFile? _avatarImage;
  XFile? get avatarImage => _avatarImage;
  set avatarImage(XFile? img) {
    _avatarImage = img;
    notifyListeners();
  }

  XFile? _modelImage;
  XFile? get modelImage => _modelImage;
  set modelImage(XFile? img) {
    _modelImage = img;
    notifyListeners();
  }

  Future<void> selectProductImage({bool? isImage}) async {
    var image = await _mediaPicker.onPickerSingleMedia(
      isImage: isImage ?? true,
    );
    if (image != null) {
      avatarImage = image;
    }
    notifyListeners();
  }

  Future<void> selectModelImage({bool? isImage}) async {
    var image = await _mediaPicker.onPickerSingleMedia(
      isImage: isImage ?? true,
    );
    if (image != null) {
      image = modelImage;
    }
    notifyListeners();
  }
}
