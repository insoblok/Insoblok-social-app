import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/router.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class InSoBlokPage extends StatelessWidget with WidgetsBindingObserver {
  const InSoBlokPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);

    var titles = ['Home', 'Vybe', 'Closet', 'Messages', 'Profile'];
    var pages = [
      DashboardView(),
      LookbookView(),
      AccountWalletPage(),
      ChatView(),
      ProfileView(),
    ];
    var selectedIcon = [
      AIImages.icBottomHomeFill,
      AIImages.icBottomLookFill,
      AIImages.icBottomWalletFill,
      AIImages.icBottomMessageFill,
      AIImages.icBottomUserFill,
    ];
    var unselectedIcon = [
      AIImages.icBottomHome,
      AIImages.icBottomLook,
      AIImages.icBottomWallet,
      AIImages.icBottomMessage,
      AIImages.icBottomUser,
    ];

    var menuTitles = [
      'Profile',
      'My Posts',
      'Likes',
      'Follows',
      'Leaderboard',
      'MarketPlace',
    ];
    var menuIcons = [
      AIImages.icMenuProfile,
      AIImages.icMenuLists,
      AIImages.icMenuBookmarks,
      AIImages.icMenuTopics,
      AIImages.icMenuMoments,
      AIImages.icMenuMarketPlace,
    ];

    return ViewModelBuilder<InSoBlokProvider>.reactive(
      viewModelBuilder: () => InSoBlokProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            drawer: Drawer(
              width: MediaQuery.of(context).size.width / 2,
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
                                  child: AIAvatarImage(
                                    viewModel.user?.avatar,
                                    width: kStoryDetailAvatarSize,
                                    height: kStoryDetailAvatarSize,
                                    fullname:
                                        viewModel.user?.fullName ?? 'Test',
                                    textSize: 24,
                                    isBorder: true,
                                    borderRadius: kStoryDetailAvatarSize / 2,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  viewModel.user?.fullName ?? '---',
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                Text(
                                  viewModel.user!.nickId!.isEmpty
                                      ? '@${viewModel.user?.fullName}'
                                      : '@${viewModel.user?.nickId}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: viewModel.onClickMenuMore,
                              child: AIImage(
                                AIImages.icSetting,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    (AuthHelper.user?.likes?.length ?? 0)
                                        .socialValue,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' Likes  ',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              TextSpan(
                                text:
                                    '  ${(AuthHelper.user?.follows?.length ?? 0).socialValue}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextSpan(
                                text: ' Followers',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 0.2),
                  for (var i = 0; i < menuTitles.length; i++) ...{
                    MenuButtonCover(
                      onTap: () => viewModel.onClickMenuItem(i),
                      child: Row(
                        children: [
                          Container(
                            width: 24.0,
                            alignment: Alignment.center,
                            child: AIImage(
                              menuIcons[i],
                              height: 24.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Text(menuTitles[i], style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    ),
                  },
                  const Divider(thickness: 0.2),
                  const SizedBox(height: 12.0),
                  MenuButtonCover(
                    onTap: () => viewModel.onClickPrivacy(),
                    child: Text(
                      'Privacy and Policy',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  MenuButtonCover(
                    onTap: () => viewModel.onClickMenuItem(7),
                    child: Text(
                      'Help Center',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const Spacer(),
                  MenuButtonCover(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => viewModel.onClickMenuItem(8),
                          child: AIImage(
                            AIImages.icMenuUnion,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        InkWell(
                          onTap: () => viewModel.onClickMenuItem(9),
                          child: AIImage(
                            AIImages.icMenuQrCode,
                            color: Theme.of(context).primaryColor,
                          ),
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
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: viewModel.pageIndex,
              onTap: (value) {
                if (value == 4) {
                  Routers.goToAccountPage(context);
                } else {
                  viewModel.pageIndex = value;
                }
              },
              items: [
                for (var i = 0; i < selectedIcon.length; i++) ...{
                  BottomNavigationBarItem(
                    icon: AIImage(
                      unselectedIcon[i],
                      width: 18.0,
                      height: 18.0,
                      color: AIColors.lightGrey,
                    ),
                    activeIcon: AIImage(
                      selectedIcon[i],
                      width: 18.0,
                      height: 18.0,
                      color: AIColors.pink,
                    ),
                    label: titles[i],
                    backgroundColor: AIColors.pink,
                  ),
                },
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.resumed) {
    //   AuthHelper.updateStatus('Online');
    // } else {
    //   AuthHelper.updateStatus('Offline');
    // }
  }
}
