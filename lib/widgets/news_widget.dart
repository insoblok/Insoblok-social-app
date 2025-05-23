import 'package:flutter/material.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class NewsListCell extends StatelessWidget {
  final NewsModel news;

  const NewsListCell({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AIColors.speraterColor, width: 0.33),
        ),
      ),
      child: InkWell(
        onTap: () => Routers.goToNewsDetailPage(context, news),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.33, color: AIColors.speraterColor),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: AspectRatio(
                  aspectRatio: 1.91,
                  child: AIImage(
                    news.image_url,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),

            if (news.keywords?.isNotEmpty ?? false) ...{
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  for (var category in (news.keywords ?? [])) ...{
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Text(category, style: TextStyle(fontSize: 12.0)),
                    ),
                  },
                ],
              ),
            },
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    news.title ?? '---',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  news.pubDate?.newsTimeago ?? '',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              news.description ?? '---',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
