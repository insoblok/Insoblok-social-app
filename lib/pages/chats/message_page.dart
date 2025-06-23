import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: 12.0,
                      bottom: 24.0,
                      top: 12.0,
                      left: 76.0,
                    ),
                    padding: const EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppSettingHelper.greyBackground.withAlpha(64),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Row(
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
                                focusNode: viewModel.focusNode,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            width: 36.0,
                            height: 36.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  viewModel.isShowButton
                                      ? AIColors.pink
                                      : Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (viewModel.isShowButton) {
                                  viewModel.sendMessage();
                                }
                              },
                              icon: Icon(
                                Icons.send,
                                color:
                                    viewModel.isShowButton
                                        ? AIColors.white
                                        : Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 22,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12.0),
                      child: FanExpandableFab(
                        radius: 120,
                        startAngle: 90,
                        sweepAngle: 90,
                        icon: Icon(
                          Icons.add_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24.0,
                        ),
                        closeIcon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24.0,
                        ),
                        children: [
                          FloatingActionButton(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            // elevation: 0.0,
                            // highlightElevation: 0.0,
                            shape: const CircleBorder(),
                            heroTag: null,
                            child: AIImage(
                              AIImages.icImage,
                              color: Theme.of(context).colorScheme.secondary,
                              width: 20,
                            ),
                            onPressed: () => viewModel.onPickerImage,
                          ),
                          FloatingActionButton(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            // elevation: 0.0,
                            // highlightElevation: 0.0,
                            shape: const CircleBorder(),
                            heroTag: null,
                            child: AIImage(
                              AIImages.icCamera,
                              color: Theme.of(context).colorScheme.secondary,
                              width: 20,
                            ),
                            onPressed: () => viewModel.onPickerVideo,
                          ),
                          FloatingActionButton(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            // elevation: 0.0,
                            // highlightElevation: 0.0,
                            shape: const CircleBorder(),
                            heroTag: null,
                            child: AIImage(
                              AIImages.icGif,
                              color: Theme.of(context).colorScheme.secondary,
                              width: 20,
                            ),
                            onPressed: () => viewModel.onPickGif,
                          ),
                          FloatingActionButton(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                            // elevation: 0.0,
                            // highlightElevation: 0.0,
                            shape: const CircleBorder(),
                            heroTag: null,
                            child: Icon(
                              Icons.wallet,
                              size: 28,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () => viewModel.onPaidEth,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
