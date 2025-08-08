import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class FacePostProvider extends InSoBlokViewModel {
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

  Future<void> init(BuildContext context, {required String url, required File face}) async {
    this.context = context;
    this.url = url;    
    // this.face = face;

    detectFace(url);
  }

  File? _face;
  File? get face => _face;
  set face(File? f) {
    _face = f;
    notifyListeners();
  }

  List<AIFaceAnnotation> annotations = [];

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
}
