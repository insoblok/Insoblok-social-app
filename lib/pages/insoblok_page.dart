// import 'package:flutter/material.dart';

// import 'package:stacked/stacked.dart';

// import 'package:insoblok/extensions/extensions.dart';
// import 'package:insoblok/pages/pages.dart';
// import 'package:insoblok/providers/providers.dart';
// import 'package:insoblok/routers/router.dart';
// import 'package:insoblok/services/services.dart';
// import 'package:insoblok/utils/utils.dart';
// import 'package:insoblok/widgets/widgets.dart';

// class InSoBlokPage extends StatelessWidget with WidgetsBindingObserver {
//   const InSoBlokPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addObserver(this);

//     // var titles = ['Home', 'Vybe', 'Wallet', 'Chat', 'Profile'];
//     var pages = [
//       PageableView(),
//       AccountWalletPage(),
//       LookbookView(),
//       ChatView(),
//       ProfileView(),
//     ];
//     // var selectedIcon = [
//     //   AIImages.icBottomHomeFill,
//     //   AIImages.icBottomLookFill,
//     //   AIImages.icBottomWalletFill,
//     //   AIImages.icBottomMessageFill,
//     //   AIImages.icBottomUserFill,
//     // ];
//     // var unselectedIcon = [
//     //   AIImages.icBottomHome,
//     //   AIImages.icBottomLook,
//     //   AIImages.icBottomWallet,
//     //   AIImages.icBottomMessage,
//     //   AIImages.icBottomUser,
//     // ];

//     var menuTitles = [
//       'Profile',
//       'My Posts',
//       'Likes',
//       'Follows',
//       'Leaderboard',
//       'MarketPlace',
//     ];
//     var menuIcons = [
//       AIImages.icMenuProfile,
//       AIImages.icMenuLists,
//       AIImages.icMenuBookmarks,
//       AIImages.icMenuTopics,
//       AIImages.icMenuMoments,
//       AIImages.icMenuMarketPlace,
//     ];

