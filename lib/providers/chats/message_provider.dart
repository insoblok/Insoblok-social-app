import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MessageProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late RoomModel _room;
  RoomModel get room => _room;
  set room(RoomModel model) {
    _room = model;
    notifyListeners();
  }

  late UserModel _chatUser;
  UserModel get chatUser => _chatUser;
  set chatUser(UserModel model) {
    _chatUser = model;
    notifyListeners();
  }

  final _messageService = MessageService();
  MessageService get messageService => _messageService;

  final List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;
  set messages(List<MessageModel> data) {
    _messages.clear();
    _messages.addAll(data);
    notifyListeners();
  }

  bool _isAddPop = false;
  bool get isAddPop => _isAddPop;
  set isAddPop(bool f) {
    _isAddPop = f;
    notifyListeners();
  }

  var textController = TextEditingController();
  var scrollController = ScrollController();

  Future<void> init(
    BuildContext context, {
    required MessagePageData data,
  }) async {
    this.context = context;
    room = data.room;
    chatUser = data.chatUser;

    messageService.getMessages(room.id!).listen((messages) {
      this.messages = messages;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    scrollController.addListener(() {
      isAddPop = false;
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  String? _content;
  String? get content => _content;
  set content(String? s) {
    _content = s;
    notifyListeners();
  }

  void sendMessage() async {
    if (content?.isNotEmpty ?? false) {
      try {
        await messageService.sendMessage(
          chatRoomId: room.id!,
          text: content!,
        );
        // scrollToBottom();
        textController.text = '';
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      } finally {
        notifyListeners();
      }
    }
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  XFile? get selectedFile => _selectedFile;
  set selectedFile(XFile? f) {
    _selectedFile = f;
    notifyListeners();
  }

  Future<void> onPickerImage() async {
    if (isBusy) return;
    clearErrors();

    isAddPop = false;

    var mediaSource = await _showMediaSource();
    if (mediaSource != null) {
      var isAllowed = false;
      isAllowed = mediaSource == ImageSource.gallery
          ? ((await PermissionService.requestGalleryPermission()) ?? false)
          : ((await PermissionService.requestCameraPermission()) ?? false);

      if (isAllowed) {
        final image = await _picker.pickImage(source: mediaSource);
        if (image != null) {
          selectedFile = image;
          var isSend = await _showPreview(isImage: true);
          if (isSend) {
            var imageUrl = await FirebaseHelper.uploadFile(
              file: File(image.path),
              folderName: 'message',
            );
            if (imageUrl != null) {
              await messageService.sendImageMessage(
                chatRoomId: room.id!,
                imageUrl: imageUrl,
              );
            }
          }
        } else {
          Fluttertoast.showToast(msg: 'No selected image!');
        }
      } else {
        Fluttertoast.showToast(msg: 'Permission Denided!');
      }
    }
  }

  Future<void> onPickerVideo() async {
    if (isBusy) return;
    clearErrors();

    isAddPop = false;

    var mediaSource = await _showMediaSource();
    if (mediaSource != null) {
      var isAllowed = false;
      isAllowed = mediaSource == ImageSource.gallery
          ? ((await PermissionService.requestGalleryPermission()) ?? false)
          : ((await PermissionService.requestCameraPermission()) ?? false);

      if (isAllowed) {
        final video = await _picker.pickVideo(source: mediaSource);
        if (video != null) {
          selectedFile = video;
          var isSend = await _showPreview(isImage: false);
          if (isSend) {
            var videoUrl = await FirebaseHelper.uploadFile(
              file: File(video.path),
              folderName: 'message',
            );
            if (videoUrl != null) {
              await messageService.sendVideoMessage(
                chatRoomId: room.id!,
                videoUrl: videoUrl,
              );
            }
          }
        } else {
          Fluttertoast.showToast(msg: 'No selected video!');
        }
      } else {
        Fluttertoast.showToast(msg: 'Permission Denided!');
      }
    }
  }

  Future<void> onRecordAudio() async {}

  Future<void> onPaidEth() async {}

  Future<ImageSource?> _showMediaSource() async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            color: AIColors.appScaffoldBackground,
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 24.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(
                        Icons.air,
                        color: AIColors.blue,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        'From Gallery',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(
                        Icons.camera,
                        color: AIColors.blue,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        'From Camera',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showPreview({
    bool isImage = true,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: AIColors.appBar,
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        isImage
                            ? AIImage(
                                width: 240.0,
                                height: 240.0,
                                File(selectedFile!.path),
                                fit: BoxFit.contain,
                              )
                            : VideoPreview(
                                path: selectedFile!.path,
                              ),
                        Container(
                          width: 240.0,
                          height: 240.0,
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: AIColors.primaryColor.withAlpha(204),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pop(true),
                                child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: AIColors.primaryColor.withAlpha(204),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ) ??
        false;
  }
}

class VideoPreview extends StatefulWidget {
  final String path;

  const VideoPreview({
    super.key,
    required this.path,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(
      File(widget.path),
    );
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isCompleted) {
        setState(() {
          isPlaying = false;
          _videoPlayerController.seekTo(Duration(milliseconds: 0));
        });
      }
    });
    _videoPlayerController.initialize().then((data) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        showControls: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightGreen,
        ),
      );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.0,
      height: 240.0,
      child: Stack(
        children: [
          _videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController)
              : Center(
                  child: Loader(),
                ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlaying) {
                  _videoPlayerController.pause();
                } else {
                  _videoPlayerController.play();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              icon: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: Colors.white,
                size: 32.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
