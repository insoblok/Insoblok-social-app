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
  InSoBlokPage({super.key});

  final TextEditingController _searchController = TextEditingController();

  void _performSearch(String query) {
    // Implement your search logic here
    print('Searching for: $query');
    // Navigate to search results or filter content
  }

  void _triggerSearch() {
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void handleTapAddPost() {}

  Widget _buildSearchBar(BuildContext context, InSoBlokProvider viewModel) {
    return Container(
      key: ValueKey('search_nav'), // Important for AnimatedSwitcher
      height: kBottomNavigationBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        // Match your AppBackgroundView styling
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Exit Button
          IconButton(
            onPressed: () {
              viewModel.exitSearch();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
          ),
          SizedBox(width: 8.0),
          // Search Input Field
          Expanded(
            child: Container(
              // height: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter Search Text ...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 6.0,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  isDense: true,
                ),
                onSubmitted: (query) {
                  // Handle search functionality
                  _performSearch(query);
                },
              ),
            ),
          ),
          SizedBox(width: 8.0),
          // Search Action Button
          IconButton(
            onPressed: () {
              // You can get the search query from a controller or trigger search
              _triggerSearch();
            },
            icon: Icon(Icons.send, color: Colors.white, size: 24.0),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalNavigationBar(
    BuildContext context,
    InSoBlokProvider viewModel,
  ) {
    return BottomNavigationBar(
      key: ValueKey('normal_nav'), // Important for AnimatedSwitcher
      currentIndex: viewModel.pageIndex,
      backgroundColor: Colors.transparent,
      onTap: (index) {
        if (index == 0 || index == 2 || index == 4 || index == 5) {
          viewModel.pageIndex = index;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: AIImage(
            viewModel.pageIndex == 0
                ? AIImages.icBottomHomeFill
                : AIImages.icBottomHome,
            width: 21.0,
            height: 21.0,
            color: Colors.white,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Routers.goToAccountWalletPage(context);
            },
            child: AIImage(
              viewModel.pageIndex == 1
                  ? AIImages.icBottomWalletFill
                  : AIImages.icBottomWallet,
              width: 24.0,
              height: 24.0,
              color: Colors.white,
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: AIImage(
            AIImages.icComment4,
            width: 27.0,
            height: 27.0,
            color: Colors.white,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: InkWell(
            onTap: () {
              showModalBottomSheet<int>(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (
                      BuildContext modalContext,
                      StateSetter setModalState,
                    ) {
                      return SafeArea(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 200,
                          decoration: BoxDecoration(
                            // color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20.0),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Drag handle
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: viewModel.handleTapCreateVTOPost,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Create VTO Post",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: viewModel.goToAddPost,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Create Post",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Routers.goToCreateRoomPage(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Create Chat Room",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Routers.goToLivePage(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Create Live Stream",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.red, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                child: const Icon(Icons.add, size: 36, color: Colors.white),
              ),
            ),
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: AIImage(
            AIImages.icBottomPodium,
            width: 21.0,
            height: 21.0,
            color: Colors.white,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: AIImage(
            AIImages.icBottomSearch2,
            width: 19.0,
            height: 19.0,
            color: Colors.white,
          ),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Routers.goToAccountPage(context);
            },
            child: AIImage(
              AIImages.icBottomUser3,
              width: 21.0,
              height: 21.0,
              color: Colors.white,
            ),
          ),
          label: "",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);

    // var titles = ['Home', 'Vybe', 'Wallet', 'Chat', 'Profile'];
    var pages = [
      PageableView(),
      AccountWalletPage(),
      ChatView(),
      LookbookView(),
      LeaderboardPage(),
      SearchView(),
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
                                color: Theme.of(context).colorScheme.onPrimary,
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
                ],
              ),
            ),
            body: pages[viewModel.pageIndex],
            /*
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
                            height: 32,
                            child: Padding(
                              padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
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
                                      iconSize: 18,
                                      label: '',
                                      color:
                                          viewModel.pageIndex == 0
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        // viewModel.pageIndex = 1;
                                        // viewModel.dotIndex = 1;
                                        Routers.goToAccountWalletPage(context);
                                      },
                                      icon:
                                          viewModel.pageIndex == 1
                                              ? AIImages.icBottomWalletFill
                                              : AIImages.icBottomWallet,
                                      iconSize: 18,
                                      label: '',
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
                                      iconSize: 18,
                                      icon:
                                          viewModel.pageIndex == 3
                                              ? AIImages.icBottomMessageFill
                                              : AIImages.icBottomMessage,
                                      label: '',
                                      color:
                                          viewModel.pageIndex == 3
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        viewModel.pageIndex = 4;
                                        viewModel.dotIndex = 4;
                                        Routers.goToAccountPage(context);
                                      },
                                      icon:
                                          viewModel.pageIndex == 4
                                              ? AIImages.icBottomUserFill
                                              : AIImages.icBottomUser,
                                      iconSize: 18,
                                      label: '',
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
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     for (int i = 0; i < 5; i++) ...{
                        //       Container(
                        //         width: 8,
                        //         height: 8,
                        //         margin: EdgeInsets.only(top: 52),
                        //         decoration: BoxDecoration(
                        //           color:
                        //               viewModel.dotIndex == i
                        //                   ? Theme.of(context).primaryColor
                        //                   : AIColors.transparent,
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(4),
                        //           ),
                        //         ),
                        //       ),
                        //     },
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: viewModel.goToAddPost,
                    child: Container(
                      width: 48,
                      height: 48,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.red, Colors.purple],
                          ),
                          borderRadius: BorderRadius.circular(26.0),
                        ),
                        child: const Icon(Icons.add, size: 36, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                */
            bottomNavigationBar: AppBackgroundView(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child:
                    viewModel.showSearch
                        ? _buildSearchBar(context, viewModel)
                        : _buildNormalNavigationBar(context, viewModel),
              ),
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
