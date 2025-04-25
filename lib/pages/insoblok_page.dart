import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class InSoBlokPage extends StatelessWidget {
  const InSoBlokPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [DashboardView(), SearchView(), NotificationView(), ChatView()];
    var titles = ['Home', 'Trends', 'Notifications', 'Messages'];
    var selectedIcon = [
      AIImages.icBottomHomeFill,
      AIImages.icBottomSearchFill,
      AIImages.icBottomNotiFill,
      AIImages.icBottomMessageFill,
    ];

    var unselectedIcon = [
      AIImages.icBottomHome,
      AIImages.icBottomSearch,
      AIImages.icBottomNoti,
      AIImages.icBottomMessage,
    ];

    var menuTitles = ['Profile', 'Lists', 'Topics', 'Bookmarks', 'Moments'];
    var menuIcons = [
      AIImages.icMenuProfile,
      AIImages.icMenuLists,
      AIImages.icMenuTopics,
      AIImages.icMenuBookmarks,
      AIImages.icMenuMoments,
    ];

    return ViewModelBuilder<InSoBlokProvider>.reactive(
      viewModelBuilder: () => InSoBlokProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            drawer: Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: viewModel.onClickMenuAvatar,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: AIImage(
                                      viewModel.user?.avatar,
                                      width: 55.0,
                                      height: 55.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  viewModel.user?.fullName ?? '---',
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                Text(
                                  '@${viewModel.user?.fullName}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: viewModel.onClickMenuMore,
                              child: AIImage(AIImages.icCircleMore),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '216',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' Following  ',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextSpan(
                                text: '  117',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' Followers',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.33),
                  for (var i = 0; i < 5; i++) ...{
                    MenuButtonCover(
                      onTap: () => viewModel.onClickMenuItem(i),
                      child: Row(
                        children: [
                          AIImage(menuIcons[i], width: 20.0),
                          const SizedBox(width: 20.0),
                          Text(
                            menuTitles[i],
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                    ),
                  },
                  const Divider(thickness: 0.33),
                  MenuButtonCover(
                    onTap: () => viewModel.onClickMenuItem(5),
                    child: Text(
                      'Settings and privacy',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  MenuButtonCover(
                    onTap: () => viewModel.onClickMenuItem(6),
                    child: Text(
                      'Help Center',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  const Spacer(),
                  MenuButtonCover(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => viewModel.onClickMenuItem(7),
                          child: AIImage(AIImages.icMenuUnion),
                        ),
                        InkWell(
                          onTap: () => viewModel.onClickMenuItem(8),
                          child: AIImage(AIImages.icMenuQrCode),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
            body: pages[viewModel.pageIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.pageIndex,
              onTap: (value) => viewModel.pageIndex = value,
              items: [
                for (var i = 0; i < 4; i++) ...{
                  BottomNavigationBarItem(
                    icon: AIImage(
                      viewModel.pageIndex == i
                          ? selectedIcon[i]
                          : unselectedIcon[i],
                      width: 18.0,
                      height: 18.0,
                    ),
                    label: titles[i],
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }
}
