import 'dart:ui';

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
    // var titles = ['Home', 'Chat', 'Like', 'User'];
    var icons = [
      Icons.home,
      Icons.message,
      Icons.favorite,
      Icons.account_circle,
    ];
    var backgrounds = [
      AIImages.imgBackDashboard,
      AIImages.imgBackMessage,
      AIImages.imgBackLike,
      AIImages.imgBackProfile,
    ];

    return ViewModelBuilder<InSoBlokProvider>.reactive(
      viewModelBuilder: () => InSoBlokProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Stack(
              children: [
                AIImage(
                  backgrounds[viewModel.pageIndex],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black54,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                    blendMode: BlendMode.srcOver,
                    child: pages[viewModel.pageIndex],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 28.0,
                      right: 28.0,
                      bottom: 16.0,
                    ),
                    height: 54.0,
                    decoration: BoxDecoration(
                      color: AIColors.appBar.withAlpha(128),
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var i = 0; i < 4; i++) ...{
                          InkWell(
                            onTap: () => viewModel.pageIndex = i,
                            child: AIImage(
                              icons[i],
                              width: 28.0,
                              height: 28.0,
                              color:
                                  viewModel.pageIndex == i
                                      ? AIColors.appSelectedText
                                      : AIColors.appUnselectedText,
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: BottomNavigationBar(
            //   currentIndex: viewModel.pageIndex,
            //   onTap: (value) => viewModel.pageIndex = value,
            //   items: [
            //     for (var i = 0; i < 4; i++) ...{
            //       BottomNavigationBarItem(
            //         icon: icons[i],
            //         label: titles[i].toUpperCase(),
            //       ),
            //     },
            //   ],
            // ),
          ),
        );
      },
    );
  }
}
