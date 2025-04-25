import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class InSoBlokPage extends StatelessWidget {
  const InSoBlokPage({super.key});

  @override
  Widget build(BuildContext context) {
    var pages = [DashboardView(), ChatView(), FavoriteView(), ProfileView()];
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

    return ViewModelBuilder<InSoBlokProvider>.reactive(
      viewModelBuilder: () => InSoBlokProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: pages[viewModel.pageIndex],
            bottomNavigationBar: SizedBox(
              height: 49.0,
              child: BottomNavigationBar(
                currentIndex: viewModel.pageIndex,
                onTap: (value) => viewModel.pageIndex = value,
                items: [
                  for (var i = 0; i < 4; i++) ...{
                    BottomNavigationBarItem(
                      icon: AIImage(
                        viewModel.pageIndex == i
                            ? selectedIcon[i]
                            : unselectedIcon[i],
                      ),
                      label: titles[i],
                    ),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
