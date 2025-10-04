import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';


const kUserAvatarSize = 56.0;

class LeaderboardUserView extends StatelessWidget {
  final UserScoreModel user;
  final int score;
  final int cellIndex;
  final bool displayProgress;
  const LeaderboardUserView({
    super.key,
    required this.user,
    required this.score,
    required this.cellIndex,
    required this.displayProgress,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, id: user.id, score: score),
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
                color: AIColors.leaderBoardBackground,
                borderRadius: BorderRadius.circular(1.0),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withAlpha(40),
                    width: 2.0
                  )
                ),
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
              child: Container(
                decoration: BoxDecoration(
                  
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      (cellIndex + 1).toString(),
                      style: TextStyle(
                        fontSize: 32,
                        color: viewModel.getRankColor(cellIndex),
                      )
                    ),
                    SizedBox(width: 24),
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
                          Text(
                                userData?.fullName ?? "___",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          Text(
                                userData?.timestamp?.timeago ?? 'Unknown time',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              if(displayProgress == true)
                          AnimatiedLinearProgressIndicator(
                            value:user.indicatorValue,
                            minHeight: 6,
                            borderRadius: 12,
                            backgroundColor: AIColors.leaderBoardScoreProgressBackground,
                            color: AIColors.leaderBoardScoreProgressForeground,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 18.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          score.toString(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: viewModel.getRankColor(cellIndex)
                          ),
                        ),
                        Text(
                          ' XP',
                          style: TextStyle(fontSize: 14.0, color: viewModel.getRankColor(cellIndex)),
                          
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
