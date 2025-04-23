import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class StoryListCell extends StatelessWidget {
  final StoryModel story;
  final void Function()? onTap;

  const StoryListCell({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AIColors.darkScaffoldBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 240.0,
                child: Stack(
                  children: [
                    AIImage(
                      AIImages.imgBackProfile,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 54.0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      color: AIColors.darkTransparentBackground,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: AIImage(
                              AIImages.placehold,
                              width: 32.0,
                              height: 32.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name of Owner',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                '2025-4-22 20:15',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            '1 / 4',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: PageableIndicator(pageLength: 4),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Story Title!!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'Find & Download Free Graphic Resources for Text Story Template Vectors, Stock Photos & PSD files. ✓ Free for commercial use ✓ High Quality Images.. ✓ Free for commercial use ✓ High Quality Images.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AIImage(Icons.favorite, width: 18.0, height: 18.0),
                            const SizedBox(width: 4.0),
                            Text(
                              '32',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(width: 24.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AIImage(Icons.hearing, width: 18.0, height: 18.0),
                            const SizedBox(width: 4.0),
                            Text(
                              '47',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const SizedBox(width: 24.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AIImage(Icons.comment, width: 18.0, height: 18.0),
                            const SizedBox(width: 4.0),
                            Text(
                              '19',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'More Detail >',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
