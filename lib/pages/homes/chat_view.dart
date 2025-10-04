import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatProvider>.reactive(
      viewModelBuilder: () => ChatProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            leading: AppLeadingView(),
            title: AITextField(
              prefixIcon: Icon(Icons.search),
              hintText: "Search people, rooms, etc ...",
              focusedColor: Colors.grey,
            ),
            actions: [
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
                : (viewModel.sortedRooms.isEmpty && viewModel.suggestedUsers.isEmpty)
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
                    : NotificationListener<ScrollNotification>(
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
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          // Prebuild ~1.5 screen heights for smoother scrolling
                          cacheExtent: MediaQuery.of(context).size.height * 1.5,
                          itemCount: _totalItems(viewModel),
                          itemBuilder: (context, index) {
                            return _buildSectionedItem(context, viewModel, index);
                          },
                        ),
                      ),
          ),
        );
      },
    );
  }
}

int _totalItems(ChatProvider vm) {
  // 2 section headers if both non-empty; else 1 if one is non-empty; 0 if none
  final roomsCount = vm.roomsVisibleCount;
  final usersCount = vm.usersVisibleCount;
  final hasRooms = roomsCount > 0;
  final hasUsers = usersCount > 0;
  final headers = (hasRooms && hasUsers) ? 2 : (hasRooms || hasUsers) ? 1 : 0;
  return roomsCount + usersCount + headers;
}

Widget _buildSectionedItem(BuildContext context, ChatProvider vm, int index) {
  final hasRooms = vm.roomsVisibleCount > 0;
  final hasUsers = vm.usersVisibleCount > 0;

  int cursor = 0;

  // Rooms header
  if (hasRooms) {
    // if (index == cursor) {
    //   return _SectionHeader(title: 'Rooms');
    // }
    cursor += 1;
    final roomsStart = cursor;
    final roomsEnd = roomsStart + vm.roomsVisibleCount; // exclusive
    if (index >= roomsStart && index < roomsEnd) {
      final room = vm.sortedRooms[index - roomsStart];
      return RoomItemView(
        room: room,
        onTap: vm.gotoNewChat,
      );
    }
    cursor = roomsEnd;
  }

  // Suggested users header
  if (hasUsers) {
    // if (index == cursor) {
    //   return _SectionHeader(title: 'Suggested');
    // }
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

class _SuggestedUserTile extends StatelessWidget {
  final UserModel user;
  final Function(UserModel chatUser)? onTap;
  const _SuggestedUserTile({required this.user, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(user),
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
