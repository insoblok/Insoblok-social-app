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
        return Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: AppLeadingView(),
                  pinned: true,
                  floating: false,
                  centerTitle: true,
                  elevation: 1.0,
                  title: Text('Messages'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: AIImage(
                        AIImages.icSetting,
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ],
                  expandedHeight: 45.0 + 45.0 + 10.0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.none,
                    background: Container(
                      margin: EdgeInsets.only(top: 45 + 32.0),
                      height: 45.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: AIColors.darkGreyBackground,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              AIImage(
                                AIImages.icBottomSearch,
                                width: 14.0,
                                height: 14.0,
                              ),
                              const SizedBox(width: 6.0),
                              Text(
                                'Search for people and groups',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
                            onTap:
                                (chatUser) => Routers.goToMessagePage(
                                  context,
                                  MessagePageData(
                                    room: room,
                                    chatUser: chatUser,
                                  ),
                                ),
                          );
                        }),
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                      ]),
                    ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomFloatingButton(
                onTap: () => Routers.goToCreateRoomPage(context),
                src: AIImages.icAddMessage,
              ),
            ),
          ],
        );
      },
    );
  }
}
