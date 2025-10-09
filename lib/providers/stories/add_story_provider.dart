import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insoblok/locator.dart';
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

  final MediaPickerService mediaPickerService = locator<MediaPickerService>();

  var scrollController = ScrollController();
  final _mediaProvider = locator<UploadMediaProvider>();
  UploadMediaProvider get mediaProvider => _mediaProvider;


  String _title = '';
  String get title => _title;
  set title(String s) {
    _title = s;
    notifyListeners();
  }

  bool _isPostingStory = false;
  bool get isPostingStory => _isPostingStory;
  set isPostingStory(bool s) {
    _isPostingStory = s;
    notifyListeners();
  }

  bool _isVoteImage = true;
  bool get isVoteImage => _isVoteImage;
  set isVoteImage(bool s) {
    _isVoteImage = s;
    notifyListeners();
  }

  bool _isPrivate = false;
  bool get isPrivate => _isPrivate;
  set isPrivate(bool s) {
    _isPrivate = s;
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

  List<UserModel> _selectedUserList = [];
  List<UserModel> get selectedUserList => _selectedUserList;

  String placeId = "";


  Future<void> init(BuildContext context) async {
    this.context = context;
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

  void setPostAction(bool isVote) {
    _isPrivate = isVote;
    notifyListeners();
  }

  Future<void> goToMainPage() async {
    await Routers.goToMainPage(context);
  }

  Future<void> onAddMedia() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        await mediaProvider.addMedias(context);
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

  void onRemoveMedia(UploadMediaItem media) {
    mediaProvider.removeMedia(media);
    notifyListeners();
  }

  Future<String> onEditMedia(UploadMediaItem media) async {
    String result = "";
    logger.d("File type is ${media.getFileType()}");

    if (media.getFileType() == FileType.video) {
      result = await Routers.goToVideoEditorPage(context, media.file!.path);
    }
    else if (media.getFileType() == FileType.image) {
      logger.d("GOing to image editor ${media.file!.path}");
      await Routers.goToImageEditorPage(context, media.file!.path);
      result = mediaPickerService.editedImagePath;
      logger.d("mediapickerservice path is ${result}");
    }
    logger.d("Video Editor result is $result");
    return result;
  }

  void setMedia(UploadMediaItem media, int index) {
    mediaProvider.setMedia(media, index);
  }

  String _txtUploadButton = 'Post Story';
  String get txtUploadButton => _txtUploadButton;
  set txtUploadButton(String s) {
    _txtUploadButton = s;
    notifyListeners();
  }

  Future<void> onClickUploadButton() async {
    if (isBusy || isPostingStory) return;

    _isPostingStory = true;

    clearErrors();
    List<String> allowUsers = [];

    logger.d("selectedUserList : $selectedUserList");

    for (var user in selectedUserList) {
      allowUsers.add(user.id!);
    }
    if (isPrivate && allowUsers.isEmpty) {
      AIHelpers.showToast(msg: 'You need to select one user at least');
      return;
    }
    if(isPrivate){
      var id = AuthHelper.user?.id;
      allowUsers.add(id!);
    }
    
    await runBusyFuture(() async {
      try {
        txtUploadButton = 'Uploading Media(s)...';
        var medias = await mediaProvider.uploadMedias();
        var validMedias = medias.asMap().entries
          .where((entry) {
            final index = entry.key;
            final media= entry.value;
            bool result = media.link != "" || media.width! > 0 || media.height! > 0; 
            if(!result) mediaProvider.removeMediaByIndex(index);
            return result; 
          })
          .map((entry) => entry.value)
          .toList();

        logger.d("medias : $medias");
        if(validMedias.isEmpty) {
          setError("Failed to upload medias.");
          return;
        }
        else if(validMedias.length < medias.length) {
          setError("Failed to upload some medias.");

        }
        if (quillDescription == '' && medias.isEmpty) {
          throw ('Invalid story type');
        }
        txtUploadButton = 'Adding to Server...';

        var story = StoryModel(
          title: title,
          text: quillDescription,
          category: isVoteImage ? 'vote' : 'regular',
          placeId: placeId,
          updateDate: DateTime.now(),
          timestamp: DateTime.now(),
          status: isPrivate ? 'private' : 'public',
          allowUsers: allowUsers,
        ).copyWith(medias: validMedias);
        logger.d("new story : $story");
        var result = await storyService.postStory(story: story);
        await tastScoreService.postScore();
        
        logger.d("result : $result");
      } catch (e, s) {
        setError(e);
        logger.e(e, stackTrace: s);
      } finally {
        isPostingStory = false;
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
      txtUploadButton = "Post Story";
    } else {
      AIHelpers.showToast(
        msg: 'Successfully your post! Your feed is in list now!',
      );
      mediaProvider.reset();
      // Navigator.of(context).pop(true);
      goToMainPage();
    }
  }

  Future<void> onClickAddUser() async {
    Routers.goToUserListPage(context, users: selectedUserList);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
