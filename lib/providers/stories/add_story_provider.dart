import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:provider/provider.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AddStoryProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late QuillController quillController;
  var focusNode = FocusNode();
  var quillScrollController = ScrollController();
  var scrollController = ScrollController();
  late UploadMediaProvider provider;

  Future<void> init(BuildContext context) async {
    this.context = context;
    provider = context.read<UploadMediaProvider>();

    quillController = () {
      return QuillController.basic(
        config: QuillControllerConfig(
          clipboardConfig: QuillClipboardConfig(enableExternalRichPaste: true),
        ),
      );
    }();

    focusNode.canRequestFocus = false;
  }

  Future<void> updateDescription() async {
    final String json = jsonEncode(quillController.document.toDelta().toJson());
    var desc = await Routers.goToQuillDescriptionPage(context, origin: json);
    if (desc != null) {
      logger.d(desc);
      quillController.document = Document.fromJson(jsonDecode(desc));
      notifyListeners();
    }
  }

  Future<void> onClickAddMediaButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await provider.addMedias(context);
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {}
  }

  @override
  void dispose() {
    quillController.dispose();
    quillScrollController.dispose();
    focusNode.dispose();

    super.dispose();
  }
}
