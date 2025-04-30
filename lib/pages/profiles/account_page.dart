import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

const kAccountAvatarSize = 72.0;
const kAccountPageTitles = ['My Posts', 'Like', 'Follow'];

class AccountPage extends StatelessWidget {
  final UserModel? user;

  const AccountPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountProvider>.reactive(
      viewModelBuilder: () => AccountProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: user),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: AIPersistentHeader(
                  minSize: MediaQuery.of(context).padding.top + 145.0,
                  maxSize: MediaQuery.of(context).padding.top + 145.0,
                  child: AccountPresentHeaderView(),
                ),
              ),
              SliverToBoxAdapter(child: AccountFloatingView()),
              SliverAppBar(
                pinned: true,
                toolbarHeight: 44.0,
                backgroundColor: AppSettingHelper.background,
                surfaceTintColor: AppSettingHelper.background,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: AccountFloatingHeaderView(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  if (viewModel.pageIndex == 0) ...{
                    for (var story in viewModel.stories) ...{
                      StoryListCell(story: story),
                    },
                  },
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
