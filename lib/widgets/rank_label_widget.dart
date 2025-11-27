import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:collection/collection.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';

class RankLabelWidget extends StatelessWidget {
  final String userId;
  const RankLabelWidget({super.key, required this.userId});

  /// Get rank by user ID from the full leaderboard (not filtered)
  /// Returns the actual rank (1-based), or 0 if user not found
  int getRankByUserId(String id, List<UserScoreModel> fullLeaderboard) {
    if (fullLeaderboard.isEmpty || id.isEmpty) return 0;

    // Sort by total XP (descending) to get the correct ranking
    final sortedList = fullLeaderboard.sorted((b, a) => a.xpTotal - b.xpTotal);

    // Find the user's position in the sorted list
    for (int i = 0; i < sortedList.length; i++) {
      if (sortedList[i].id == id) {
        return i + 1; // Rank is 1-based (1st, 2nd, 3rd, etc.)
      }
    }
    return 0; // User not found in leaderboard
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaderboardProvider>.reactive(
      viewModelBuilder: () => LeaderboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        // Use the full leaderboard list (not filtered) to get accurate rank
        // This ensures we can find users ranked beyond the top 50
        int rank = getRankByUserId(userId, viewModel.leaderboard);

        // Only hide if rank is 0 (user not found in leaderboard)
        // Otherwise show the rank (can be any number >= 1)
        return rank == 0
            ? Container()
            : Container(
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(fontSize: 12),
                  ),
                ],
              ),
            );
      },
    );
  }
}
