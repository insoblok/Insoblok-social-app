import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insoblok/services/image_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPersistentHeader(
                        pinned: true,
                        floating: true,
                        delegate: AIPersistentHeader(
                          minSize: kProfileDiscoverHeight +
                              MediaQuery.of(context).padding.top +
                              kAccountAvatarSize / 2.0,
                          maxSize: kProfileDiscoverHeight +
                              MediaQuery.of(context).padding.top +
                              kAccountAvatarSize / 2.0,
                          child: const AccountPresentHeaderView(),
                        ),
                      ),
                      SliverToBoxAdapter(child: const AccountFloatingView()),

                      /// 🔹 Added Stories / Galleries Tab
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTabButton(
                                context,
                                label: "Stories",
                                isSelected: viewModel.pageIndex == 0,
                                onTap: () => viewModel.setPageIndex(0),
                              ),
                              const SizedBox(width: 16),
                              _buildTabButton(
                                context,
                                label: "Galleries",
                                isSelected: viewModel.pageIndex == 3,
                                onTap: () => viewModel.setPageIndex(3),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([
                          /// ------------------ STORIES ------------------
                          if (viewModel.pageIndex == 0) ...{
                            if (viewModel.stories.isNotEmpty) ...{
                              GridView.count(
                                shrinkWrap: true,
                                controller: viewModel.controller,
                                crossAxisCount: 3,
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 1.0,
                                childAspectRatio: 0.75,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                children: [
                                  for (var story in viewModel.stories) ...{
                                    InkWell(
                                      onTap: () {
                                        viewModel.goToDetailPage(
                                          viewModel.stories.indexOf(story),
                                        );
                                      },
                                      child: (story.medias ?? []).isNotEmpty
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
                                                  const Positioned(
                                                    top: 6.0,
                                                    right: 6.0,
                                                    child: Icon(
                                                      Icons.filter_none_outlined,
                                                      color: Colors.white,
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
                                                  child:
                                                      AIHelpers.htmlRender(
                                                    story.text,
                                                    fontSize:
                                                        FontSize(21.0),
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
                            } else ...{
                              const SafeArea(
                                child: InSoBlokEmptyView(
                                  desc: 'There is no any Posts.',
                                ),
                              ),
                            },
                          },

                          /// ------------------ GALLERIES ------------------
                          if (viewModel.pageIndex == 3) ...{
                            if (viewModel.isFetchingGallery) ...{
                              Container(
                                width: double.infinity,
                                height: 200.0,
                                alignment: Alignment.center,
                                child: const Loader(size: 60.0),
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
                                            onTap: () =>
                                                AIHelpers.goToDetailView(
                                              context,
                                              medias: viewModel.galleries,
                                              index: viewModel.galleries
                                                  .indexOf(gallery),
                                            ),
                                            child: _buildMediaThumbnail(gallery),
                                          ),
                                        },
                                      ],
                                    )
                                  : const SafeArea(
                                      child: InSoBlokEmptyView(
                                        desc: 'There is no any Galleries.',
                                      ),
                                    ),
                            },
                          },

                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom +
                                40.0,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),

                if (viewModel.isCreatingRoom)
                  const Center(child: Loader(size: 60)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List?> _getVideoThumbnail(String videoUrl) async {
    try {
      return await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );
    } catch (e) {
      debugPrint("Error generating thumbnail: $e");
      return null;
    }
  }
  
  Widget _buildMediaThumbnail(String url) {
    final lowerUrl = url.toLowerCase();

    if (lowerUrl.contains('.mp4') || lowerUrl.contains('.mov')) {
      return FutureBuilder<Uint8List?>(
        future: _getVideoThumbnail(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return Stack(
              children: [
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                const Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 40,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          }
          return const Icon(
            Icons.broken_image,
            color: Colors.grey,
          );
        },
      );
    } else {
      // Show image as before
      return AIImage(url);
    }
  }

  Widget _buildTabButton(BuildContext context,
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

