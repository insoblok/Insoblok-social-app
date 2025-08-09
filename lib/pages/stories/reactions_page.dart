import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class ReactionsPage extends StatelessWidget {
  final StoryModel story;

  const ReactionsPage({super.key, required this.story});

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
                                  final imageUrl = viewModel.reactions[index];
                                  final isSelected =
                                      viewModel.isSelected(imageUrl);

                                  return GestureDetector(
                                    onTap: () =>
                                        viewModel.toggleSelection(imageUrl),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            imageUrl,
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
                                              decoration: BoxDecoration(
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
                    onPressed: viewModel.isBusyPosting ? null : () => viewModel.postToLookBook(),
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
