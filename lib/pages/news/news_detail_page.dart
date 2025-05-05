import 'package:flutter/material.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kNewsHeaderImageHeight = 200.0;

class NewsDetailPage extends StatelessWidget {
  final NewsModel news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: AIPersistentHeader(
              minSize: kNewsHeaderImageHeight,
              maxSize: kNewsHeaderImageHeight,
              child: Stack(
                children: [
                  AIImage(
                    news.imageUrl,
                    height: kNewsHeaderImageHeight,
                    width: double.infinity,
                  ),
                  CustomCircleBackButton(),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: news.title ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextSpan(
                            text: '   Visit Website',
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (news.categories?.isNotEmpty ?? false) ...{
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          for (var category in (news.categories ?? [])) ...{
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 2.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Text(
                                category['name'],
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          },
                        ],
                      ),
                    },
                    if (news.topics?.isNotEmpty ?? false) ...{
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          for (var topic in (news.topics ?? [])) ...{
                            Text(
                              '#${topic['name']}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          },
                        ],
                      ),
                    },
                    const SizedBox(height: 16.0),
                    Text(
                      news.description ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: AIColors.greyTextColor,
                thickness: 0.33,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Summary & Infomation'),
                    if (news.linkInfo.isNotEmpty) ...{
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 4.0,
                        children:
                            (news.linkInfo).map((info) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AIImage(
                                    info['icon'],
                                    width: 18.0,
                                    height: 18.0,
                                    color: AIColors.greyTextColor,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    info['title']!,
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    },
                    if (news.keywords?.isNotEmpty ?? false) ...{
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          for (var keyword in (news.keywords ?? [])) ...{
                            Text(
                              '#${keyword['name']}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          },
                        ],
                      ),
                    },
                    const SizedBox(height: 16.0),
                    Text(
                      news.content ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      news.summary ?? '',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: AIColors.greyTextColor,
                thickness: 0.33,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Related Articles'),
                    for (String? link in (news.links ?? [])) ...{
                      const SizedBox(height: 8.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: AIImage(link?.pageSpeedThumbnail),
                      ),
                    },
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
            ]),
          ),
        ],
      ),
    );
  }
}
