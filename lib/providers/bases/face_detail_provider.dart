import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle, Uint8List, ByteData;
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/cloudinary_cdn_service.dart';
import 'package:share_plus/share_plus.dart';

class FaceDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late String _url;
  String get url => _url;
  set url(String f) {
    _url = f;
    notifyListeners();
  }

  File? _face;
  File? get face => _face;
  set face(File? f) {
    _face = f;
    notifyListeners();
  }

  File? _hypeFace;
  File? get hypeFace => _hypeFace;
  set hypeFace(File? f) {
    _hypeFace = f;
    notifyListeners();
  }

  String? _storyID;
  String? get storyID => _storyID;
  set storyID(String? model) {
    _storyID = model;
    notifyListeners();
  }

  StoryModel? _story;
  StoryModel? get story => _story;
  set story(StoryModel? model) {
    _story = model;
    notifyListeners();
  }

  bool _showFaceDialog = true;
  bool get showFaceDialog => _showFaceDialog;
  set showFaceDialog(bool f) {
    _showFaceDialog = f;
    notifyListeners();
  }

  bool _editable = true;
  bool get editable => _editable;
  set editable(bool f) {
    _editable = f;
    notifyListeners();
  }

  String? _resultHypeFaceUrl;
  String? get resultHypeFaceUrl => _resultHypeFaceUrl;
  set resultHypeFaceUrl(String? s) {
    _resultHypeFaceUrl = s;
    notifyListeners();
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;
  set pageIndex(int i) {
    _pageIndex = i;
    notifyListeners();
  }

  String? _cdnUploadId;
  String? get cdnUploadId => _cdnUploadId;
  set cdnUploadId(String? s) {
    _cdnUploadId = s;
    notifyListeners();
  }

  List<AIFaceAnnotation> annotations = [];

  Future<void> init(BuildContext context, {required String storyID, required String url, required File face, required List<AIFaceAnnotation> annotations, required bool editable}) async {
    this.context = context;
    this.url = url;
    this.storyID = storyID;
    
    // final directory = await getApplicationDocumentsDirectory();
    // final filePath = '${directory.path}/face_mickle.png';
    // this.face = File(filePath);

    this.annotations = annotations;
    this.editable = editable;

    this.face = face;  
    if(this.editable){
      hypeFace = face;
    }else{
      setHypeImage();
    }
    
    logger.d("face annotations : $annotations");
    logger.d("face : $face");
  }

  Future<void> setHypeImage() async{
    // Pick the top annotation (largest %), get its icon string and % however you compute them:
    final top = bestAnnotationByPercent(annotations);
    final hypePct = _annotationPercent(top!); // 0..100
    final iconSrc = (top.icon is String) ? top.icon as String : null;

    final userName =  AuthHelper.user?.nickId;
    // Build hype bytes then save to a file and set hypeFace
    final bytes = await composeHypeImage(
      backgroundUrl: face!.path,         // file path to the cropped face
      userName: userName!,           // whatever name you want rendered
      iconSource: iconSrc,               // asset/file/url for the annotation icon
      hypePercent: hypePct,
    );

    if (bytes != null) {
      final dir = await getApplicationDocumentsDirectory();
      final out = File('${dir.path}/hype_${DateTime.now().millisecondsSinceEpoch}.png');
      await out.writeAsBytes(bytes);
      hypeFace = out;
    }

  }
  
  /// Returns the annotation whose `desc` contains the highest % value.
/// If none contain a %, returns null.
AIFaceAnnotation? bestAnnotationByPercent(List<AIFaceAnnotation> items) {
  AIFaceAnnotation? best;
  double bestPct = -1;

  for (final a in items) {
    final pct = _annotationPercent(a);
    if (pct > bestPct) {
      bestPct = pct;
      best = a;
    }
  }
  return best;
}

/// Pull a % out of the annotation. We look in `desc` first, then `title`.
double _annotationPercent(AIFaceAnnotation a) {
  // Safely coerce to string; your model likely has String? fields.
  final desc = (a.desc ?? '').toString();
  final title = (a.title ?? '').toString();

  // Try “85%” or “85.5%” first
  final p1 = _extractPercent(desc);
  if (p1 != null) return p1;

  // Fallback: maybe the number is present without the % symbol
  final p2 = _extractPercentLoose(desc);
  if (p2 != null) return p2;

  // Last resort: check title
  final p3 = _extractPercent(title) ?? _extractPercentLoose(title);
  return p3 ?? 0.0;
}

/// Strict: finds numbers followed by % (e.g., "83%" or "83.5%")
double? _extractPercent(String? text) {
  if (text == null || text.isEmpty) return null;
  final m = RegExp(r'(\d+(?:\.\d+)?)\s*%').firstMatch(text);
  if (m == null) return null;
  final v = double.tryParse(m.group(1)!);
  if (v == null) return null;
  return v.clamp(0, 100).toDouble();
}

  /// Loose: if there's a plain number, treat 0–1 as 0–100% and clamp to 0–100.
double? _extractPercentLoose(String? text) {
  if (text == null || text.isEmpty) return null;
  final m = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(text);
  if (m == null) return null;
  final v = double.tryParse(m.group(1)!);
  if (v == null) return null;
  final pct = v <= 1.0 ? v * 100.0 : v;
  return pct.clamp(0, 100).toDouble();
}


Future<Uint8List?> composeHypeImage({
    required String backgroundUrl,
    required String userName,
    String? iconSource,
    double hypePercent = 0.0,
    Color bannerColor = const Color(0xB3000000),  // semi-transparent black
    Color userTextColor = Colors.white,
    Color hypeTextColor = const Color(0xFFFF69B4), // hot pink
  }) async {
    try {
      // 1) Load background (face)
      final bgBytes = await _loadBytesAny(backgroundUrl);
      if (bgBytes == null) return null;

      final ui.Image bgImage = await _decodeImageFromList(bgBytes);
      final int bgWidth = bgImage.width;
      final int bgHeight = bgImage.height;

      // 2) Layout constants
      final double pad = 20.0;
      double iconSize = (bgWidth * 0.22).clamp(64.0, 260.0);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, bgWidth.toDouble(), bgHeight.toDouble()),
      );
      final paint = Paint();

      // 3) Draw background
      canvas.drawImage(bgImage, Offset.zero, paint);

      // 4) Optional: draw top-left circular icon with white ring
      if (iconSource != null && iconSource.isNotEmpty) {
        final iconBytes = await _loadBytesAny(iconSource);
        if (iconBytes != null) {
          final ui.Image iconImg = await _decodeImageFromList(iconBytes);

          final src = Rect.fromLTWH(
            0, 0, iconImg.width.toDouble(), iconImg.height.toDouble(),
          );
          final dst = Rect.fromLTWH(pad, pad, iconSize, iconSize);

          // circle clip + image
          canvas.save();
          final circle = Path()..addOval(dst);
          canvas.clipPath(circle);
          canvas.drawImageRect(iconImg, src, dst, paint);
          canvas.restore();

          // white border ring
          final ring = Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.white
            ..strokeWidth = iconSize * 0.06;
          canvas.drawOval(dst, ring);
        }
      }

      // 5) Bottom banner + text (username + Hype xx%)
      final double bannerH = (bgHeight * 0.22).clamp(64.0, 220.0).toDouble();
      final double bannerTop = bgHeight - bannerH;

      // rounded banner
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, bannerTop, bgWidth.toDouble(), bannerH),
        const Radius.circular(18),
      );
      final bannerPaint = Paint()..color = bannerColor;
      canvas.drawRRect(rrect, bannerPaint);

      // Text helpers
      Future<void> drawText({
        required String text,
        required double x,
        required double y,
        required double size,
        required Color color,
        FontWeight weight = FontWeight.w600,
        double maxWidth = double.infinity,
      }) async {
        final pb = ui.ParagraphBuilder(ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: size,
          fontWeight: weight,
          maxLines: 1,
          ellipsis: '…',
        ))
          ..pushStyle(ui.TextStyle(color: color))
          ..addText(text);
        final p = pb.build()..layout(
          ui.ParagraphConstraints(width: maxWidth),
        );
        canvas.drawParagraph(p, Offset(x, y));
      }

      final double textLeft = pad + 4;
      final double line1Y = bannerTop + 14;     // username
      final double line2Y = line1Y + 30;        // hype label
      final double textWidth = bgWidth - textLeft - pad;

      await drawText(
        text: userName,
        x: textLeft,
        y: line1Y,
        size: 24,
        color: userTextColor,
        maxWidth: textWidth,
      );

      final hype = 'Hype ${hypePercent.toStringAsFixed(0)}%';
      await drawText(
        text: hype,
        x: textLeft,
        y: line2Y,
        size: 22,
        color: hypeTextColor,
        maxWidth: textWidth,
        weight: FontWeight.w700,
      );

      // 6) Finalize
      final picture = recorder.endRecording();
      final ui.Image out = await picture.toImage(bgWidth, bgHeight);
      final ByteData? png = await out.toByteData(format: ui.ImageByteFormat.png);
      return png?.buffer.asUint8List();
    } catch (e, st) {
      logger.e('composeHypeImage error: $e\n$st');
      return null;
    }
  }

  
  Future<Uint8List?> _loadBytesAny(String src) async {
    try {
      // http/https URL
      if (src.startsWith('http')) {
        return await _downloadBytes(src); // you already have this
      }
      // explicit file://
      if (src.startsWith('file://')) {
        return await File(src.substring(7)).readAsBytes();
      }
      // plain file path
      final f = File(src);
      if (await f.exists()) {
        return await f.readAsBytes();
      }
      // asset path
      final bd = await rootBundle.load(src);
      return bd.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<ui.Image> _decodeImageFromList(Uint8List bytes) async {
    final c = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (img) => c.complete(img));
    return c.future;
  }

  Future<Uint8List?> _downloadBytes(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) return res.bodyBytes;
      logger.e('Failed to download $url status=${res.statusCode}');
      return null;
    } catch (e) {
      logger.e('Download error $e for $url');
      return null;
    }
  }

  Future<void> detectFace(String link) async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var faces = await GoogleVisionHelper.getFacesFromImage(link: link);
        annotations.clear();
        annotations.addAll(await GoogleVisionHelper.analyzeImage(link: link));

        if (faces.isNotEmpty) {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/face.png';
          final file = File(filePath);
          if (!file.existsSync()) {
            await file.create();
          }
          _face = await file.writeAsBytes(img.encodePng(faces[0]));
          notifyListeners();
        }
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }
    }());
  }

  Future<void> onClickActionButton(int index) async {
    if (isBusy) return;

    switch (index) {
      case 0:
        await repost();
        break;
      case 1:
        await postAsReaction();
        break;
      case 2:
        await saveToGallery();
        break;
    }
  }

  Future<void> saveToGallery() async {
    if (isBusy) return;
    clearErrors();

    setBusy(true);
    notifyListeners();
    String link = "";

    try {
      if(cdnUploadId == null){
        MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(XFile(hypeFace!.path));
        cdnUploadId = model.publicId;
        link = model.link!;
      }

      // 2qgkVmXyECgjlhr933nX
      logger.d("face detail user id");
      final usersRef = FirebaseFirestore.instance.collection("user");
      await usersRef.doc(AuthHelper.user?.id).update({
        "galleries": FieldValue.arrayUnion([link]),
      });

      AIHelpers.showToast(msg: 'Successfully saved to Gallery!');
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> postAsReaction() async {
    if (isBusy) return;
    clearErrors();

    setBusy(true);
    notifyListeners();

    String url = "";
    try {

      if(cdnUploadId == null) {
        MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(XFile(hypeFace!.path));
        cdnUploadId = model.publicId;
        url = model.link!;
      }

      final storiesRef = FirebaseFirestore.instance.collection("story");
        await storiesRef.doc(storyID).update({
          "reactions": FieldValue.arrayUnion([url]),
        });

      AIHelpers.showToast(msg: 'Successfully posted as Reaction!');

    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> repost() async {
    if (isBusy) return;
    clearErrors();

    String link = "";

    await runBusyFuture(() async {
      try {
        var hasDescription = await _showDescriptionDialog();
        if (hasDescription != true) return;

        final description = await AIHelpers.goToDescriptionView(context);
        if (description == null || description.isEmpty) {
          throw ('empty description!');
        }

        if(cdnUploadId == null){
          MediaStoryModel model = await CloudinaryCDNService.uploadImageToCDN(XFile(hypeFace!.path));
          cdnUploadId = model.publicId;
          link = model.link!;
        }
        

        MediaStoryModel? media;
        var bytes = await File(hypeFace!.path).readAsBytes();
        var decodedImage = img.decodeImage(bytes);

        media = MediaStoryModel(
          link: link,
          type: 'image',
          width: decodedImage?.width.toDouble(),
          height: decodedImage?.height.toDouble(),
        );

        var newStory = StoryModel(
          title: 'Repost',
          text: description,
          status: 'private',
          category: 'vote',
          medias: media != null ? [media] : [],
          updateDate: DateTime.now(),
          timestamp: DateTime.now(),
        );

        await storyService.postStory(story: newStory);

        if (story != null) {
          await tastScoreService.repostScore(story!);
        }

        logger.d("newStory: $newStory");
        AIHelpers.showToast(msg: 'Successfully reposted to LOOKBOOK!');
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

  Future<bool?> _showDescriptionDialog() => showDialog<bool>(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                'Do you want to post this reaction to your LOOKBOOK?',
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
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
                          'Skip',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
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
