import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';

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
                  width: kStoryDetailAvatarSize,
                  height: kStoryDetailAvatarSize,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: viewModel.chatUser?.fullName ?? '---',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: ' @${viewModel.chatUser?.nickId}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${room.content}',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  '${room.updateDate?.timeago}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
