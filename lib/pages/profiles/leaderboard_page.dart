import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  Widget _buildRankCard({
    required BuildContext ctx,
    required String rank,
    required Color xpColor,
    required int score,
    required double size,
    required UserScoreModel user,
  }) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(ctx, id: user.id, score: score),
      builder: (context, viewModel, _) {
        var userData = viewModel.owner;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rank,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            userData == null
            ? ShimmerContainer(
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            )
            : Stack(
              children: [
                userData.avatarStatusView(
                  width: size,
                  height: size,
                  borderWidth: 3.0,
                  textSize: 18.0,
                  showStatus: false,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              userData?.fullName ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              score.toString(),
              style: TextStyle(
                color: xpColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }
    );    
  }

  Widget _buildPodium(BuildContext ctx, List<UserScoreModel> users, bool isWeekly) {
  if (users.length < 3) {
    return Center(child: Text("Not enough data yet"));
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF123267), Color(0xFF1C2025)],
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildRankCard(ctx: ctx, user: users[1], rank: "2nd",
          score: isWeekly ? users[1].xpWeek : users[1].xpTotal,
          xpColor: Colors.greenAccent, size: 90),
        _buildRankCard(ctx: ctx, user: users[0], rank: "1st",
          score: isWeekly ? users[0].xpWeek : users[0].xpTotal,
          xpColor: Colors.yellowAccent, size: 120),
        _buildRankCard(ctx: ctx, user: users[2], rank: "3rd",
          score: isWeekly ? users[2].xpWeek : users[2].xpTotal,
          xpColor: Colors.cyanAccent, size: 90),
      ],
    ),
  );
}


  Widget _buildLeaderboardList(BuildContext context, List<UserScoreModel> data, bool isWeekly) {
  if (data.length < 3) {
    return Center(child: Text("Not enough players yet"));
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        _buildPodium(context, data, isWeekly),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final user = data[i];
              final value = isWeekly ? user.xpWeek : user.xpTotal;
    
              return LeaderboardUserView(
                key: ValueKey('${user.id}-${isWeekly ? "week" : "total"}'),
                user: user,
                score: value,
                cellIndex: i,
                displayProgress: !isWeekly
              );
            },
            separatorBuilder: (_, __) => const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaderboardProvider>.reactive(
      viewModelBuilder: () => LeaderboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AIColors.leaderBoardBackground,
            appBar: AppBar(
              title: Text('Leaderboard'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushNamed(context, '/main', arguments: null),
              ),
              centerTitle: true,
              flexibleSpace: AppBackgroundView(),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {
                  viewModel.tabIndex = index;
                },
                tabs: [
                  Tab(
                    child: Text(
                      'This Week',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'All Time',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildLeaderboardList(context, viewModel.weeklyLeaderboard, true),
                _buildLeaderboardList(context, viewModel.totalLeaderboard, false),
              ],
            ),
          ),
        );
      },
    );
  }
}
