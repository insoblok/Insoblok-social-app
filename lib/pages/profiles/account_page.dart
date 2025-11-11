import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';
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
                          minSize:
                              kProfileDiscoverHeight +
                              MediaQuery.of(context).padding.top +
                              kAccountAvatarSize / 2.0,
                          maxSize:
                              kProfileDiscoverHeight +
                              MediaQuery.of(context).padding.top +
                              kAccountAvatarSize / 2.0,
                          child: const AccountPresentHeaderView(),
                        ),
                      ),
                      const SliverToBoxAdapter(child: AccountFloatingView()),

                      // Tabs: Stories / Galleries
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
                                onTap: () {
                                  viewModel.setPageIndex(0);
                                  viewModel.resetSelection();
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildTabButton(
                                context,
                                label: "Galleries",
                                isSelected: viewModel.pageIndex == 3,
                                onTap: () {
                                  viewModel.setPageIndex(3);
                                  viewModel.resetSelection();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      SliverList(
                        delegate: SliverChildListDelegate([
                          // ------------------ STORIES ------------------
                          if (viewModel.pageIndex == 0) ...{
                            if (viewModel.stories.isNotEmpty) ...{
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                mainAxisSpacing: 1.0,
                                crossAxisSpacing: 1.0,
                                childAspectRatio: 0.75,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                children: [
                                  for (final story in viewModel.stories) ...{
                                    if ((story.medias ?? []).isEmpty)
                                      InkWell(
                                        onTap: () {
                                          viewModel.goToDetailPage(
                                            viewModel.stories.indexOf(story),
                                          );
                                        },
                                        child: Container(
                                          color: AIColors.grey,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: AIHelpers.htmlRender(
                                                story.text,
                                                fontSize: FontSize(21.0),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    else
                                      _StoryTile(
                                        vm: viewModel,
                                        story: story,
                                        onTap: () {
                                          viewModel.goToDetailPage(
                                            viewModel.stories.indexOf(story),
                                          );
                                        },
                                        buildMediaThumb:
                                            (url, {bool isVideo = false}) =>
                                                _buildMediaThumbnail(
                                                  context,
                                                  viewModel,
                                                  url,
                                                  isVideo: isVideo,
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
                          // ------------------ GALLERIES ------------------
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 1.0,
                                    crossAxisSpacing: 1.0,
                                    childAspectRatio: 0.75,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 4.0,
                                    ),
                                    children: [
                                      for (final gallery
                                          in viewModel.galleries) ...{
                                        InkWell(
                                          onTap:
                                              () => AIHelpers.goToDetailView(
                                                context,
                                                medias:
                                                    viewModel.galleries
                                                        .map(
                                                          (gal) =>
                                                              gal.media ?? "",
                                                        )
                                                        .toList(),
                                                // medias: [],
                                                index: viewModel.galleries
                                                    .indexOf(gallery),
                                                storyID: '',
                                                storyUser: '',
                                              ),
                                          child: _buildMediaThumbnail(
                                            context,
                                            viewModel,
                                            gallery.media ?? "",
                                          ),
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
                            height:
                                MediaQuery.of(context).padding.bottom + 40.0,
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

  Widget _buildMediaThumbnail(
    BuildContext context,
    AccountProvider vm,
    String url, {
    bool isVideo = false,
  }) {
    final detectVideo = isVideo || _looksLikeVideoUrl(url);
    logger.d("Url is $url");
    if (detectVideo) {
      return FutureBuilder<Uint8List?>(
        future: _getVideoThumbnail(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            return Stack(
              fit: StackFit.expand,
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
          return const Icon(Icons.broken_image, color: Colors.grey);
        },
      );
    } else {
      return Container(
        decoration: BoxDecoration(),
        child: InkWell(
          onLongPress: () {
            vm.handleLongPress(url);
          },
          onTap: () {
            vm.handleClickGallery(url);
          },
          child: Stack(
            children: [
              AIImage(url, fit: BoxFit.cover, color: Colors.blue.shade900),
              if (vm.isSelectMode && vm.selectedItems.contains(url)) ...{
                Container(
                  color: Colors.blue.withAlpha(50),
                  child: InkWell(
                    onTap: () => vm.handleClickGallery(url),
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    onPressed: () async {
                      await showDialog<bool>(
                        context: context,
                        barrierDismissible:
                            false, // User must tap button to close
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black87,
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete selected items?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // Perform delete action
                                  vm.handleClickDeleteGallery();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              },
            ],
          ),
        ),
      );
    }
  }

  bool _looksLikeVideoUrl(String url) {
    final u = url.toLowerCase();
    return u.endsWith('.mp4') ||
        u.endsWith('.mov') ||
        u.endsWith('.m3u8') ||
        u.contains('/video/') ||
        u.contains('video/upload');
  }

  Widget _buildTabButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFF30C6C), Color(0xFFC739EB)],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          color: isSelected ? null : Colors.transparent,
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

class _StoryTile extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;
  final AccountProvider vm;
  final Widget Function(String url, {bool isVideo}) buildMediaThumb;

  const _StoryTile({
    required this.story,
    required this.onTap,
    required this.vm,
    required this.buildMediaThumb,
  });

  @override
  Widget build(BuildContext context) {
    final media = story.medias!.first;
    final String link = media.link!;
    final String? type = media.type;
    final bool isVideo = (type?.toLowerCase() == 'video');

    // Log story image path
    logger.d('=== Story Image Path (Profile Page) ===');
    logger.d('Story ID: ${story.id}');
    logger.d('Story Image Link/Path: $link');
    logger.d('Media Type: $type');
    logger.d('Is Video: $isVideo');
    logger.d('Total Medias in Story: ${story.medias?.length ?? 0}');
    if ((story.medias ?? []).length > 1) {
      logger.d('All Media Links in this Story:');
      for (int i = 0; i < story.medias!.length; i++) {
        logger.d(
          '  Media[$i]: ${story.medias![i].link} (type: ${story.medias![i].type})',
        );
      }
    }
    logger.d('========================================');

    return InkWell(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          isVideo
              ? buildMediaThumb(link, isVideo: true)
              // : AIImage(link, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
              : SelectableWidget(
                context: context,
                media: link,
                id: story.id ?? "",
                onTap:
                    vm.isSelectMode
                        ? vm.handleClickGallery
                        : (url) {
                          // When not in select mode, navigate directly with all story media URLs
                          final allMediaUrls =
                              story.medias
                                  ?.map((m) => m.link ?? "")
                                  .where((url) => url.isNotEmpty)
                                  .toList() ??
                              [];
                          if (allMediaUrls.isNotEmpty) {
                            AIHelpers.goToDetailView(
                              context,
                              medias: allMediaUrls,
                              index: 0,
                              storyID: story.id ?? "",
                              storyUser: story.userId ?? "",
                            );
                          }
                        },
                onLongPress: vm.handleLongPress,
                onDelete: vm.handleClickDeleteStories,
                selectMode: vm.isSelectMode,
                selected: vm.selectedItems,
              ),

          if (vm.isMe && (story.category == 'live'))
            Positioned(
              top: 4,
              right: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit title button
                  _SmallCircleButton(
                    icon: Icons.edit,
                    onPressed: () async {
                      final controller = TextEditingController(text: story.title ?? '');
                      final newTitle = await showDialog<String>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.black87,
                          title: const Text('Edit title', style: TextStyle(color: Colors.white)),
                          content: TextField(
                            controller: controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Enter a title',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(controller.text.trim()), child: const Text('Save')),
                          ],
                        ),
                      );
                      if (newTitle != null && newTitle.isNotEmpty && (story.id?.isNotEmpty ?? false)) {
                        await vm.storyService.updateStoryById(id: story.id!, data: {'title': newTitle});
                        await vm.fetchStories();
                      }
                    },
                  ),
                  const SizedBox(width: 6),
                  // Delete recording
                  _SmallCircleButton(
                    icon: Icons.delete_outline,
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.black87,
                          title: const Text('Delete recording', style: TextStyle(color: Colors.white)),
                          content: const Text('Are you sure you want to delete this recording?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (ok == true && (story.id?.isNotEmpty ?? false)) {
                        await FirebaseHelper.deleteStory(story.id!);
                        await vm.fetchStories();
                      }
                    },
                  ),
                ],
              ),
            ),

          if ((story.medias ?? []).length > 1)
            const Positioned(
              top: 6.0,
              left: 6.0,
              child: Icon(Icons.filter_none_outlined, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget SelectableWidget({
    required BuildContext context,
    required String media,
    required String id,
    required void Function(String m) onTap,
    required void Function(String m) onLongPress,
    required void Function() onDelete,
    required bool selectMode,
    required List<String> selected,
  }) => InkWell(
    onTap: () => onTap(id),
    onLongPress: () => onLongPress(id),
    child: Stack(
      fit: StackFit.expand,
      children: [
        AIImage(media, fit: BoxFit.cover, color: Colors.blue.shade900),
        if (selectMode && selected.contains(id)) ...{
          Container(
            color: Colors.blue.withAlpha(50),
            child: InkWell(
              onTap: () => onTap(id),
              child: Center(
                child: Icon(Icons.check_circle, color: Colors.blue, size: 40),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // User must tap button to close
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black87,
                      title: const Text('Confirm Delete'),
                      content: const Text(
                        'Are you sure you want to delete selected items?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            // Perform delete action
                            onDelete();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        },
      ],
    ),
  );
}

class _SmallCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _SmallCircleButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}
