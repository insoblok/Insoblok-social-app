import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';

const kUserAvatarSize = 56.0;

class LeaderboardUserView extends StatelessWidget {
  final String userId;
  final int score;

  const LeaderboardUserView({
    super.key,
    required this.userId,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, id: userId),
      builder: (context, viewModel, _) {
        var userData = viewModel.owner;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: InkWell(
            onTap: viewModel.goToTastescorePage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                userData == null
                    ? ShimmerContainer(
                      child: Container(
                        width: kUserAvatarSize,
                        height: kUserAvatarSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    : userData.avatarStatusView(
                      width: kUserAvatarSize,
                      height: kUserAvatarSize,
                      borderWidth: 3.0,
                      textSize: 18.0,
                      showStatus: false,
                    ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      userData == null
                          ? ShimmerContainer(
                            child: Container(
                              width: 150.0,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          )
                          : Text.rich(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: userData.fullName,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextSpan(
                                  text: ' @${userData.nickId}',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                      userData == null
                          ? ShimmerContainer(
                            child: Container(
                              width: 80.0,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          )
                          : Text(
                            userData.timestamp?.timeago ?? '10m ago',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                    ],
                  ),
                ),
                Text(
                  score.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
