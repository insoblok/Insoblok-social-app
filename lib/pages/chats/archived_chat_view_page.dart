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

class ArchivedChatViewPage extends StatelessWidget {
  const ArchivedChatViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatProvider>.reactive(
      viewModelBuilder: () => ChatProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, child) { 
        logger.d("This is  list item builder function ${DateTime.now()}");
        return Scaffold(
        appBar: AppBar(
          leading: viewModel.isSelectionMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => viewModel.clearSelection(),
              )
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
          title: viewModel.isSelectionMode
            ? Text('${viewModel.selectedRoomIds.length} selected')
            : const Text('Archived Chats'),
          centerTitle: true,
          actions: viewModel.isSelectionMode
            ? [
                IconButton(
                  icon: Icon(Icons.unarchive),
                  onPressed: () => viewModel.unarchiveSelectedRooms(),
                ),
                IconButton(
                  icon: Icon(Icons.volume_off),
                  onPressed: () => viewModel.unarchiveSelectedRooms(),
                ),
                
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => viewModel.deleteSelectedRooms(),
                ),
              ]
            : null,
        ),
        body: viewModel.isBusy
          ? Center(child: Loader(size: 60))
          : viewModel.archivedRooms.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.archive, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No Archived Chats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Archived chats will appear here', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                itemCount: viewModel.archivedRooms.length,
                itemBuilder: (context, index) {
                  final room = viewModel.archivedRooms[index];
                  logger.d("THis is ui archive room: ${room.id}");
                  return RoomItemView(
                    room: room,
                    onTap: (BuildContext ctx, UserModel u) {
                      Routers.goToMessagePage(
                        ctx,
                        MessagePageData(room: room.chatroom, chatUser: u),
                      );
                    },
                    isSelected: viewModel.selectedRoomIds.contains(room.id),
                    isSelectionMode: viewModel.isSelectionMode,
                    onLongPress: viewModel.toggleRoomSelection,
                    onSelectionTap: viewModel.toggleRoomSelection,
                  );
                },
              ),
        );
      }
    );
  }
} 
