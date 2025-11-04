import 'dart:io';
import 'dart:ui';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

final kReactionPostIconData = [
  {'title': 'Post to\nLookbook', 'icon': AIImages.icPostLookbook},
  {'title': 'Post to\nReaction', 'icon': AIImages.icPostReaction},
  {'title': 'Post to\nGallery', 'icon': AIImages.icGallery},
];

final kMediaDetailIconData = [
  {'title': 'Remix', 'icon': AIImages.icBottomLook},
  {'title': 'Repost', 'icon': AIImages.icRetwitter},
  // {'title': 'Boost', 'icon': AIImages.icMenuMoments},
  {'title': 'LookBook', 'icon': AIImages.icLookBook},
  {'title': 'Remove', 'icon': AIImages.icDelete},
];

final kRemixColorSet = {
  'white': Colors.white,
  'black': Colors.black,
  'red': Colors.red,
  'green': Colors.green,
  'blue': Colors.blue,
  'yellow': Colors.yellow,
  'puple': Colors.purple,
  'pink': Colors.pink,
  'amber': Colors.amber,
  'brown': Colors.brown,
  'cyan': Colors.cyan,
  'orange': Colors.orange,
};

class MediaDetailModel {
  final List<String> medias;
  final int index;
  final String storyID;
  final String storyUser;

  MediaDetailModel({
    required this.medias,
    required this.index,
    required this.storyID,
    required this.storyUser,
  });
}

class MediaDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  final controller = PageController();

  final List<String> _medias = [];
  List<String> get medias => _medias;

  String? _resultRemixImageUrl;
  String? get resultRemixImageUrl => _resultRemixImageUrl;
  set resultRemixImageUrl(String? s) {
    _resultRemixImageUrl = s;
    notifyListeners();
  }

  int _index = 0;
  int get index => _index;
  set index(int i) {
    _index = i;
    notifyListeners();
  }

  String _imgRemix = '';
  String get imgRemix => _imgRemix;
  set imgRemix(String s) {
    _imgRemix = s;
    notifyListeners();
  }

  String _remixKey = '';
  String get remixKey => _remixKey;
  set remixKey(String s) {
    _remixKey = s;
    notifyListeners();
  }

  String _storyID = '';
  String get storyID => _storyID;
  set storyID(String s) {
    _storyID = s;
    notifyListeners();
  }

  String _storyUser = '';
  String get storyUser => _storyUser;
  set storyUser(String s) {
    _storyUser = s;
    notifyListeners();
  }

  bool _isRemixing = false;
  bool get isRemixing => _isRemixing;
  set isRemixing(bool f) {
    _isRemixing = f;
    notifyListeners();
  }

  bool _isFeedDeleting = false;
  bool get isFeedDeleting => _isFeedDeleting;
  set isFeedDeleting(bool f) {
    _isFeedDeleting = f;
    notifyListeners();
  }

  bool _isPostingLookbook = false;
  bool get isPostingLookbook => _isPostingLookbook;
  set isPostingLookbook(bool f) {
    _isPostingLookbook = f;
    notifyListeners();
  }

  final List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ProductModel? _selectedProduct;
  ProductModel? get selectedProduct => _selectedProduct;
  set selectedProduct(ProductModel? m) {
    _selectedProduct = m;
    notifyListeners();
  }

  var globalkey = GlobalKey();

  bool _isRemixingDialog = false;
  bool get isRemixingDialog => _isRemixingDialog;
  set isRemixingDialog(bool f) {
    _isRemixingDialog = f;
    notifyListeners();
  }

  Future<void> init(
    BuildContext context, {
    required MediaDetailModel model,
  }) async {
    this.context = context;

    logger.d("model.medias: ${model.storyID}");
    logger.d("model info: $model");

    _medias.addAll(model.medias);
    _storyID = model.storyID;

    _storyUser = model.storyUser;
    index = model.index;

    Future.delayed(const Duration(milliseconds: 300), () {
      controller.jumpToPage(index);
    });

    fetchData();
  }

  Future<void> fetchData() async {
    // if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var ps = await productService.getProducts();

        if (ps.isNotEmpty) {
          final clothingOnly =
              ps.where((p) {
                final c = (p.category ?? '').toLowerCase().trim();
                return c == 'clothing';
              }).toList();

          _products
            ..clear()
            ..addAll(clothingOnly);
        }
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  void onClickActionButton(int index) {
    // if (isBusy) return;
    switch (index) {
      case 0:
        isRemixingDialog = true;
        break;
      case 1:
        onEventRepost();
        break;
      // case 2:
      //   onEventBoost();
      //   break;
      case 2:
        onEventLookBook();
        break;
      case 3:
        onDeleteFeed();
        break;
    }
  }

  Future<void> onEventRemix() async {
    if (remixKey.isEmpty && selectedProduct == null) return;

    if (isBusy) return;
    clearErrors();

    isRemixingDialog = false;
    isRemixing = true;

    String? resultVTO;
    String? resultColor;

    await runBusyFuture(() async {
      try {
        if (selectedProduct != null) {
          if (selectedProduct!.category == "Shoes") {
            resultVTO = await vtoService.convertVTOShoes(
              model: _medias[index],
              shoesModel: selectedProduct!.modelImage!,
            );
          } else {
            resultVTO = await vtoService.convertVTOClothing(
              modelUrl: _medias[index],
              photoUrl: selectedProduct!.modelImage!,
              type: selectedProduct!.type ?? 'tops',
            );
          }
        }
        if (remixKey.isNotEmpty) {
          resultColor = await NetworkUtil.getVTOEditImage(
            model: resultVTO ?? _medias[index],
            prompt: 'Change the garment color to $remixKey',
          );
        }

        imgRemix = resultColor ?? resultVTO!;

        await tastScoreService.remixScore();
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isRemixing = false;
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    }
  }

  Future<void> onEventRepost() async {
    await _saveToPost();
  }

  Future<void> onEventBoost() async {
    AIHelpers.showToast(msg: 'This feature will come soon!');
  }

  Future<void> onDeleteFeed() async {
    if (isBusy) return;
    clearErrors();

    _isFeedDeleting = true;

    await runBusyFuture(() async {
      try {
        var enableDelete = await _showDeleteDialog();
        if (enableDelete != true) return;

        if (storyID != '') {
          if (index < 0 || index >= _medias.length) return;

          int length = await FirebaseHelper.deleteMedias(storyID, index);

          if (length == 0) {
            await FirebaseHelper.deleteStory(storyID);
            _isFeedDeleting = false;
          }

          Routers.goToMainPage(context);
        } else {
          await FirebaseHelper.deleteGalleryImage(_medias[index]);

          if (index >= 0 && index < _medias.length) {
            _medias.removeAt(index);
          }
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        _isFeedDeleting = false;
        notifyListeners();
      }
    }());
  }

  Future<void> onEventLookBook() async {
    if (imgRemix.isEmpty) {
      AIHelpers.showToast(msg: 'You have not remix data yet!');
      return;
    }

    if (isBusy) return;
    clearErrors();

    isPostingLookbook = true;

    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();
        if (hasDescription != true) return;

        final description = await AIHelpers.goToDescriptionView(context);
        if (description == null || description.isEmpty) {
          throw ('empty description!');
        }

        var path = await _makeRemixImage();

        // resultRemixImageUrl = await storyService.uploadResult(
        //   path!,
        //   folderName: 'remix',
        //   postCategory: 'lookbook',
        //   storyID: null,
        // );

        MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(
          XFile(path!),
        );
        resultRemixImageUrl = model.link;

        MediaStoryModel? media;
        if (resultRemixImageUrl != null) {
          var bytes = await File(path!).readAsBytes();
          var decodedImage = img.decodeImage(bytes);

          media = MediaStoryModel(
            link: resultRemixImageUrl,
            type: 'image',
            width: decodedImage?.width.toDouble(),
            height: decodedImage?.height.toDouble(),
          );
        }

        var newStory = StoryModel(
          title: 'Repost',
          text: description,
          status: 'private',
          category: 'vote',
          medias: media != null ? [media] : [],
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );

        await storyService.postStory(story: newStory);

        AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');

        goToLookbookPage();
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        isPostingLookbook = false;
        notifyListeners();
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
                'Repost Story',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Do you want to post this feed to your LOOKBOOK?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24.0),
              Row(
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
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
                          'Cancel',
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

  Future<bool?> _showDeleteDialog() => showDialog<bool>(
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
                'Delete Feed',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Do you want to delete this feed?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 24.0),
              Row(
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
                          'Yes',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
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
                          'No',
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

  Future<void> _saveToPost() async {
    if (imgRemix.isEmpty) {
      AIHelpers.showToast(msg: 'You have not remix data yet!');
      return;
    }
    if (isBusy) return;
    clearErrors();

    isRemixing = true;

    await runBusyFuture(() async {
      try {
        var hasDescription = await AIHelpers.showDescriptionDialog(context);
        String? description;
        if (hasDescription == true) {
          description = await AIHelpers.goToDescriptionView(context);
        }

        var path = await _makeRemixImage();

        if (path == null) throw ('Something went wrong!');

        final MediaStoryModel model =
            await CloudinaryCDNService.uploadImageToCDN(XFile(path));

        var bytes = await File(path).readAsBytes();
        var decodedImage = img.decodeImage(bytes);

        var story = StoryModel(
          title: 'REMIX',
          text: description ?? 'Creating Remix Yay/Nay Poll...',
          category: 'vote',
          status: 'public',
          medias: [
            MediaStoryModel(
              link: model.link,
              type: 'image',
              width: decodedImage?.width.toDouble(),
              height: decodedImage?.height.toDouble(),
            ),
          ],
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        );
        await storyService.postStory(story: story);

        await tastScoreService.repostScore(story);
        AIHelpers.showToast(msg: 'Successfully posted Remix to Feed!');

        goToMainPage();
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        isRemixing = false;
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> goToMainPage() async {
    await Routers.goToMainPage(context);
  }

  Future<void> goToLookbookPage() async {
    await Routers.goToLookbookPage(context);
  }

  Future<String?> _makeRemixImage() async {
    var boundary =
        globalkey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      var image = await boundary.toImage();
      var byteData = await image.toByteData(format: ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();

      final directory = (await getApplicationDocumentsDirectory()).path;
      var imgFile = File('$directory/screenshot.png');
      await imgFile.writeAsBytes(pngBytes!);

      return imgFile.path;
    }

    return null;
  }
}
