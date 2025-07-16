import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

const kAccountAvatarSize = 92.0;
const kAccountPageTitles = ['Posts', 'Like', 'Follow'];

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
                AppBackgroundView(
                  child: CustomScrollView(
                    controller: viewModel.controller,
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: AIPersistentHeader(
                          minSize:
                              kProfileDiscoverHeight +
                              MediaQuery.of(context).padding.top +
                              kAccountAvatarSize / 2.0,
                          maxSize:
                              kProfileDiscoverHeight +
                              MediaQuery.of(context).padding.top +
                              kAccountAvatarSize / 2.0,
                          child: AccountPresentHeaderView(),
                        ),
                      ),
                      SliverToBoxAdapter(child: AccountFloatingView()),
                      // SliverAppBar(
                      //   pinned: true,
                      //   toolbarHeight: 48.0,
                      //   // backgroundColor: AppSettingHelper.background,
                      //   // surfaceTintColor: AppSettingHelper.background,
                      //   elevation: 0,
                      //   automaticallyImplyLeading: false,
                      //   primary: false,
                      //   flexibleSpace: AppBackgroundView(),
                      //   title: AccountFloatingHeaderView(),
                      // ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          if (viewModel.pageIndex == 0) ...{
                            if (viewModel.stories.isNotEmpty) ...{
                              GridView.count(
                                shrinkWrap: true,
                                controller: viewModel.controller,
                                crossAxisCount: 3,
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 1.0,
                                childAspectRatio: 0.75,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                children: [
                                  for (var story in viewModel.stories) ...{
                                    InkWell(
                                      onTap: () {
                                        viewModel.goToDetailPage(
                                          viewModel.stories.indexOf(story),
                                        );
                                      },
                                      child:
                                          (story.medias ?? []).isNotEmpty
                                              ? Stack(
                                                children: [
                                                  AIImage(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    story.medias?.first.type ==
                                                            'image'
                                                        ? story
                                                            .medias
                                                            ?.first
                                                            .link
                                                        : story
                                                            .medias
                                                            ?.first
                                                            .thumb,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  if ((story.medias ?? [])
                                                          .length >
                                                      1)
                                                    Positioned(
                                                      top: 6.0,
                                                      right: 6.0,
                                                      child: AIImage(
                                                        Icons
                                                            .filter_none_outlined,
                                                        color: AIColors.white,
                                                      ),
                                                    ),
                                                ],
                                              )
                                              : Container(
                                                color: AIColors.grey,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: AIHelpers.htmlRender(
                                                      story.text,
                                                      fontSize: FontSize(21.0),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    ),
                                  },
                                ],
                              ),
                              // for (var story in viewModel.stories) ...{
                              //   AccountStoryListCell(story: story),
                              // },
                            } else ...{
                              SafeArea(
                                child: InSoBlokEmptyView(
                                  desc: 'There is no any Posts.',
                                ),
                              ),
                            },
                          },
                          if (viewModel.pageIndex == 1) ...{
                            if ((viewModel.accountUser?.likes ?? [])
                                .isNotEmpty) ...{
                              for (var id
                                  in (viewModel.accountUser?.likes ?? [])) ...{
                                UserRelatedView(id: id),
                              },
                            } else ...{
                              SafeArea(
                                child: InSoBlokEmptyView(
                                  desc: 'There is no any posts user liked.',
                                ),
                              ),
                            },
                          },
                          if (viewModel.pageIndex == 2) ...{
                            if ((viewModel.accountUser?.follows ?? [])
                                .isNotEmpty) ...{
                              for (var id
                                  in (viewModel.accountUser?.follows ??
                                      [])) ...{UserRelatedView(id: id)},
                            } else ...{
                              SafeArea(
                                child: InSoBlokEmptyView(
                                  desc: 'There is no any posts user followed.',
                                ),
                              ),
                            },
                          },
                          if (viewModel.pageIndex == 3) ...{
                            if (viewModel.isFetchingGallery) ...{
                              Container(
                                width: double.infinity,
                                height: 200.0,
                                alignment: Alignment.center,
                                child: Loader(size: 60.0),
                              ),
                            } else ...{
                              viewModel.galleries.isNotEmpty
                                  ? GridView.count(
                                    shrinkWrap: true,
                                    controller: viewModel.controller,
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 1.0,
                                    crossAxisSpacing: 1.0,
                                    childAspectRatio: 0.75,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    children: [
                                      for (var gallery
                                          in viewModel.galleries) ...{
                                        InkWell(
                                          onTap:
                                              () => AIHelpers.goToDetailView(
                                                context,
                                                medias: viewModel.galleries,
                                                index: viewModel.galleries
                                                    .indexOf(gallery),
                                              ),
                                          child: AIImage(gallery),
                                        ),
                                      },
                                    ],
                                  )
                                  : SafeArea(
                                    child: InSoBlokEmptyView(
                                      desc: 'There is no any Galleries.',
                                    ),
                                  ),
                            },
                          },
                          SizedBox(
                            height:
                                MediaQuery.of(context).padding.bottom + 40.0,
                          ),
                        ]),
                      ),
                    ],
                  ),
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
