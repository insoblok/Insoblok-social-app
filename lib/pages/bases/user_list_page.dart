import 'package:flutter/material.dart';
import 'package:insoblok/extensions/user_extension.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class UserListPage extends StatelessWidget {
  final List<UserModel> users;
  const UserListPage({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserListProvider>.reactive(
      viewModelBuilder: () => UserListProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, users: users),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('User List'),
            centerTitle: true,
            actions: [InkWell(child: Text('Add'))],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AITextField(
                  hintText: 'User Name',
                  prefixIcon: Icon(Icons.person_4),
                  onChanged: viewModel.updateSearch,
                ),
                if (viewModel.selectedUsers.isNotEmpty) ...{
                  const SizedBox(height: 16.0),
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: [
                      for (var user in viewModel.selectedUsers) ...{
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withAlpha(32),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            spacing: 4.0,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(user.fullName),
                              InkWell(
                                onTap: () => viewModel.selected(user),
                                child: Icon(Icons.close, size: 14.0),
                              ),
                            ],
                          ),
                        ),
                      },
                    ],
                  ),
                },
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.separated(
                    itemCount: viewModel.showUsers.length,
                    itemBuilder: (context, index) {
                      var user = viewModel.showUsers[index];
                      return UserListCell(
                        key: GlobalKey(debugLabel: 'friend-${user.id}'),
                        id: user.id!,
                        selected: viewModel.selectedUsers.contains(user),
                        onTap: () => viewModel.selected(user),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(height: 8.0);
                    },
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
