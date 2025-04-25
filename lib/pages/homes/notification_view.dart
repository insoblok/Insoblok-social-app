import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationProvider>.reactive(
      viewModelBuilder: () => NotificationProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 45.0 + 45.0 + 10.0,
                  pinned: true,
                  floating: false,
                  elevation: 1.0,
                  leading: AppLeadingView(),
                  centerTitle: true,
                  title: Text('Notifications'),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: AIImage(
                        AIImages.icSetting,
                        width: 24.0,
                        height: 24.0,
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.none,
                    background: Container(
                      margin: EdgeInsets.only(top: 45 + 20.0),
                      height: 45.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    viewModel.pageIndex == 0
                                        ? Border(
                                          bottom: BorderSide(
                                            width: 2.0,
                                            color: AIColors.blue,
                                          ),
                                        )
                                        : null,
                              ),
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => viewModel.pageIndex = 0,
                                child: Text('All'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    viewModel.pageIndex == 1
                                        ? Border(
                                          bottom: BorderSide(
                                            width: 2.0,
                                            color: AIColors.blue,
                                          ),
                                        )
                                        : null,
                              ),
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () => viewModel.pageIndex = 1,
                                child: Text('Mentions'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
          physics: BouncingScrollPhysics(),
          body: Container(),
        );
      },
    );
  }
}
