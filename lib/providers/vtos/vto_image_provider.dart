import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:insoblok/locator.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
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

  final List<UserCountryModel> _countries = [];
  List<UserCountryModel> get countries => _countries;

  void init(BuildContext context, {required ProductModel p}) async {
    this.context = context;

    product = p;
    _mediaPickerService = locator<MediaPickerService>();

    final String response = await rootBundle.loadString(
      'assets/data/country.json',
    );
    final data = await json.decode(response);
    _countries.addAll((data as List).map((d) => UserCountryModel.fromJson(d)));

    notifyListeners();
  }

  UserCountryModel? _selectedCountry;
  UserCountryModel? get selectedCountry => _selectedCountry;
  set selectedCountry(UserCountryModel? c) {
    _selectedCountry = c;
    notifyListeners();
  }

  String? _gender;
  String? get gender => _gender;
  set gender(String? s) {
    _gender = s;
    notifyListeners();
  }

  int? _age;
  int? get age => _age;
  set age(int? i) {
    _age = i;
    notifyListeners();
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

  var textController = TextEditingController();

  String? _content;
  String? get content => _content;
  set content(String? s) {
    _content = s;
    notifyListeners();
  }

  StoryModel? _storyAddedToLookbook;
  StoryModel? get storyAddedToLookbook => _storyAddedToLookbook;
  set storyAddedToLookbook(StoryModel? s) {
    _storyAddedToLookbook = s;
    notifyListeners();
  }

  Future<void> onClickAddPhoto() async {
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
    logger.d("product : $product");

    if (product.category == ProductCategory.CLOTHING) {
      if (product.categoryName == "Hat/Cap") {
        await _productToModelConvert();
      } else {
        await _clothingConvert();
      }
    } else if (product.category == ProductCategory.SHOES) {
      await _productToModelConvert();
    } else if (product.category == ProductCategory.JEWELRY) {
      if (product.categoryName == "Sunglasses") {
        await _productToModelConvert();
      } else {
        await _jewelryConvert();
      }
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
        if (originUrl?.isEmpty ?? true) {
          MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(
            XFile(selectedFile!.path),
          );
          originUrl = model.link;
        }

        if (originUrl?.isEmpty ?? true) {
          throw ('Failed origin image uploaded!');
        }

        var resultUrl = await vtoService.convertVTOClothing(
          modelUrl: originUrl!,
          photoUrl: product.modelImage,
          type: product.type ?? 'tops',
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

        final MediaStoryModel resultModel =
            await CloudinaryCDNService.uploadImageToCDN(
              XFile(_resultFile!.path),
            );

        if (resultModel.link != null) {
          serverUrl = resultModel.link;

          List<MediaStoryModel> medias = [];
          medias.addAll(product.medias ?? []);

          if (!medias.map((m) => m.link).toList().contains(serverUrl)) {
            medias.insert(0, MediaStoryModel(link: serverUrl, type: 'image'));
            logger.d(medias.length);
            product = product.copyWith(
              medias: medias,
              updateDate: DateTime.now(),
            );
            await productService.updateProduct(
              id: product.id!,
              product: product,
            );

            var originImgbytes = await File(_selectedFile!.path).readAsBytes();
            var originDecodedImage = img.decodeImage(originImgbytes);

            var resultImgbytes = await File(_resultFile!.path).readAsBytes();
            var resultDecodedImage = img.decodeImage(resultImgbytes);

            await Routers.goToVTODetailPage(
              context,
              VTODetailPageModel(
                product: product,
                originImage: originUrl!,
                originImgWidth: originDecodedImage?.width.toDouble(),
                originImgHeight: originDecodedImage?.height.toDouble(),
                resultImage: serverUrl!,
                resultImgWidth: resultDecodedImage?.width.toDouble(),
                resultImgHeight: resultDecodedImage?.height.toDouble(),
              ),
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
        isConverting = true;
        if (originUrl?.isEmpty ?? true) {
          final MediaStoryModel selectedModel =
              await CloudinaryCDNService.uploadImageToCDN(
                XFile(selectedFile!.path),
              );
          originUrl = selectedModel.link;
        }

        logger.d(originUrl);
        logger.d(product.modelImage);

        if (originUrl?.isEmpty ?? true) {
          throw ('Failed origin image uploaded!');
        }

        var resultUrl = await vtoService.convertVTOShoes(
          model: originUrl!,
          shoesModel: product.modelImage!,
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

        final MediaStoryModel model =
            await CloudinaryCDNService.uploadImageToCDN(
              XFile(_resultFile!.path),
            );

        if (model.link != null) {
          serverUrl = model.link;

          List<MediaStoryModel> medias = [];
          medias.addAll(product.medias ?? []);

          if (!medias.map((m) => m.link).toList().contains(serverUrl)) {
            medias.insert(0, MediaStoryModel(link: serverUrl, type: 'image'));
            logger.d(medias.length);
            product = product.copyWith(
              medias: medias,
              updateDate: DateTime.now(),
            );
            await productService.updateProduct(
              id: product.id!,
              product: product,
            );

            var originImgbytes = await File(_selectedFile!.path).readAsBytes();
            var originDecodedImage = img.decodeImage(originImgbytes);

            var resultImgbytes = await File(_resultFile!.path).readAsBytes();
            var resultDecodedImage = img.decodeImage(resultImgbytes);

            await Routers.goToVTODetailPage(
              context,
              VTODetailPageModel(
                product: product,
                originImage: originUrl!,
                originImgWidth: originDecodedImage?.width.toDouble(),
                originImgHeight: originDecodedImage?.height.toDouble(),
                resultImage: serverUrl!,
                resultImgWidth: resultDecodedImage?.width.toDouble(),
                resultImgHeight: resultDecodedImage?.height.toDouble(),
              ),
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

  Future<void> _jewelryConvert() async {
    if (isBusy) return;
    clearErrors();

    isConverting = true;
    await runBusyFuture(() async {
      try {
        var resultUrl = await vtoService.getVTOJewelryModelImage(
          modelUrl: product.modelImage!,
          type: product.type ?? 'ring',
          gender: gender,
          country: selectedCountry?.name,
          age: age == null ? null : '$age',
        );

        logger.d("resultUrl : $resultUrl");

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

        final MediaStoryModel model =
            await CloudinaryCDNService.uploadImageToCDN(
              XFile(_resultFile!.path),
            );

        if (model.link != null) {
          serverUrl = model.link;

          List<MediaStoryModel> medias = [];
          medias.addAll(product.medias ?? []);

          if (!medias.map((m) => m.link).toList().contains(serverUrl)) {
            medias.insert(0, MediaStoryModel(link: serverUrl, type: 'image'));
            logger.d(medias.length);
            product = product.copyWith(
              medias: medias,
              updateDate: DateTime.now(),
            );
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

  Future<void> _productToModelConvert() async {
    if (selectedFile == null) {
      AIHelpers.showToast(msg: 'Please select a origin photo!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        isConverting = true;
        if (originUrl?.isEmpty ?? true) {
          MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(
            XFile(selectedFile!.path),
          );
          originUrl = model.link;
        }

        if (originUrl?.isEmpty ?? true) {
          throw ('Failed origin image uploaded!');
        }

        var resultUrl = await vtoService.convertVTOGlasses(
          modelUrl: product.modelImage!,
          photoUrl: originUrl,
          type: product.type ?? 'tops',
        );

        logger.d("resultUrl in VTO: $resultUrl");
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

        final MediaStoryModel resultModel =
            await CloudinaryCDNService.uploadImageToCDN(
              XFile(_resultFile!.path),
            );

        if (resultModel.link != null) {
          serverUrl = resultModel.link;

          List<MediaStoryModel> medias = [];
          medias.addAll(product.medias ?? []);

          if (!medias.map((m) => m.link).toList().contains(serverUrl)) {
            medias.insert(0, MediaStoryModel(link: serverUrl, type: 'image'));
            logger.d(medias.length);
            product = product.copyWith(
              medias: medias,
              updateDate: DateTime.now(),
            );
            await productService.updateProduct(
              id: product.id!,
              product: product,
            );

            logger.d(medias.length);
            var originImgbytes = await File(_selectedFile!.path).readAsBytes();
            var originDecodedImage = img.decodeImage(originImgbytes);

            logger.d("resultDecodedImage");
            var resultImgbytes = await File(_resultFile!.path).readAsBytes();
            var resultDecodedImage = img.decodeImage(resultImgbytes);

            logger.d("goToVTODetailPage");
            await Routers.goToVTODetailPage(
              context,
              VTODetailPageModel(
                product: product,
                originImage: originUrl!,
                originImgWidth: originDecodedImage?.width.toDouble(),
                originImgHeight: originDecodedImage?.height.toDouble(),
                resultImage: serverUrl!,
                resultImgWidth: resultDecodedImage?.width.toDouble(),
                resultImgHeight: resultDecodedImage?.height.toDouble(),
              ),
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
}
