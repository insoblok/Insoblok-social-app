import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
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
            title: Text(S.current.create_room),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.camera),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AITextField(
                        hintText: 'Search user...',
                        onChanged: (key) => viewModel.key = key,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    InkWell(
                      onTap: viewModel.searchUsers,
                      child: Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: AIColors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                ...viewModel.users.map((user) {
                  return InkWell(
                    onTap: () => viewModel.onCreateRoom(user),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipOval(
                            child: AIImage(
                              user.avatar,
                              width: 60.0,
                              height: 60.0,
                            ),
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${user.regdate}',
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
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
