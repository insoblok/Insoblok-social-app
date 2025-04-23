import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

    if (originQuill != null) {
      quillController.document = Document.fromJson(jsonDecode(originQuill));
    }

    notifyListeners();
  }

  Future<void> onClickSave() async {
    var length = quillController.document.length;
    if (length > kDefaultDescLength) {
      Fluttertoast.showToast(
        msg:
            'The description length can\'t be over $kDefaultDescLength characters!',
      );
      return;
    }

    final String json = jsonEncode(quillController.document.toDelta().toJson());
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
