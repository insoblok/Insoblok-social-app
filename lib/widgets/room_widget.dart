import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
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
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!(viewModel.chatUser!);
              }
            },
            child: viewModel.chatUser == null ? Opacity(opacity: 0) : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withAlpha(0),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.transparent,
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (viewModel.chatUser != null)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0), 
                            child: viewModel.chatUser!.avatarStatusView(
                              width: kAvatarSize,
                              height: kAvatarSize,
                              borderWidth: 2.0,
                              textSize: 28.0,
                            )
                          )
                        else
                          Opacity(
                            opacity: 0,
                            child: SizedBox(
                              width: kAvatarSize ?? 60.0,
                              height: kAvatarSize ?? 60.0
                            )
                          ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          viewModel.chatUser?.fullName ?? '---',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        
                                      ],
                                    ),
                                    Text(
                                      room.updateDate?.timeago ?? '',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: AIColors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // room.content ?? '@${room.id}',
                                      room.content ?? 'New User',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: AIColors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Opacity(
                                        opacity: viewModel.unreadMsgCnt > 0 ? 1 : 0,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 12),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: viewModel.unreadMsgCnt < 10 ? BoxShape.circle : BoxShape.rectangle,
                                                borderRadius: viewModel.unreadMsgCnt < 10 ? null : BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                '${viewModel.unreadMsgCnt}',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  
                                  ]
                                )
                              ]
                            ),
                            /*
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    
                                    
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 2.0),
                                      ]
                                ),
                              ],
                            ),
                            */
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
                        
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.3,
                    color: Colors.grey.withOpacity(0.5),
                    indent: kAvatarSize + 14
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
