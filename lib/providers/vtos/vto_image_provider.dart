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
  late RunwareService _runwareService;

  final List<UserCountryModel> _countries = [];
  List<UserCountryModel> get countries => _countries;

  final List<ProductModel> _marketplaceProducts = [];
  List<ProductModel> get marketplaceProducts => _marketplaceProducts;

  int? _selectedMarketplaceModelIndex;
  int? get selectedMarketplaceModelIndex => _selectedMarketplaceModelIndex;
  set selectedMarketplaceModelIndex(int? index) {
    if (index != null && index >= 0 && index < _marketplaceProducts.length) {
      // If selecting a different model after video is generated, reset the workflow
      final wasDifferentModel =
          _selectedMarketplaceModelIndex != null &&
          _selectedMarketplaceModelIndex != index;
      final hadVideo =
          generatedVideoUrl != null && generatedVideoUrl!.isNotEmpty;

      if (wasDifferentModel && hadVideo) {
        // Reset video and result to restart workflow
        generatedVideoUrl = null;
        serverUrl = null;
        logger.d('Model changed - resetting VTO workflow');
      }

      _selectedMarketplaceModelIndex = index;
      // Update the product to the selected marketplace product
      product = _marketplaceProducts[index];
      notifyListeners();
    } else if (index == null) {
      _selectedMarketplaceModelIndex = null;
      notifyListeners();
    }
  }

  ProductModel? get selectedMarketplaceProduct {
    if (_selectedMarketplaceModelIndex != null &&
        _selectedMarketplaceModelIndex! >= 0 &&
        _selectedMarketplaceModelIndex! < _marketplaceProducts.length) {
      return _marketplaceProducts[_selectedMarketplaceModelIndex!];
    }
    return null;
  }

  void init(BuildContext context, {required ProductModel p}) async {
    this.context = context;

    product = p;
    _mediaPickerService = locator<MediaPickerService>();
    _runwareService = locator<RunwareService>();

    final String response = await rootBundle.loadString(
      'assets/data/country.json',
    );
    final data = await json.decode(response);
    _countries.addAll((data as List).map((d) => UserCountryModel.fromJson(d)));

    // Fetch marketplace products
    await fetchMarketplaceProducts();

    notifyListeners();
  }

  Future<void> fetchMarketplaceProducts() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var products = await productService.getProducts();
        if (products.isNotEmpty) {
          _marketplaceProducts.clear();
          // Filter products that have modelImage
          _marketplaceProducts.addAll(
            products.where(
              (p) => p.modelImage != null && p.modelImage!.isNotEmpty,
            ),
          );
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  /// Get the video generation prompt based on product category and type
  ///
  /// Mapping:
  /// - Shirt -> "pose"
  /// - Pants -> "ramp walk"
  /// - Hat/Cap -> "head move and smile"
  /// - Cowboy Boots/Shoes -> "ramp walk"
  /// - Sunglasses -> "head move and smile"
  /// - Skirt -> "pose"
  /// - Lady Top -> "pose"
  /// - Bikini -> "pose"
  String _getVideoPromptForProduct(ProductModel product) {
    final categoryName = product.categoryName?.toLowerCase() ?? '';
    final type = product.type?.toLowerCase() ?? '';

    // Hat/Cap - head move and smile (check first as it's most specific)
    if (categoryName.contains('hat') || categoryName.contains('cap')) {
      return 'head move and smile';
    }

    // Sunglasses - head move and smile
    if (categoryName.contains('sunglass')) {
      return 'head move and smile';
    }

    // Bikini - pose
    if (categoryName.contains('bikini') || type == 'one-pieces') {
      return 'pose';
    }

    // Skirt - pose
    if (categoryName.contains('skirt')) {
      return 'pose';
    }

    // Shirt/Shirts - pose
    if (categoryName.contains('shirt') ||
        (type == 'tops' && !categoryName.contains('dress'))) {
      return 'pose';
    }

    // Lady Top - pose (tops type)
    if (type == 'tops' && categoryName.contains('top')) {
      return 'pose';
    }

    // Pants/Trousers - ramp walk
    if (categoryName.contains('trouser') ||
        categoryName.contains('pant') ||
        (type == 'bottoms' && !categoryName.contains('skirt'))) {
      return 'ramp walk';
    }

    // Boots/Shoes - ramp walk
    if (categoryName.contains('boot') ||
        categoryName.contains('shoes') ||
        type == 'shoes') {
      return 'ramp walk';
    }

    // Default to pose if no match
    return 'pose';
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

  Future<void> postVideoToLookbook() async {
    if (isBusy) return;
    if (generatedVideoUrl == null || generatedVideoUrl!.isEmpty) {
      AIHelpers.showToast(msg: 'No video available to post');
      return;
    }
    clearErrors();

    await runBusyFuture(() async {
      try {
        var hasDescription = await AIHelpers.showDescriptionDialog(context);
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        var story = StoryModel(
          title: 'VTO',
          text: description ?? 'Vote to Earn – Vybe Virtual Try-On',
          category: 'vote',
          status: 'public',
          medias: [
            if (originUrl != null && originUrl!.isNotEmpty)
              MediaStoryModel(link: originUrl!, type: 'image'),
            if (serverUrl != null && serverUrl!.isNotEmpty)
              MediaStoryModel(link: serverUrl!, type: 'image'),
            MediaStoryModel(link: generatedVideoUrl!, type: 'video'),
          ],
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );

        final storyId = await storyService.postStory(story: story);
        AIHelpers.showToast(msg: 'Successfully posted VTO video to LOOKBOOK!');

        // Fetch the posted story and navigate to lookbook detail page
        final postedStory = await storyService.getStory(storyId);
        await Routers.goToLookbookDetailPage(context, postedStory);
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

  String? _generatedVideoUrl;
  String? get generatedVideoUrl => _generatedVideoUrl;
  set generatedVideoUrl(String? url) {
    _generatedVideoUrl = url;
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
          // Check if file exists before uploading
          final file = File(selectedFile!.path);
          if (!await file.exists()) {
            throw Exception('Selected file does not exist!');
          }

          // Check file size
          final fileSize = await file.length();
          logger.e(
            '📤 Uploading image, size: $fileSize bytes, path: ${selectedFile!.path}',
          );

          try {
            MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(
              XFile(selectedFile!.path),
            );

            // Log the model response for debugging
            logger.e(
              '✅ Upload response - link: ${model.link}, width: ${model.width}, height: ${model.height}',
            );

            // Check if upload was successful by verifying the link
            if (model.link == null || model.link!.isEmpty) {
              logger.e('❌ Upload failed: model.link is null or empty');
              throw Exception(
                'Failed to upload origin image to CDN. The upload completed but no URL was returned.',
              );
            }

            originUrl = model.link;
            logger.e('✅ Origin image uploaded successfully: $originUrl');
          } catch (uploadError) {
            logger.e('❌ Upload error caught: $uploadError');
            // Re-throw with a user-friendly message
            throw Exception(
              'Failed to upload origin image to CDN: ${uploadError.toString()}. Please check your internet connection and try again.',
            );
          }
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

            // Generate video from the VTO image
            try {
              logger.e('🎬 Starting video generation from VTO image...');
              final videoPrompt = _getVideoPromptForProduct(product);
              logger.e(
                '📝 Using prompt: "$videoPrompt" for product: ${product.categoryName} / ${product.type}',
              );

              final videoResult = await _runwareService
                  .generateAIEmotionVideoWithPrompt(
                    inputImage: serverUrl!,
                    positivePrompt: videoPrompt,
                  );

              if (videoResult['status'] == 'success' &&
                  videoResult['videoURL'] != null &&
                  videoResult['videoURL'].toString().isNotEmpty) {
                final originalVideoUrl = videoResult['videoURL'] as String;
                logger.e('✅ Video generated successfully: $originalVideoUrl');

                // Upload the generated video to bunny.net
                try {
                  logger.d('📤 Uploading generated video to bunny.net...');
                  final uploadResult =
                      await BunnyNetCDNService.uploadVideoFromUrl(
                        originalVideoUrl,
                      );

                  if (uploadResult.link != null &&
                      uploadResult.link!.isNotEmpty) {
                    generatedVideoUrl = uploadResult.link!;
                    logger.e(
                      '✅ Video uploaded to bunny.net: $generatedVideoUrl',
                    );
                  } else {
                    // If upload fails, use original URL as fallback
                    logger.w(
                      '⚠️ Failed to upload video to bunny.net, using original URL',
                    );
                    generatedVideoUrl = originalVideoUrl;
                  }
                } catch (uploadError) {
                  logger.e(
                    '❌ Error uploading video to bunny.net: $uploadError',
                  );
                  // Use original URL as fallback if upload fails
                  generatedVideoUrl = originalVideoUrl;
                }
              } else {
                logger.e(
                  '⚠️ Video generation failed: ${videoResult['message'] ?? 'Unknown error'}',
                );
              }
            } catch (videoError) {
              logger.e('❌ Error generating video: $videoError');
              // Continue even if video generation fails - image is still available
            }

            product = product.copyWith(
              medias: medias,
              updateDate: DateTime.now(),
            );
            await productService.updateProduct(
              id: product.id!,
              product: product,
            );

            // Navigate to detail page with video if generated, otherwise with image
            var originImgbytes = await File(selectedFile!.path).readAsBytes();
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
                resultVideo: generatedVideoUrl, // Pass the generated video URL
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

            // Generate video from the VTO image (for glasses, hats, shoes, etc.)
            try {
              logger.e('🎬 Starting video generation from VTO image...');
              final videoPrompt = _getVideoPromptForProduct(product);
              logger.e(
                '📝 Using prompt: "$videoPrompt" for product: ${product.categoryName} / ${product.type}',
              );

              final videoResult = await _runwareService
                  .generateAIEmotionVideoWithPrompt(
                    inputImage: serverUrl!,
                    positivePrompt: videoPrompt,
                  );

              if (videoResult['status'] == 'success' &&
                  videoResult['videoURL'] != null &&
                  videoResult['videoURL'].toString().isNotEmpty) {
                final originalVideoUrl = videoResult['videoURL'] as String;
                logger.e('✅ Video generated successfully: $originalVideoUrl');

                // Upload the generated video to bunny.net
                try {
                  logger.d('📤 Uploading generated video to bunny.net...');
                  final uploadResult =
                      await BunnyNetCDNService.uploadVideoFromUrl(
                        originalVideoUrl,
                      );

                  if (uploadResult.link != null &&
                      uploadResult.link!.isNotEmpty) {
                    generatedVideoUrl = uploadResult.link!;
                    logger.e(
                      '✅ Video uploaded to bunny.net: $generatedVideoUrl',
                    );
                  } else {
                    // If upload fails, use original URL as fallback
                    logger.w(
                      '⚠️ Failed to upload video to bunny.net, using original URL',
                    );
                    generatedVideoUrl = originalVideoUrl;
                  }
                } catch (uploadError) {
                  logger.e(
                    '❌ Error uploading video to bunny.net: $uploadError',
                  );
                  // Use original URL as fallback if upload fails
                  generatedVideoUrl = originalVideoUrl;
                }
              } else {
                logger.e(
                  '⚠️ Video generation failed: ${videoResult['message'] ?? 'Unknown error'}',
                );
              }
            } catch (videoError) {
              logger.e('❌ Error generating video: $videoError');
              // Continue even if video generation fails - image is still available
            }

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
                resultVideo: generatedVideoUrl, // Pass the generated video URL
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
