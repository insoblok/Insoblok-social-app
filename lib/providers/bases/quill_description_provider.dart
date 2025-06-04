import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:insoblok/services/services.dart';

import 'package:insoblok/utils/utils.dart';

const kDefaultDescLength = 500;

class QuillDescriptionProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late QuillController quillController;
  var scrollController = ScrollController();
  var focusNode = FocusNode();

  Future<void> init(BuildContext context, {String? originQuill}) async {
    this.context = context;

    quillController = () {
      return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
        ),
      );
    }();

    if (originQuill?.isNotEmpty ?? false) {
      logger.d(originQuill);
      quillController.document = Document.fromJson(jsonDecode(originQuill!));
    }

    notifyListeners();
  }

  Future<void> onClickSave() async {
    var length = quillController.document.length;
    if (length > kDefaultDescLength) {
      AIHelpers.showToast(
        msg:
            'The description length can\'t be over $kDefaultDescLength characters!',
      );
      return;
    }

    final json = quillController.document.toDelta().toJson();
    Navigator.of(context).pop(json);
  }

  @override
  void dispose() {
    quillController.dispose();
    scrollController.dispose();
    focusNode.dispose();

    super.dispose();
  }
}
