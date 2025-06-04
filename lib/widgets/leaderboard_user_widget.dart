import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';

const kUserAvatarSize = 56.0;

class LeaderboardUserView extends StatelessWidget {
  final UserModel user;
  final String date;

  const LeaderboardUserView({
    super.key,
    required this.user,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, uid: user.uid!, date: date),
      builder: (context, viewModel, _) {
        var userData = viewModel.owner;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: viewModel.goToDetailPage,
                child: user.avatarStatusView(
                  width: kUserAvatarSize,
                  height: kUserAvatarSize,
                  borderWidth: 3.0,
                  textSize: 18.0,
                  showStatus: false,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: user.fullName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: ' @${user.nickId}',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      userData?.timestamp?.timeago ?? '10m ago',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Text(
                viewModel.userScore.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
