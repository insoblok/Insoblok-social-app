import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LeaderboardProvider>.reactive(
      viewModelBuilder: () => LeaderboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Leaderboard'),
              centerTitle: true,
              flexibleSpace: AppBackgroundView(),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                onTap: (index) {
                  logger.d(index);
                  viewModel.tabIndex = index;
                },
                tabs: [
                  Tab(
                    child: Text(
                      'Daily',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Weekly',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Monthly',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            body: AppBackgroundView(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  late UserScoreModel user;
                  if (viewModel.tabIndex == 0) {
                    user = viewModel.dailyLeaderboard[i];
                  }
                  if (viewModel.tabIndex == 1) {
                    user = viewModel.weeklyLeaderboard[i];
                  }
                  if (viewModel.tabIndex == 2) {
                    user = viewModel.monthlyLeaderboard[i];
                  }

                  var value = 0;
                  if (viewModel.tabIndex == 0) {
                    value = user.xpDay;
                  }
                  if (viewModel.tabIndex == 1) {
                    value = user.xpWeek;
                  }
                  if (viewModel.tabIndex == 2) {
                    value = user.xpMonth;
                  }
                  return LeaderboardUserView(
                    key: GlobalKey(
                      debugLabel: '${user.id}-${viewModel.tabIndex}',
                    ),
                    userId: user.id,
                    score: value,
                    cellIndex: i,
                  );
                },
                separatorBuilder: (context, i) {
                  return Container();
                },
                itemCount: viewModel.leaderboard.length,
              ),
            ),
          ),
        );
      },
    );
  }
}
