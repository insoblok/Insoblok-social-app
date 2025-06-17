import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';

const kAvatarSize = 44.0;

class RoomItemView extends StatelessWidget {
  final RoomModel room;
  final Function(UserModel chatUser)? onTap;

  const RoomItemView({super.key, required this.room, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RoomProvider>.reactive(
      viewModelBuilder: () => RoomProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: room),
      builder: (context, viewModel, _) {
        if (viewModel.isBusy) {
          return Container();
        }
        return InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!(viewModel.chatUser!);
            }
          },
          child: Container(
            height: 80.0,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AIColors.speraterColor, width: 0.33),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                viewModel.chatUser!.avatarStatusView(
                  width: kAvatarSize,
                  height: kAvatarSize,
                  borderWidth: 2.0,
                  textSize: 18.0,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            viewModel.chatUser?.fullName ?? '---',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            room.timestamp?.timeago ?? '',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: AIColors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        // room.content ?? '@${room.id}',
                        room.content ?? 'New User',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: AIColors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
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
