import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class MessagePageData {
  MessagePageData({
    required this.room,
    required this.chatUser,
  });

  final RoomModel room;
  final UserModel chatUser;
}

const kAddPopHeight = 54.0;

class MessagePage extends StatelessWidget {
  final MessagePageData data;

  const MessagePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageProvider>.reactive(
      viewModelBuilder: () => MessageProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, data: data),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                viewModel.chatUser.avatarStatusView(
                  width: 36.0,
                  height: 36.0,
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.chatUser.fullName,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      viewModel.chatUser.status ?? '',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: viewModel.scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 24.0,
                  ),
                  itemBuilder: (context, index) {
                    var message = viewModel.messages[index];
                    return message.item(
                      context,
                      chatUser: viewModel.chatUser,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemCount: viewModel.messages.length,
                ),
              ),
              Container(
                height: viewModel.isAddPop ? 66.0 + kAddPopHeight : 66.0,
                color: AIColors.appBar,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (viewModel.isAddPop) ...{
                      Container(
                        alignment: Alignment.center,
                        height: kAddPopHeight,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: viewModel.onPickerImage,
                                    icon: Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: viewModel.onPickerVideo,
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: viewModel.onRecordAudio,
                                    icon: Icon(
                                      Icons.voicemail,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: viewModel.onPaidEth,
                                    icon: Icon(
                                      Icons.wallet,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => viewModel.isAddPop = false,
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => viewModel.isAddPop = true,
                          icon: Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: AITextField(
                              hintText: 'Input a message...',
                              controller: viewModel.textController,
                              onChanged: (value) => viewModel.content = value,
                              onFieldSubmitted: (value) {},
                              onSaved: (value) {},
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: viewModel.sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 32.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
