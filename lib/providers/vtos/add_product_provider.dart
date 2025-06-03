import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:insoblok/models/models.dart';
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
    _product = product.copyWith(category: kProductCategories[0]);
    _product = product.copyWith(type: kProductTypeNames[0]);
    _product = product.copyWith(categoryName: kProductCategoryNames[0]);

    _tribeCategories.addAll(await productService.getProductTypes());

    notifyListeners();
  }

  final List<ProductTribeCategoryModel> _tribeCategories = [];
  List<ProductTribeCategoryModel> get tribeCategories => _tribeCategories;

  final List<ProductSubtypeModel> _selectedTags = [];
  List<ProductSubtypeModel> get selectedTags => _selectedTags;
  void onTapTagItem(ProductSubtypeModel tag) {
    if (selectedTags.contains(tag)) {
      _selectedTags.remove(tag);
    } else {
      _selectedTags.add(tag);
    }
    notifyListeners();
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
        var desc = await AIHelpers.goToDescriptionView(context);
        if (desc != null) {
          _product = product.copyWith(description: desc);
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

  String _selectedCategory = kProductCategoryNames.first;
  String get selectedCategory => _selectedCategory;
  set selectedCategory(String s) {
    _selectedCategory = s;
    var index = kProductCategoryNames.indexOf(s);

    _product = product.copyWith(category: kProductCategories[index]);
    _product = product.copyWith(type: kProductTypeNames[index]);
    _product = product.copyWith(categoryName: kProductCategoryNames[index]);
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
    if (isBusy) return;
    clearErrors();

    var image = await _mediaPicker.onPickerSingleMedia(
      isImage: isImage ?? true,
    );
    if (image != null) {
      avatarImage = image;
    }
    notifyListeners();
  }

  Future<void> selectModelImage({bool? isImage}) async {
    if (isBusy) return;
    clearErrors();

    var image = await _mediaPicker.onPickerSingleMedia(
      isImage: isImage ?? true,
    );
    if (image != null) {
      modelImage = image;
    }
    notifyListeners();
  }

  bool _isUploading = false;
  bool get isUploading => _isUploading;
  set isUploading(bool f) {
    _isUploading = f;
    notifyListeners();
  }

  Future<void> onClickAddProduct() async {
    if (product.name?.isEmpty ?? true) {
      AIHelpers.showToast(msg: 'Product name should be not empty!');
      return;
    }
    if (product.description?.isEmpty ?? true) {
      AIHelpers.showToast(msg: 'Product description should be not empty!');
      return;
    }
    if (modelImage == null) {
      AIHelpers.showToast(msg: 'Model image should be not empty!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    isUploading = true;
    await runBusyFuture(() async {
      try {
        if (avatarImage != null) {
          var avatarLink = await FirebaseHelper.uploadFile(
            file: File(avatarImage!.path),
            folderName: 'product',
          );
          if (avatarLink != null) {
            _product = product.copyWith(avatarImage: avatarLink);
          }
        }
        if (selectedTags.isNotEmpty) {
          _product = product.copyWith(
            tags: selectedTags.map((tag) => tag.title ?? '').toList(),
          );
        }
        var modelLink = await FirebaseHelper.uploadFile(
          file: File(modelImage!.path),
          folderName: 'product',
        );

        if (modelLink != null) {
          _product = product.copyWith(modelImage: modelLink);
          await productService.addProduct(product: product);
          Navigator.of(context).pop(true);
        } else {
          setError('Failed server uploading!');
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isUploading = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
