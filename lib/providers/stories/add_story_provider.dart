import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class AddStoryProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  var scrollController = ScrollController();
  late UploadMediaProvider provider;

  Future<void> init(BuildContext context) async {
    this.context = context;
    provider = context.read<UploadMediaProvider>();
  }

  String _title = '';
  String get title => _title;
  set title(String s) {
    _title = s;
    notifyListeners();
  }

  String _quillDescription = '';
  String get quillDescription => _quillDescription;
  set quillDescription(String s) {
    _quillDescription = s;
    notifyListeners();
  }

  List<Map<String, dynamic>> _quillData = [];
  List<Map<String, dynamic>> get quillData => _quillData;
  set quillData(List<Map<String, dynamic>> data) {
    _quillData = data;
    notifyListeners();
  }

  Future<void> updateDescription() async {
    var desc = await Routers.goToQuillDescriptionPage(
      context,
      origin: jsonEncode(quillData),
    );
    if (desc != null) {
      quillData = desc;
      final converter = QuillDeltaToHtmlConverter(
        desc,
        ConverterOptions.forEmail(),
      );
      quillDescription = converter.convert();
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
    }
  }

  String _txtUploadButton = 'Post Story';
  String get txtUploadButton => _txtUploadButton;
  set txtUploadButton(String s) {
    _txtUploadButton = s;
    notifyListeners();
  }

  final _storyService = StoryService();
  StoryService get storyService => _storyService;

  Future<void> onClickUploadButton() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        txtUploadButton = 'Uploading Media(s)...';
        var medias = await provider.uploadMedias();
        txtUploadButton = 'Adding to Server...';
        var story = StoryModel(
          title: title,
          text: quillDescription,
        ).copyWith(medias: medias);
        await storyService.postStory(story: story);
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
    } else {
      Fluttertoast.showToast(
        msg: 'Successfully your post! Your feed is in list now!',
      );
      provider.reset();
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
