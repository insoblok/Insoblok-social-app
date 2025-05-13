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

    var titles = ['Home', 'LookBook', 'Market', 'Messages', 'User'];
    var pages = [
      DashboardView(),
      LookbookView(),
      MarketView(),
      ChatView(),
      ProfileView(),
    ];
    var selectedIcon = [
      AIImages.icBottomHomeFill,
      AIImages.icBottomLookFill,
      AIImages.icBottomMarketFill,
      AIImages.icBottomMessageFill,
      AIImages.icBottomUserFill,
    ];
    var unselectedIcon = [
      AIImages.icBottomHome,
      AIImages.icBottomLook,
      AIImages.icBottomMarket,
      AIImages.icBottomMessage,
      AIImages.icBottomUser,
    ];

    var menuTitles = ['Profile', 'My Posts', 'Likes', 'Follows', 'Moments'];
    var menuIcons = [
      AIImages.icMenuProfile,
      AIImages.icMenuLists,
      AIImages.icMenuBookmarks,
      AIImages.icMenuTopics,
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
              backgroundColor: AIColors.pink,
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
                                  child: ClipOval(
                                    child: AIImage(
                                      viewModel.user?.avatar,
                                      width: kStoryDetailAvatarSize,
                                      height: kStoryDetailAvatarSize,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  viewModel.user?.fullName ?? '---',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AIColors.white,
                                  ),
                                ),
                                Text(
                                  '@${viewModel.user?.nickId}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: AIColors.white,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: viewModel.onClickMenuMore,
                              child: AIImage(
                                AIImages.icSetting,
                                color: AIColors.white,
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AIColors.white,
                                ),
                              ),
                              TextSpan(
                                text: ' Likes  ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AIColors.white,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '  ${(AuthHelper.user?.follows?.length ?? 0).socialValue}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AIColors.white,
                                ),
                              ),
                              TextSpan(
                                text: ' Followers',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: AIColors.white,
                                ),
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
                          AIImage(
                            menuIcons[i],
                            width: 20.0,
                            color: AIColors.white,
                          ),
                          const SizedBox(width: 20.0),
                          Text(
                            menuTitles[i],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: AIColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                  const Divider(thickness: 0.33),
                  MenuButtonCover(
                    onTap: () => viewModel.onClickMenuItem(5),
                    child: Text(
                      'Privacy and Policy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: AIColors.white,
                      ),
                    ),
                  ),
                  MenuButtonCover(
                    onTap: () => viewModel.onClickMenuItem(6),
                    child: Text(
                      'Help Center',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: AIColors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  MenuButtonCover(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => viewModel.onClickMenuItem(7),
                          child: AIImage(
                            AIImages.icMenuUnion,
                            color: AIColors.white,
                          ),
                        ),
                        InkWell(
                          onTap: () => viewModel.onClickMenuItem(8),
                          child: AIImage(
                            AIImages.icMenuQrCode,
                            color: AIColors.white,
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
                      viewModel.pageIndex == i
                          ? selectedIcon[i]
                          : unselectedIcon[i],
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await AuthHelper.setUser(AuthHelper.user!.copyWith(status: 'Online'));
    } else {
      await AuthHelper.setUser(AuthHelper.user!.copyWith(status: 'Offline'));
    }
  }
}
