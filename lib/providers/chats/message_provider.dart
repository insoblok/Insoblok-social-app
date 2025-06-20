import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'package:insoblok/locator.dart';
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

  String? _balance;
  String? get balance => _balance;
  set balance(String? s) {
    _balance = s;
    notifyListeners();
  }

  var textController = TextEditingController();
  var scrollController = ScrollController();
  late MediaPickerService _mediaPickerService;

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

    messageService.getUsersStream().listen((queryRooms) {
      var userList = [];
      for (var doc in queryRooms.docs) {
        var json = doc.data();
        json['id'] = doc.id;
        userList.add(UserModel.fromJson(json));
      }
      logger.d(userList.length);
      for (UserModel user in userList) {
        if (user.id == data.chatUser.id) chatUser = user;
      }
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 200), () {
        scrollToBottom();
      });
    });

    messageService.markMessagesAsRead(room.id!);

    _mediaPickerService = locator<MediaPickerService>();
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
        await messageService.sendMessage(chatRoomId: room.id!, text: content!);
        textController.text = '';
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
      } finally {
        notifyListeners();
        scrollToBottom();
      }
    }
  }

  XFile? _selectedFile;
  XFile? get selectedFile => _selectedFile;
  set selectedFile(XFile? f) {
    _selectedFile = f;
    notifyListeners();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> onPickerImage() async {
    if (isBusy) return;
    clearErrors();

    isAddPop = false;

    var image = await _mediaPickerService.onPickerSingleMedia(isImage: true);
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
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      }
    }
  }

  Future<void> onPickerVideo() async {
    if (isBusy) return;
    clearErrors();

    isAddPop = false;

    var video = await _mediaPickerService.onPickerSingleMedia(isImage: false);
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
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      }
    }
  }

  Future<void> onPickGif() async {
    if (isBusy) return;
    clearErrors();

    var gif = await _mediaPickerService.onGifPicker();
    if (gif.isNotEmpty) {
      var gifUrl = await FirebaseHelper.uploadFile(
        file: File(gif.first),
        folderName: 'message',
      );
      if (gifUrl != null) {
        logger.d(gifUrl);
        await messageService.sendGifMessage(
          chatRoomId: room.id!,
          gifUrl: gifUrl,
        );
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }
  }

  Future<void> onPaidEth() async {
    if (isBusy) return;
    clearErrors();

    isAddPop = false;

    final reownService = locator<ReownService>();

    var req = await reownService.onShowTransferModal(
      context,
      address: chatUser.walletAddress,
    );
    if (req != null) {
      try {
        await reownService.connect();
        if (reownService.isConnected) {
          if (chatUser.walletAddress == null) {
            setError('Chat user has not wallet!');
          } else {
            var result = await reownService.ethSendTransaction(req: req);
            logger.d(result);
            if (result['code'] != 200) {
              throw (result['message']);
            }
          }
        } else {
          throw ('Failed wallet connected!');
        }
      } catch (e) {
        logger.e(e);
        setError(e);
      } finally {
        notifyListeners();
      }

      if (hasError) {
        AIHelpers.showToast(msg: modelError.toString());
      } else {
        await messageService.sendPaidMessage(
          chatRoomId: room.id!,
          coin: CoinModel(
            icon: AIImages.icEthereumGold,
            type: 'ETH',
            amount: '${req.amount}',
            unit: '${req.unit}',
          ),
        );
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }
  }

  Future<bool> _showPreview({bool isImage = true}) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    color: AIColors.darkBar,
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
                            : VideoPreview(path: selectedFile!.path),
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
                                    color: AIColors.darkPrimaryColor.withAlpha(
                                      204,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(Icons.close, color: Colors.white),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pop(true),
                                child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: AIColors.darkPrimaryColor.withAlpha(
                                      204,
                                    ),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(Icons.send, color: Colors.white),
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

  const VideoPreview({super.key, required this.path});

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

    _videoPlayerController = VideoPlayerController.file(File(widget.path));
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
              : Center(child: Loader(size: 30)),
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
    if (_videoPlayerController.value.isInitialized) {
      _videoPlayerController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }
}
