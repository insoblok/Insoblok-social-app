import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
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
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text(S.current.chat),
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () => Routers.goToCreateRoomPage(context),
                  icon: Icon(Icons.add_circle),
                ),
              ],
            ),
            viewModel.rooms.isEmpty
                ? SliverFillRemaining(
                    child: Center(
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
                            S.current.create_room,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60.0,
                            ),
                            child: Text(
                              S.current.room_create_detail,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 24.0),
                      ...viewModel.rooms.map((room) {
                        return RoomItemView(
                          room: room,
                          onTap: (chatUser) => Routers.goToMessagePage(
                            context,
                            MessagePageData(room: room, chatUser: chatUser),
                          ),
                        );
                      }),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      ),
                    ]),
                  ),
          ],
        );
      },
    );
  }
}
