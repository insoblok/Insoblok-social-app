import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MessagePageData {
  MessagePageData({required this.room, required this.chatUser});

  final RoomModel room;
  final UserModel chatUser;
}

class MessagePage extends StatelessWidget {
  final MessagePageData data;

  const MessagePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageProvider>.reactive(
      viewModelBuilder: () => MessageProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, data: data),
      builder: (context, viewModel, _) {
        var bottomInset = MediaQuery.of(context).viewInsets.bottom;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (bottomInset > 0) {
            Future.delayed(Duration(milliseconds: 100), () {
              if (viewModel.scrollController.hasClients) {
                viewModel.scrollController.animateTo(
                  viewModel.scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                viewModel.chatUser.avatarStatusView(
                  width: 36.0,
                  height: 36.0,
                  borderWidth: 2.0,
                  statusSize: 10.0,
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
                      ),
                    ),
                    Text(
                      viewModel.chatUser.status ?? 'Offline',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: AIColors.greyTextColor,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
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
                    return message.item(context, chatUser: viewModel.chatUser);
                  },
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 8.0),
                  itemCount: viewModel.messages.length,
                ),
              ),
              Container(
                color: AppSettingHelper.greyBackground,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 100.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Type something',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: null,
                                controller: viewModel.textController,
                                onChanged: (value) => viewModel.content = value,
                                onFieldSubmitted: (value) {
                                  viewModel.sendMessage();
                                },
                                onSaved: (value) {
                                  logger.d('onSaved');
                                },
                                onEditingComplete: () {
                                  logger.d('onEditingComplete');
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: viewModel.onPickerImage,
                                icon: AIImage(
                                  AIImages.icImage,
                                  color: AIColors.grey,
                                  width: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: viewModel.onPickerVideo,
                                icon: AIImage(
                                  AIImages.icCamera,
                                  color: AIColors.grey,
                                  width: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: viewModel.onPickGif,
                                icon: AIImage(
                                  AIImages.icGif,
                                  color: AIColors.grey,
                                  width: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: viewModel.onPaidEth,
                                icon: Icon(
                                  Icons.wallet,
                                  size: 28,
                                  color: AIColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AIColors.pink,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: IconButton(
                              onPressed: viewModel.sendMessage,
                              icon: Icon(
                                Icons.arrow_upward_outlined,
                                color: AIColors.white,
                                size: 20.0,
                              ),
                            ),
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
