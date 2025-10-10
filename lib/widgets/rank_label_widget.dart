import 'package:flutter/material.dart';
import 'package:insoblok/utils/const.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';

class RankLabelWidget extends StatelessWidget {
  final String userId;
  const RankLabelWidget({super.key, required this.userId});
  
  int getRankByUserId(String id, List<UserScoreModel> lists) {
    for (int i = 0; i < lists.length; i ++) {
      if (lists[i].id == id) return i + 1;
    }
    return -1;
  }
  
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaderboardProvider>.reactive(
      viewModelBuilder: () => LeaderboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        int rank = getRankByUserId(userId, viewModel.totalLeaderboard);
        return rank > LEADER_BOARD_DISPLAY_LENGTH ? Container() : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black.withAlpha(180),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
          child: Row(
            children: [
              AIImage(
                'assets/images/img_level_0${viewModel.accountService.userLevel.level}.png',
                width: 21.0,
                height: 21.0,
              ),
              SizedBox(width: 6.0),
              Text(
                "Rank: $rank",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          )
        );
      }
    );

  }
}