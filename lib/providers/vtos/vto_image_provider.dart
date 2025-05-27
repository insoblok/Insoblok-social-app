import 'dart:io';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
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
    _mediaPickerService = MediaPickerService(this.context);
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
      Fluttertoast.showToast(msg: 'No support this feature yet!');
    }
  }

  Future<void> _clothingConvert() async {
    if (selectedFile == null) {
      Fluttertoast.showToast(msg: 'Please select a origin photo!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        isConverting = true;
        var result = await VTOService.convertVTOClothing(
          path: selectedFile!.path,
          clothingLink: product.modelImage,
          clothingType: product.type ?? 'tops',
          folderName: product.categoryName?.toLowerCase() ?? 'clothing',
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

  Future<void> _shoesConvert() async {
    if (selectedFile == null) {
      Fluttertoast.showToast(msg: 'Please select a model photo!');
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
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<void> _jewelryConvert() async {
    if (selectedFile == null) {
      Fluttertoast.showToast(msg: 'Please select a model photo!');
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
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  File? _resultFile;

  Future<void> onClickDownloadButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (_resultFile == null) {
          var file = await NetworkHelper.downloadFile(
            resultModel,
            type: 'gallery',
            ext: 'png',
          );
          if (file != null) {
            Fluttertoast.showToast(
              msg: 'Successfully image download to ${file.path}!',
            );
            _resultFile = file;
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Successfully image download to ${_resultFile!.path}!',
          );
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

  Future<void> onClickUploadButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (_resultFile == null) {
          await onClickDownloadButton();
        }
        var path = await FirebaseHelper.uploadFile(
          file: _resultFile!,
          folderName: 'gallery',
        );
        if (path != null) {
          Fluttertoast.showToast(msg: 'Successfully image upload to server!');
        } else {
          setError('Failed server error!');
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

  Future<void> onClickShareButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (_resultFile == null) {
          await onClickDownloadButton();
        }
        await AIHelpers.shareFileToSocial(_resultFile!.path);
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

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  String _txtLookbookButton = '';
  String get txtLookbookButton => _txtLookbookButton;
  set txtLookbookButton(String s) {
    _txtLookbookButton = s;
    notifyListeners();
  }

  Future<void> savetoLookBook() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        if (_resultFile == null) {
          var file = await NetworkHelper.downloadFile(
            resultModel,
            type: 'gallery',
            ext: 'png',
          );
          if (file != null) {
            _resultFile = file;
          }
        }
        txtLookbookButton = 'Uploading Media...';
        var mediaUrl = await FirebaseHelper.uploadFile(
          file: _resultFile!,
          folderName: 'story',
        );
        if (mediaUrl != null) {
          txtLookbookButton = 'Adding to Server...';
          var story = StoryModel(
            title: 'Virtual Try-On',
            text: 'Virtual Try-On',
            medias: [MediaStoryModel(link: mediaUrl, type: 'image')],
          );
          await storyService.postStory(story: story);

          Fluttertoast.showToast(msg: 'Successfully posted VTO to Lookbook!');
        } else {
          setError('Failed file upload!');
        }
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        txtLookbookButton = '';
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }
}
