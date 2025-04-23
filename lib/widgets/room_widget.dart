import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';

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
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 0.5, color: Colors.white)),
            ),
          );
        }
        return InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!(viewModel.chatUser!);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 0.5, color: Colors.white)),
            ),
            child: Row(
              children: [
                viewModel.chatUser!.avatarStatusView(width: 60.0, height: 60.0),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${viewModel.chatUser?.fullName}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            '${room.recentDate}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        '${room.content}',
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }
}
