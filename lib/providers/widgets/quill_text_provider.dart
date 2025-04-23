import 'dart:io' as io show Directory, File;

import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:path/path.dart' as path;

import 'package:insoblok/utils/utils.dart';

class QuillTextProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  QuillController? quillController;

  Future<void> init(BuildContext context) async {
    this.context = context;

    quillController = () {
      return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(
            enableExternalRichPaste: true,
            onImagePaste: (imageBytes) async {
              // stored in the Quill Delta JSON (the document).
              final newFileName =
                  'image-file-${DateTime.now().toIso8601String()}.png';
              final newPath = path.join(
                io.Directory.systemTemp.path,
                newFileName,
              );
              final file = await io.File(
                newPath,
              ).writeAsBytes(imageBytes, flush: true);
              return file.path;
            },
          ),
        ),
      );
    }();
  }
}
