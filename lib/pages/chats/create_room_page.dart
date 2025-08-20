import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class CreateRoomPage extends StatelessWidget {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateRoomProvider>.reactive(
      viewModelBuilder: () => CreateRoomProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Select User'),
            centerTitle: true,
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.camera))],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ...viewModel.users.map((user) {
                  return InkWell(
                    onTap: () => viewModel.onCreateRoom(user),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 0.5,
                            color: AIColors.lightGrey,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          user.avatarStatusView(
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
                                Text(
                                  '${user.lastName} ${user.firstName}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${user.timestamp?.timeago}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: AIColors.grey,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
