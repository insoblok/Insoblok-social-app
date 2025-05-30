import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
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

  var scrollController = ScrollController();
  late UploadMediaProvider provider;

  Future<void> init(BuildContext context) async {
    this.context = context;

    provider = UploadMediaProvider.getInstance(context);
    provider.reset();
  }

  String _title = '';
  String get title => _title;
  set title(String s) {
    _title = s;
    notifyListeners();
  }

  bool _isVoteImage = true;
  bool get isVoteImage => _isVoteImage;
  set isVoteImage(bool s) {
    _isVoteImage = s;
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
    var desc = await AIHelpers.goToDescriptionView(
      context,
      quillData: quillData,
    );
    if (desc != null) {
      quillDescription = desc;
      notifyListeners();
    }
  }

  void setPostType(bool isVote) {
    _isVoteImage = isVote;
    notifyListeners();
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
      AIHelpers.showToast(msg: modelError.toString());
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
        if (quillDescription == '' && medias.isEmpty) return;
        txtUploadButton = 'Adding to Server...';
        var story = StoryModel(
          title: title,
          text: quillDescription,
          category: isVoteImage ? 'vote' : 'regular',
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
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      AIHelpers.showToast(
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
