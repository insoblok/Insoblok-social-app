import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

const kAccountAvatarSize = 72.0;
const kAccountPageTitles = ['My Posts', 'Like', 'Follow', 'Gallery'];

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
          body: SizedBox(
            child: Stack(
              children: [
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: AIPersistentHeader(
                        minSize:
                            kProfileDiscoverHeight + kAccountAvatarSize / 2.0,
                        maxSize:
                            kProfileDiscoverHeight + kAccountAvatarSize / 2.0,
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
                            AccountStoryListCell(story: story),
                          },
                        },
                        if (viewModel.pageIndex == 1) ...{
                          for (var uid
                              in (viewModel.accountUser?.likes ?? [])) ...{
                            UserRelatedView(uid: uid),
                          },
                        },
                        if (viewModel.pageIndex == 2) ...{
                          for (var uid
                              in (viewModel.accountUser?.follows ?? [])) ...{
                            UserRelatedView(uid: uid),
                          },
                        },
                        if (viewModel.pageIndex == 3) ...{
                          for (var uid
                              in (viewModel.accountUser?.follows ?? [])) ...{
                            UserRelatedView(uid: uid),
                          },
                        },
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 40.0,
                        ),
                      ]),
                    ),
                  ],
                ),
                if (viewModel.isCreatingRoom) Center(child: Loader(size: 60)),
              ],
            ),
          ),
        );
      },
    );
  }
}
