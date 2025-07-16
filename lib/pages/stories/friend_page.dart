import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FriendProvider>.reactive(
      viewModelBuilder: () => FriendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Friends'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(child: Center(child: Loader(size: 60))),
                },
                if (viewModel.userList.isEmpty && !viewModel.isBusy) ...{
                  SliverFillRemaining(
                    child: InSoBlokEmptyView(desc: 'Friend is Empty!'),
                  ),
                } else ...{
                  SliverFillRemaining(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: viewModel.userList.length,
                            itemBuilder: (context, index) {
                              return FriendListCell(
                                key: GlobalKey(
                                  debugLabel:
                                      'friend-${viewModel.userList[index]?.id}',
                                ),
                                id: viewModel.userList[index]!.id!,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
