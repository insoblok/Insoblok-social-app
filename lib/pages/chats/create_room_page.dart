import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:stacked/stacked.dart';

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
          appBar: AppBar(title: Text('Select User'), centerTitle: true),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AITextField(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search),
                  onChanged: (value) => viewModel.updateSearchKey(value),
                ),
              ),
              // Content
              Expanded(
                child:
                    viewModel.isBusy
                        ? Center(child: Loader(size: 60.0))
                        : viewModel.users.isEmpty
                        ? InSoBlokEmptyView(desc: 'No users found')
                        : ListView.builder(
                          itemCount: viewModel.users.length,
                          itemBuilder: (context, index) {
                            final user = viewModel.users[index];
                            final isDisabled =
                                viewModel.isCreatingRoom || viewModel.isBusy;
                            return InkWell(
                              onTap:
                                  isDisabled
                                      ? null
                                      : () => viewModel.onCreateRoom(user),
                              child: Opacity(
                                opacity: isDisabled ? 0.5 : 1.0,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${user.lastName} ${user.firstName}',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (user.timestamp != null)
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
                                      if (viewModel.isCreatingRoom)
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.check_circle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