//     return ViewModelBuilder<InSoBlokProvider>.reactive(
//       viewModelBuilder: () => InSoBlokProvider(),
//       onViewModelReady: (viewModel) => viewModel.init(context),
//       builder: (context, viewModel, _) {
//         return PopScope(
//           canPop: false,
//           child: Scaffold(
//             drawer: Drawer(
//               width: MediaQuery.of(context).size.width / 2,
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//               child: Column(
//                 children: [
//                   SizedBox(height: MediaQuery.of(context).padding.top),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24.0,
//                       vertical: 16.0,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 InkWell(
//                                   onTap: viewModel.onClickMenuAvatar,
//                                   child: AIAvatarImage(
//                                     viewModel.user?.avatar,
//                                     width: kStoryDetailAvatarSize,
//                                     height: kStoryDetailAvatarSize,
//                                     fullname:
//                                         viewModel.user?.fullName ?? 'Test',
//                                     textSize: 24,
//                                     isBorder: true,
//                                     borderWidth: 1.5,
//                                     borderRadius: kStoryDetailAvatarSize / 2,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8.0),
//                                 Text(
//                                   viewModel.user?.fullName ?? '---',
//                                   style:
//                                       Theme.of(context).textTheme.displayLarge,
//                                 ),
//                                 Text(
//                                   viewModel.user!.nickId!.isEmpty
//                                       ? '@${viewModel.user?.fullName}'
//                                       : '@${viewModel.user?.nickId}',
//                                   style: Theme.of(context).textTheme.labelLarge,
//                                 ),
//                               ],
//                             ),
//                             InkWell(
//                               onTap: viewModel.onClickMenuMore,
//                               child: AIImage(
//                                 AIImages.icSetting,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16.0),
//                         Text.rich(
//                           TextSpan(
//                             children: [
//                               TextSpan(
//                                 text:
//                                     (AuthHelper.user?.likes?.length ?? 0)
//                                         .socialValue,
//                                 style: Theme.of(context).textTheme.bodySmall,
//                               ),
//                               TextSpan(
//                                 text: ' Likes  ',
//                                 style: Theme.of(context).textTheme.labelMedium,
//                               ),
//                               TextSpan(
//                                 text:
//                                     '  ${(AuthHelper.user?.follows?.length ?? 0).socialValue}',
//                                 style: Theme.of(context).textTheme.bodySmall,
//                               ),
//                               TextSpan(
//                                 text: ' Followers',
//                                 style: Theme.of(context).textTheme.labelMedium,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(thickness: 0.2),
//                   for (var i = 0; i < menuTitles.length; i++) ...{
//                     MenuButtonCover(
//                       onTap: () => viewModel.onClickMenuItem(i),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 24.0,
//                             alignment: Alignment.center,
//                             child: AIImage(
//                               menuIcons[i],
//                               height: 24.0,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                           const SizedBox(width: 20.0),
//                           Text(menuTitles[i], style: TextStyle(fontSize: 16.0)),
//                         ],
//                       ),
//                     ),
//                   },
//                   const Divider(thickness: 0.2),
//                   const SizedBox(height: 12.0),
//                   MenuButtonCover(
//                     onTap: () => viewModel.onClickPrivacy(),
//                     child: Text(
//                       'Privacy and Policy',
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                   ),
//                   MenuButtonCover(
//                     onTap: () => viewModel.onClickMenuItem(7),
//                     child: Text(
//                       'Help Center',
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                   ),
//                   const Spacer(),
//                   MenuButtonCover(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: () => viewModel.onClickMenuItem(8),
//                           child: AIImage(
//                             AIImages.icMenuUnion,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () => viewModel.onClickMenuItem(9),
//                           child: AIImage(
//                             AIImages.icMenuQrCode,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: MediaQuery.of(context).padding.bottom),
//                 ],
//               ),
//             ),
//             body: pages[viewModel.pageIndex],
//             floatingActionButton: InkWell(
//               onTap: () {
//                 viewModel.goToAddPost();
//               },
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 margin: EdgeInsets.only(top: 36),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor,
//                   borderRadius: BorderRadius.circular(30.0),
//                   border: Border.all(color: Theme.of(context).primaryColor),
//                 ),
//                 alignment: Alignment.center,
//                 child: Icon(Icons.add, size: 32, color: AIColors.white),
//               ),
//             ),
//             floatingActionButtonLocation:
//                 FloatingActionButtonLocation.centerDocked,
//             bottomNavigationBar: AppBackgroundView(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(24),
//                   topRight: Radius.circular(24),
//                 ),
//                 child: Stack(
//                   children: [
//                     AppBackgroundView(height: kBottomNavigationBarHeight),
//                     BottomNavigationBar(
//                       backgroundColor: AIColors.transparent,
//                       elevation: 0.0,
//                       showSelectedLabels: true,
//                       showUnselectedLabels: true,
//                       currentIndex: viewModel.pageIndex,
//                       onTap: (value) {
//                         if (value == 4) {
//                           Routers.goToAccountPage(context);
//                         } else if (value != 2) {
//                           viewModel.pageIndex = value;
//                         }
//                         if (value != 4) viewModel.dotIndex = value;
//                       },
//                       items: [
//                         BottomNavigationBarItem(
//                           icon: AIImage(
//                             AIImages.icBottomHome,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.white,
//                           ),
//                           activeIcon: AIImage(
//                             AIImages.icBottomHomeFill,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.pink,
//                           ),
//                           label: 'Home',
//                           backgroundColor: AIColors.pink,
//                         ),
//                         BottomNavigationBarItem(
//                           icon: AIImage(
//                             AIImages.icBottomWallet,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.white,
//                           ),
//                           activeIcon: AIImage(
//                             AIImages.icBottomWalletFill,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.pink,
//                           ),
//                           label: 'Wallet',
//                           backgroundColor: AIColors.pink,
//                         ),
//                         BottomNavigationBarItem(
//                           icon: SizedBox.shrink(), // Empty item for the center
//                           label: '',
//                         ),
//                         BottomNavigationBarItem(
//                           icon: AIImage(
//                             AIImages.icBottomMessage,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.white,
//                           ),
//                           activeIcon: AIImage(
//                             AIImages.icBottomMessageFill,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.pink,
//                           ),
//                           label: 'Chat',
//                           backgroundColor: AIColors.pink,
//                         ),
//                         BottomNavigationBarItem(
//                           icon: AIImage(
//                             AIImages.icBottomUser,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.white,
//                           ),
//                           activeIcon: AIImage(
//                             AIImages.icBottomUserFill,
//                             width: 18.0,
//                             height: 18.0,
//                             color: AIColors.pink,
//                           ),
//                           label: 'Profile',
//                           backgroundColor: AIColors.pink,
//                         ),
//                         // for (var i = 0; i < selectedIcon.length; i++) ...{
//                         //   BottomNavigationBarItem(
//                         //     icon: AIImage(
//                         //       unselectedIcon[i],
//                         //       width: 18.0,
//                         //       height: 18.0,
//                         //       color: AIColors.lightGrey,
//                         //     ),
//                         //     activeIcon: AIImage(
//                         //       selectedIcon[i],
//                         //       width: 18.0,
//                         //       height: 18.0,
//                         //       color: AIColors.pink,
//                         //     ),
//                         //     label: titles[i],
//                         //     backgroundColor: AIColors.pink,
//                         //   ),
//                         // },
//                       ],
//                     ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: [
//     for (int i = 0; i < 5; i++) ...{
//       Container(
//         width: 8,
//         height: 8,
//         margin: EdgeInsets.only(top: 50),
//         decoration: BoxDecoration(
//           color:
//               viewModel.dotIndex == i
//                   ? Theme.of(context).primaryColor
//                   : AIColors.transparent,
//           borderRadius: BorderRadius.circular(4.0),
//         ),
//       ),
//     },
//   ],
// ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       // MessageHelper.updateTypingStatus(false);
//       AuthHelper.updateStatus('Offline');
//     }
//   }
// }

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

    // var titles = ['Home', 'Vybe', 'Wallet', 'Chat', 'Profile'];
    var pages = [
      PageableView(),
      AccountWalletPage(),
      LookbookView(),
      ChatView(),
      ProfileView(),
    ];
    // var selectedIcon = [
    //   AIImages.icBottomHomeFill,
    //   AIImages.icBottomLookFill,
    //   AIImages.icBottomWalletFill,
    //   AIImages.icBottomMessageFill,
    //   AIImages.icBottomUserFill,
    // ];
    // var unselectedIcon = [
    //   AIImages.icBottomHome,
    //   AIImages.icBottomLook,
    //   AIImages.icBottomWallet,
    //   AIImages.icBottomMessage,
    //   AIImages.icBottomUser,
    // ];

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
            resizeToAvoidBottomInset: false,
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
                                    borderWidth: 1.5,
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
            body: Stack(
              children: [
                AppBackgroundView(child: pages[viewModel.pageIndex]),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 4.0,
                      right: 4.0,
                      bottom: MediaQuery.of(context).padding.bottom,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: BottomBarBackgroundView(
                            height: 56,
                            child: Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        viewModel.pageIndex = 0;
                                        viewModel.dotIndex = 0;
                                      },
                                      icon:
                                          viewModel.pageIndex == 0
                                              ? AIImages.icBottomHomeFill
                                              : AIImages.icBottomHome,
                                      label: 'Home',
                                      color:
                                          viewModel.pageIndex == 0
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        viewModel.pageIndex = 1;
                                        viewModel.dotIndex = 1;
                                      },
                                      icon:
                                          viewModel.pageIndex == 1
                                              ? AIImages.icBottomWalletFill
                                              : AIImages.icBottomWallet,
                                      label: 'Wallet',
                                      color:
                                          viewModel.pageIndex == 1
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        viewModel.pageIndex = 3;
                                        viewModel.dotIndex = 3;
                                      },
                                      icon:
                                          viewModel.pageIndex == 3
                                              ? AIImages.icBottomMessageFill
                                              : AIImages.icBottomMessage,
                                      label: 'Chat',
                                      color:
                                          viewModel.pageIndex == 3
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        Routers.goToAccountPage(context);
                                      },
                                      icon:
                                          viewModel.pageIndex == 4
                                              ? AIImages.icBottomUserFill
                                              : AIImages.icBottomUser,
                                      label: 'Profile',
                                      color:
                                          viewModel.pageIndex == 4
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (int i = 0; i < 5; i++) ...{
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.only(top: 52),
                                decoration: BoxDecoration(
                                  color:
                                      viewModel.dotIndex == i
                                          ? Theme.of(context).primaryColor
                                          : AIColors.transparent,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              ),
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      viewModel.goToAddPost();
                    },
                    child: Container(
                      width: 64,
                      height: 64,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 6,
                      ),
                      decoration: BoxDecoration(
                        color: AIColors.grey,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(26.0),
                        ),
                        child: Icon(Icons.add, size: 36, color: AIColors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // MessageHelper.updateTypingStatus(false);
      AuthHelper.updateStatus('Offline');
    }
  }
}
