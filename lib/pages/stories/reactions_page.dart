import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ReactionsPage extends StatelessWidget {
  final StoryModel story;

  const ReactionsPage({super.key, required this.story});

  bool _isVideo(String url) {
    final lower = url.toLowerCase();
    return lower.contains('.mp4') ||
        lower.contains('.mov');
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReactionsProvider>.reactive(
      viewModelBuilder: () => ReactionsProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, story: story),
      builder: (context, viewModel, _) {
        final hasReactions = viewModel.reactions.isNotEmpty;

        return Scaffold(
          body: Stack(
            children: [
              AppBackgroundView(
                child: hasReactions
                    ? CustomScrollView(
                        controller: viewModel.controller,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            centerTitle: true,
                            title: const Text(
                              "Reactions",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(12.0),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final mediaUrl = viewModel.reactions[index];
                                  final isVideo = _isVideo(mediaUrl);
                                  final isSelected =
                                      viewModel.isSelected(mediaUrl);

                                  return GestureDetector(
                                    onTap: () =>
                                        viewModel.toggleSelection(mediaUrl),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: isVideo
                                              ? FutureBuilder<Uint8List?>(
                                                  future: _getVideoThumbnail(mediaUrl),
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
                                                )
                                              : Image.network(
                                                  mediaUrl,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const Icon(Icons.broken_image,
                                                          color: Colors.grey),
                                                ),
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.pink,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                                childCount: viewModel.reactions.length,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          "Empty reactions on this page",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
              ),
              if (hasReactions)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: viewModel.isBusyPosting
                        ? null
                        : () => viewModel.postToLookBook(),
                    child: const Text(
                      "Post to LookBook",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              if (viewModel.isBusyPosting)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
