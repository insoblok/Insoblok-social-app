import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/pages/pages.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    logger.d("This is build of chat view");
    return ViewModelBuilder<ChatProvider>.reactive(
      viewModelBuilder: () => ChatProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            leading: viewModel.isSelectionMode 
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => viewModel.clearSelection(),
                )
              : AppLeadingView(),
            title: viewModel.isSelectionMode
              ? Text('${viewModel.selectedRoomIds.length} selected')
              : AITextField(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search people, rooms, etc ...",
                  focusedColor: Colors.grey,
                ),
            actions: viewModel.isSelectionMode
              ? [
                viewModel.isFirstSelectedRoomMuted ? IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () => viewModel.unMuteSelectedRooms()
                ) :
                  IconButton(
                    icon: Icon(Icons.volume_off),
                    onPressed: () => viewModel.muteSelectedRooms(),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => viewModel.deleteSelectedRooms(),
                  ),
                  IconButton(
                    icon: Icon(Icons.archive),
                    onPressed: () => viewModel.archiveSelectedRooms(),
                  ),
                ]
              : [
                  IconButton(
                    onPressed: () => Routers.goToMessageSettingPage(context),
                    icon: AIImage(
                      AIImages.icSetting,
                      width: 24.0,
                      height: 24.0,
                      color: Colors.white,
                    ),
                  ),
                ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: viewModel.isBusy
                ? Center(child: Loader(size: 60))
                : (viewModel.activeRooms.isEmpty && viewModel.suggestedUsers.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: AIImage(
                                AIImages.placehold,
                                width: 160.0,
                                height: 160.0,
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            Text(
                              "Create Room",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60.0),
                              child: Text(
                                "You have not any chatting user yet! Please try to create a new room first by clicking + button.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                      children: [
                        // Text(
                        //   viewModel.activeRooms.map((room) => room.chatroom.id ?? "").toList().toString()
                        // ),
                        // Text(
                        //   viewModel.activeRooms.map((room) => room.userSettings.isMuted ?? "").toList().toString()
                        // ),
                        if (viewModel.archivedRooms.isNotEmpty)
                          _ArchivedChatsHeader(archivedRooms: viewModel.archivedRooms),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification n) {
                                if (n is ScrollUpdateNotification) {
                                  final position = n.metrics;
                                  if (position.pixels > position.maxScrollExtent - 200) {
                                    viewModel.loadMoreRooms();
                                    viewModel.loadMoreSuggestedUsers();
                                  }
                                }
                                return false;
                              },
                              child: ListView.builder(
                                // Prebuild ~1.5 screen heights for smoother scrolling
                                cacheExtent: MediaQuery.of(context).size.height * 1.5,
                                itemCount: _totalItems(viewModel),
                                itemBuilder: (context, index) {
                                  return _buildSectionedItem(context, viewModel, index);
                                },
                              ),
                            ),
                        ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}

int _totalItems(ChatProvider vm) {
  final roomsCount = vm.activeRooms.length;
  final usersCount = vm.usersVisibleCount;
  final hasRooms = roomsCount > 0;
  final hasUsers = usersCount > 0;
  final headers = (hasRooms && hasUsers) ? 2 : (hasRooms || hasUsers) ? 1 : 0;
  return roomsCount + usersCount + headers;
}

Widget _buildSectionedItem(BuildContext context, ChatProvider vm, int index) {
  final hasRooms = vm.activeRooms.isNotEmpty;
  final hasUsers = vm.usersVisibleCount > 0;

  int cursor = 0;

  if (hasRooms) {
    cursor += 1;
    final roomsStart = cursor;
    final roomsEnd = roomsStart + vm.activeRooms.length;
    if (index >= roomsStart && index < roomsEnd) {
      final room = vm.activeRooms[index - roomsStart];
      return RoomItemView(
        room: room,
        onTap: (BuildContext ctx, UserModel u) {
          Routers.goToMessagePage(
            ctx,
            MessagePageData(room: room.chatroom, chatUser: u),
          );
        },
        isSelected: vm.selectedRoomIds.contains(room.id),
        isSelectionMode: vm.isSelectionMode,
        onLongPress: vm.toggleRoomSelection,
        onSelectionTap: vm.toggleRoomSelection,
      );
    }
    cursor = roomsEnd;
  }

  if (hasUsers) {
    cursor += 1;
    final usersStart = cursor;
    final usersEnd = usersStart + vm.usersVisibleCount;
    if (index >= usersStart && index < usersEnd) {
      final user = vm.suggestedUsers[index - usersStart];
      return _SuggestedUserTile(user: user, onTap: vm.gotoNewChat);
    }
  }

  return const SizedBox.shrink();
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }
}

class _ArchivedChatsHeader extends StatelessWidget {
  final List<ChatRoomWithSettings> archivedRooms;
  const _ArchivedChatsHeader({required this.archivedRooms});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Routers.goToArchivedChatViewPage(context),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(100),
                borderRadius: BorderRadius.circular( 60 / 2),
              ),
              child: ClipOval(
                child: Icon(Icons.archive, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Archived Chats',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${archivedRooms.length} chat${archivedRooms.length > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _SuggestedUserTile extends StatelessWidget {
  final UserModel user;
  final Function(BuildContext ctx, UserModel chatUser)? onTap;
  const _SuggestedUserTile({required this.user, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(context, user),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            user.avatarStatusView(
              width: 60.0,
              height: 60.0,
              borderWidth: 2.0,
              textSize: 28.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.fullName ?? '---', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4.0),
                  const Text('Start a conversation', style: TextStyle(fontSize: 14.0, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
