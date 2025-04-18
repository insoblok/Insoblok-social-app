import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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

  var controller = TextEditingController();

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
        controller.text = '';
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

    var isAllowed = await PermissionService.requestGalleryPermission();
    if (isAllowed ?? false) {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedFile = image;
        var isSend = await _showPreview();
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

  Future<void> onPickerVideo() async {}

  Future<void> onRecordAudio() async {}

  Future<void> onPaidEth() async {}

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
                        AIImage(
                          width: 240.0,
                          height: 240.0,
                          File(selectedFile!.path),
                          fit: BoxFit.contain,
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
