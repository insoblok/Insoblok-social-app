import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VTOImageProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late MediaPickerService _mediaPickerService;
  late ProductModel product;

  void init(BuildContext context, {required ProductModel p}) async {
    this.context = context;
    product = p;
    logger.d(p.toJson());
    _mediaPickerService = MediaPickerService(this.context);
  }

  int _tagIndex = 0;
  int get tagIndex => _tagIndex;
  set tagIndex(int i) {
    _tagIndex = i;
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
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  bool _isConverting = false;
  bool get isConverting => _isConverting;
  set isConverting(bool f) {
    _isConverting = f;
    notifyListeners();
  }

  void onClickCloseButton() {
    selectedFile = null;
    notifyListeners();
  }

  Future<void> onClickConvert() async {
    if (product.category == ProductCategory.CLOTHING) {
      await _clothingConvert();
    } else if (product.category == ProductCategory.SHOES) {
      await _shoesConvert();
    } else if (product.category == ProductCategory.JEWELRY) {
      await _jewelryConvert();
    } else {
      AIHelpers.showToast(msg: 'No support this feature yet!');
    }
  }

  String? _originUrl;
  String? get originUrl => _originUrl;
  set originUrl(String? s) {
    _originUrl = s;
    notifyListeners();
  }

  File? _resultFile;

  String? _serverUrl;
  String? get serverUrl => _serverUrl;
  set serverUrl(String? s) {
    _serverUrl = s;
    notifyListeners();
  }

  Future<void> _clothingConvert() async {
    if (selectedFile == null) {
      AIHelpers.showToast(msg: 'Please select a origin photo!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        isConverting = true;
        originUrl = await FirebaseHelper.uploadFile(
          file: File(selectedFile!.path),
          folderName: product.categoryName?.toLowerCase() ?? 'clothing',
        );

        if (originUrl == null) {
          throw ('Failed origin image uploaded!');
        }

        var resultUrl = await VTOService.convertVTOClothing(
          modelUrl: originUrl!,
          clothingLink: product.modelImage,
          clothingType: product.type ?? 'tops',
        );
        if (resultUrl == null) {
          throw ('Failed AI Convertor!');
        }

        _resultFile = await NetworkHelper.downloadFile(
          resultUrl,
          type: 'gallery',
          ext: 'png',
        );
        if (_resultFile == null) {
          throw ('Failed result file downloaded!');
        }

        var path = await FirebaseHelper.uploadFile(
          file: _resultFile!,
          folderName: 'gallery',
        );

        if (path != null) {
          serverUrl = path;

          List<MediaStoryModel> medias = [];
          medias.addAll(product.medias ?? []);

          if (!medias.map((m) => m.link).toList().contains(serverUrl)) {
            medias.insert(0, MediaStoryModel(link: serverUrl, type: 'image'));
            logger.d(medias.length);
            product = product.copyWith(medias: medias);
            await productService.updateProduct(
              id: product.id!,
              product: product,
            );
          }
        } else {
          throw ('Failed server error!');
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isConverting = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> _shoesConvert() async {
    if (selectedFile == null) {
      AIHelpers.showToast(msg: 'Please select a model photo!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // isConverting = true;
        // var result = await VTOService.convertVTOClothing(
        //   path: selectedFile!.path,
        //   clothingLink: product.modelImage,
        //   clothingType: product.type ?? 'tops',
        //   folderName: product.categoryName?.toLowerCase() ?? 'clothing',
        // );
        // if (result != null) {
        //   resultModel = result;
        // }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isConverting = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> _jewelryConvert() async {
    if (selectedFile == null) {
      AIHelpers.showToast(msg: 'Please select a model photo!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // isConverting = true;
        // var result = await VTOService.convertVTOClothing(
        //   path: selectedFile!.path,
        //   clothingLink: product.modelImage,
        //   clothingType: product.type ?? 'tops',
        //   folderName: product.categoryName?.toLowerCase() ?? 'clothing',
        // );
        // if (result != null) {
        //   resultModel = result;
        // }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isConverting = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  final _productService = ProductService();
  ProductService get productService => _productService;

  Future<void> onClickShareButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await AIHelpers.shareFileToSocial(_resultFile!.path);
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

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  Future<void> savetoLookBook() async {
    if (isBusy) return;
    clearErrors();

    isConverting = true;

    await runBusyFuture(() async {
      try {
        var story = StoryModel(
          title: 'Virtual Try-On',
          text: 'Virtual Try-On',
          medias: [
            MediaStoryModel(link: originUrl!, type: 'image'),
            MediaStoryModel(link: serverUrl, type: 'image'),
          ],
        );
        await storyService.postStory(story: story);

        AIHelpers.showToast(msg: 'Successfully posted VTO to Lookbook!');
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        isConverting = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }
}
