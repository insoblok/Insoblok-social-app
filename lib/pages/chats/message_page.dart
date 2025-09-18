import 'package:flutter/material.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:stacked/stacked.dart' hide FloatingActionButtonBuilder;

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kRadiuMessagePicker = 120.0;

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
                    if (viewModel.isTyping)
                      Row(
                        children: [
                          Text(
                            'Typing',
                            style: TextStyle(
                              fontSize: 11.0,
                              color: AIColors.greyTextColor,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: LoadingIndicator(
                              indicatorType: Indicator.ballPulse,
                              colors: [AIColors.greyTextColor],
                              strokeWidth: 2,
                            ),
                          ),
                        ],
                      ),
                    if (!viewModel.isTyping)
                      Text(
                        viewModel.chatUser.status ?? 'Online',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: AIColors.greyTextColor,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.3,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            flexibleSpace: AppBackgroundView(),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
            ],
          ),
          body: AppBackgroundView(
            child: Column(
              children: [
                Expanded(
                  child: viewModel.messages.length == 0 ? Center(child: Text("No messages yet")) : 
                    ListView.separated(
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
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 8.0),
                      itemCount: viewModel.messages.length,
                    ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewModel.isAddPop) ...{
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: MessageActionButton(
                          onPressed: viewModel.onPickerImage,
                          child: AIImage(
                            AIImages.icImage,
                            color: Theme.of(context).colorScheme.secondary,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: kRadiuMessagePicker * 0.33 + 12,
                        ),
                        child: MessageActionButton(
                          onPressed: viewModel.onPickerVideo,
                          child: AIImage(
                            AIImages.icCamera,
                            color: Theme.of(context).colorScheme.secondary,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: kRadiuMessagePicker * 0.66 + 12,
                        ),
                        child: MessageActionButton(
                          onPressed: viewModel.onPickGif,
                          child: AIImage(
                            AIImages.icGif,
                            color: Theme.of(context).colorScheme.secondary,
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),
                      /*
                      Padding(
                        padding: const EdgeInsets.only(
                          left: kRadiuMessagePicker + 12,
                        ),
                        child: MessageActionButton(
                          onPressed: viewModel.onPaidEth,
                          child: Icon(
                            Icons.wallet,
                            size: 20.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      */
                    },
                    Container(
                      margin: EdgeInsets.only(
                        left: 12.0,
                        right: 12.0,
                        bottom: MediaQuery.of(context).viewPadding.bottom,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withAlpha(16),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: InkWell(
                              onTap: () {
                                viewModel.isAddPop = !viewModel.isAddPop;
                              },
                              child: Icon(
                                viewModel.isAddPop
                                    ? Icons.close
                                    : Icons.add_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                right: 12.0,
                              ),
                              constraints: BoxConstraints(maxHeight: 100.0),
                              child: TextFormField(
                                focusNode: viewModel.focusNode,
                                decoration: InputDecoration(
                                  hintText: 'Type something',
                                  hintStyle:
                                      Theme.of(context).textTheme.labelMedium,
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: null,
                                controller: viewModel.textController,
                                onChanged: (value) => viewModel.content = value,
                                onFieldSubmitted: (value) {
                                  if (viewModel.isShowButton) {
                                    viewModel.sendMessage();
                                  }
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
                          InkWell(
                            onTap: () {
                              viewModel.handleClickDollarIcon(context);
                            },
                            child:  AIImage(AIImages.icDollar, width: 36.0, height: 36.0),
                          ),
                          InkWell(
                            onTap: () {
                              if (viewModel.isShowButton) {
                                viewModel.sendMessage();
                              }
                            },
                            child: Icon(
                              Icons.send,
                              color:
                                  viewModel.isShowButton
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).colorScheme.secondary,
                              size: 20.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}