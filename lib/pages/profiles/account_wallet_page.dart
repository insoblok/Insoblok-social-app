import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/routers/routers.dart';
class AccountWalletPage extends StatelessWidget {
  const AccountWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () => AccountWalletProvider(),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('My Wallet'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            // flexibleSpace: AppBackgroundView(),
          ),
          body:  Stack(
            children: [
              Container(
                color: Colors.black,
                child: viewModel.pages[viewModel.pageIndex]
              ),
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
                            height: 48,
                            child: Padding(
                              padding: EdgeInsets.only(top: 6.0, bottom: 2.0),
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
                                              ? AIImages.icBottomWalletFill
                                              : AIImages.icBottomWallet,
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
                                        // Routers.goToAccountWalletPage(context);
                                      },
                                      icon:
                                          viewModel.pageIndex == 1
                                              ? AIImages.icStarFill
                                              : AIImages.icStarStroke,
                                      label: 'Favorites',
                                      color:
                                          viewModel.pageIndex == 1
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        viewModel.pageIndex = 2;
                                        viewModel.dotIndex = 2;
                                      },
                                      icon:
                                          viewModel.pageIndex == 2
                                              ? AIImages.icHistoryFill
                                              : AIImages.icHistoryStroke,
                                      label: 'Activities',
                                      color:
                                          viewModel.pageIndex == 2
                                              ? AIColors.pink
                                              : AIColors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: AIBottomBar(
                                      onTap: () {
                                        viewModel.pageIndex = 3;
                                        viewModel.dotIndex = 3;
                                      },
                                      icon:
                                          viewModel.pageIndex == 3
                                              ? AIImages.icBottomNotiFill
                                              : AIImages.icBottomNoti,
                                      label: 'Notifications',
                                      color:
                                          viewModel.pageIndex == 3
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
                      ]
                    )
                  )
              )
            ],
          ),
        );
      },
    );
  }
}
