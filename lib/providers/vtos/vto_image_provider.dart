import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

import 'package:insoblok/models/models.dart';
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
    _mediaPickerService = MediaPickerService(this.context);

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

  Future<void> savetoLookBook() async {
    if (isBusy) return;
    clearErrors();

    isConverting = true;

    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        var story = StoryModel(
          title: 'VTO',
          text: description ?? 'Virtual Try-On',
          category: 'vote',
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

  Future<bool?> _showDescriptionDialog() => showDialog<bool>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Description',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Do you just want to add a description for LookBook post?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24.0),
              Row(
                spacing: 24.0,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Add',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 44.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Skip',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
