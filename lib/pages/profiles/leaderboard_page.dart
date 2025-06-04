import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

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
            body: ListView.separated(
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
                return LeaderboardUserView(userUid: user.uid, score: value);
              },
              separatorBuilder: (context, i) {
                return Container();
              },
              itemCount: viewModel.leaderboard.length,
            ),
          ),
        );
        // return Stack(
        //   children: [
        //     CustomScrollView(
        //       physics: BouncingScrollPhysics(),
        //       slivers: [
        //         AISliverAppbar(
        //           context,
        //           // leading: AppLeadingView(),
        //           pinned: true,
        //           floating: false,
        //           title: Text('Leaderboard'),

        //           extendWidget: Container(
        //             margin: const EdgeInsets.symmetric(vertical: 4.0),
        //             padding: const EdgeInsets.symmetric(
        //               horizontal: 16.0,
        //               vertical: 4.0,
        //             ),
        //             decoration: BoxDecoration(
        //               color: AppSettingHelper.greyBackground,
        //               borderRadius: BorderRadius.circular(16.0),
        //             ),
        //             alignment: Alignment.center,
        //             child: Row(
        //               children: [
        //                 AIImage(
        //                   AIImages.icBottomSearch,
        //                   width: 14.0,
        //                   height: 14.0,
        //                 ),
        //                 const SizedBox(width: 6.0),
        //                 Text(
        //                   'Search for people and groups',
        //                   style: TextStyle(
        //                     fontSize: 14.0,
        //                     color: AIColors.greyTextColor,
        //                     fontWeight: FontWeight.normal,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //         if (viewModel.isBusy) ...{
        //           SliverFillRemaining(child: Center(child: Loader(size: 60))),
        //         },
        //         SliverList(
        //           delegate: SliverChildListDelegate([
        //             ...viewModel.users.map((user) {
        //               return LeaderboardUserView(user: user!);
        //             }),
        //             SizedBox(height: MediaQuery.of(context).padding.bottom),
        //           ]),
        //         ),
        //       ],
        //     ),
        //     // Align(
        //     //   alignment: Alignment.bottomRight,
        //     //   child: CustomFloatingButton(
        //     //     onTap: () => Routers.goToCreateRoomPage(context),
        //     //     src: AIImages.icAddMessage,
        //     //   ),
        //     // ),
        //   ],
        // );
      },
    );
  }
}
