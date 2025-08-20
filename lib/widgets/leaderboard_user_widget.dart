import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kUserAvatarSize = 56.0;

class LeaderboardUserView extends StatelessWidget {
  final String userId;
  final int score;
  final int cellIndex;

  const LeaderboardUserView({
    super.key,
    required this.userId,
    required this.score,
    required this.cellIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, id: userId, score: score),
      builder: (context, viewModel, _) {
        var userData = viewModel.owner;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: InkWell(
            onTap: viewModel.goToTastescorePage,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: viewModel.getRankColor(cellIndex),
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
                      : Stack(
                        children: [
                          userData.avatarStatusView(
                            width: kUserAvatarSize,
                            height: kUserAvatarSize,
                            borderWidth: 3.0,
                            textSize: 18.0,
                            showStatus: false,
                          ),
                          if (cellIndex == 0)
                            Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: Container(
                              width: 24.0,
                              height: 24.0,
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: AIImage(
                                AIImages.imgLevel(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4.0,
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
                            : Text(
                              userData.fullName,
                              style: Theme.of(context).textTheme.bodyMedium,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        score.toString(),
                        style: TextStyle(
                          fontSize: 26.0,
                          color: AIColors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' XP',
                        style: TextStyle(fontSize: 18.0, color: AIColors.pink),
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
