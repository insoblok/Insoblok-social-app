import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(16),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withAlpha(16),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.chatUser != null)
                    viewModel.chatUser!.avatarStatusView(
                      width: kAvatarSize,
                      height: kAvatarSize,
                      borderWidth: 2.0,
                      textSize: 18.0,
                    )
                  else
                    Opacity(
                      opacity: 0,
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
                              room.updateDate?.timeago ?? '',
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
                  if (viewModel.isTyping)
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: [Theme.of(context).primaryColor],
                        strokeWidth: 2,
                      ),
                    ),
                  if (viewModel.unreadMsgCnt > 0)
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            '${viewModel.unreadMsgCnt}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AIColors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
