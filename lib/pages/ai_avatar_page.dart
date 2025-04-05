import 'package:aiavatar/providers/providers.dart';
import 'package:flutter/material.dart';

import 'package:aiavatar/pages/pages.dart';
import 'package:stacked/stacked.dart';

class AIAvatarPage extends StatelessWidget {
  const AIAvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [
      DashboardView(),
      ChatView(),
      FavoriteView(),
      ProfileView(),
    ];
    var titles = [
      'Home',
      'Chat',
      'Like',
      'User',
    ];
    var icons = [
      Icon(Icons.home),
      Icon(Icons.message),
      Icon(Icons.favorite),
      Icon(Icons.account_circle),
    ];

    return ViewModelBuilder<AIAvatarProvider>.reactive(
      viewModelBuilder: () => AIAvatarProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(titles[viewModel.pageIndex]),
            ),
            body: pages[viewModel.pageIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: viewModel.pageIndex,
              onTap: (value) => viewModel.pageIndex = value,
              items: [
                for (var i = 0; i < 4; i++) ...{
                  BottomNavigationBarItem(
                    icon: icons[i],
                    label: titles[i].toUpperCase(),
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
