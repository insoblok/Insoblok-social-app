import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';

class RoomItemView extends StatelessWidget {
  final ChatRoomWithSettings room;
  final Function(BuildContext ctx, UserModel chatUser)? onTap;
  final bool isSelected;
  final bool isSelectionMode;
  final Function(RoomModel)? onLongPress;
  final Function(RoomModel)? onSelectionTap;

  RoomItemView({
    super.key,
    required this.room,
    this.onTap,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onLongPress,
    this.onSelectionTap,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoomProvider>.reactive(
      viewModelBuilder: () => RoomProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: room),
      builder: (context, viewModel, _) {
        if (viewModel.isBusy) {
          return Container();
        }

        final isArchived = (room.userSettings.isArchived ?? false);

        return Dismissible(
          key: ValueKey(room.userSettings.roomId ?? ""),
          direction: DismissDirection.endToStart,
          background: _buildSwipeAction(context, isArchived),
          // confirmDismiss: (direction) async {
          //   bool? confirm = true;
          //   if (isArchived) {
          //     confirm = await _confirmAction(
          //       context,
          //       title: 'Unarchive Chat?',
          //       message: 'Do you want to move this chat back to your chat list?',
          //       confirmText: 'Unarchive',
          //       confirmColor: Colors.blue,
          //     );
          //   } else {
          //     confirm = await _confirmAction(
          //       context,
          //       title: 'Archive Chat?',
          //       message: 'Do you want to move this chat to Archive?',
          //       confirmText: 'Archive',
          //       confirmColor: Colors.orange,
          //     );
          //   }
          //   return confirm;
          // },
          onDismissed: (direction) async {
            await Future.delayed(Duration(milliseconds: 1000));
            if (isArchived) {
              await viewModel.unArchiveChat();
            } else {
              await viewModel.archiveChat();
            }
          },
          child: Material(
            color:
                isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            child: InkWell(
              onTap: () {
                if (isSelectionMode && onSelectionTap != null) {
                  onSelectionTap!(room.chatroom);
                } else if (onTap != null && viewModel.chatUser != null) {
                  onTap!(context, viewModel.chatUser!);
                }
              },
              onLongPress: () {
                if (onLongPress != null) {
                  onLongPress!(room.chatroom);
                }
              },
              child:
                  viewModel.chatUser == null
                      ? Opacity(opacity: 0)
                      : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 0.0,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 4.0,
                                right: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(0),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      if (viewModel.chatUser != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 0.0,
                                          ),
                                          child: viewModel.chatUser!
                                              .avatarStatusView(
                                                width: kAvatarSize,
                                                height: kAvatarSize,
                                                borderWidth: 2.0,
                                                textSize: 28.0,
                                              ),
                                        ),
                                      if (isSelected)
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.withOpacity(0.1),
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    viewModel
                                                            .chatUser
                                                            ?.fullName ??
                                                        '---',
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  if (room
                                                          .userSettings
                                                          .isMuted ??
                                                      false) ...{
                                                    Icon(
                                                      Icons.volume_off,
                                                      color: Colors.white,
                                                      size: 16.0,
                                                    ),
                                                  },
                                                ],
                                              ),
                                              Text(
                                                room
                                                        .chatroom
                                                        .updatedAt
                                                        ?.timeago ??
                                                    '',
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                room.chatroom.content == "null"
                                                    ? 'Chat Room'
                                                    : room.chatroom.content ??
                                                        "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                              Opacity(
                                                opacity:
                                                    viewModel.unreadMsgCnt > 0
                                                        ? 1
                                                        : 0,
                                                child: Row(
                                                  children: [
                                                    const SizedBox(width: 12),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape:
                                                            viewModel.unreadMsgCnt <
                                                                    10
                                                                ? BoxShape
                                                                    .circle
                                                                : BoxShape
                                                                    .rectangle,
                                                        borderRadius:
                                                            viewModel.unreadMsgCnt <
                                                                    10
                                                                ? null
                                                                : BorderRadius.circular(
                                                                  16,
                                                                ),
                                                      ),
                                                      child: Text(
                                                        '${viewModel.unreadMsgCnt}',
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (viewModel.isTyping)
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: LoadingIndicator(
                                        indicatorType: Indicator.ballPulse,
                                        colors: [
                                          Theme.of(context).primaryColor,
                                        ],
                                        strokeWidth: 2,
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
    );
  }

  Widget _buildSwipeAction(BuildContext context, bool isArchived) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: isArchived ? Colors.blue : Colors.orange,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            isArchived ? 'Unarchive' : 'Archive',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 12),
          Icon(
            isArchived ? Icons.unarchive : Icons.archive,
            color: Colors.white,
            size: 28,
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: confirmColor),
                child: Text(confirmText),
              ),
            ],
          ),
    );
  }
}
