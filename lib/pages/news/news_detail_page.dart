import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insoblok/extensions/string.dart';

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
                    news.image_url,
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
                    if (news.keywords?.isNotEmpty ?? false) ...{
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          for (var keyword in (news.keywords ?? [])) ...{
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
                              child: Text(
                                keyword,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          },
                        ],
                      ),
                    },
                    const SizedBox(height: 16.0),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: news.title ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          if (news.source_url?.isNotEmpty ?? false)
                            TextSpan(
                              text: '   Visit Website',
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap =
                                        () =>
                                            AIHelpers.loadUrl(news.source_url!),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      news.description ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AIColors.greyTextColor, thickness: 0.2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Summary & Infomation'),
                    if (news.country?.isNotEmpty ?? false) ...{
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 4.0,
                        children:
                            (news.country ?? []).map((info) {
                              return Text(
                                info?.toTitleCase ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                              );
                            }).toList(),
                      ),
                    },
                    if (news.category?.isNotEmpty ?? false) ...{
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children:
                            (news.category ?? []).map((info) {
                              return Container(
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
                                child: Text(
                                  info ?? '',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              );
                            }).toList(),
                      ),
                    },
                    const SizedBox(height: 16.0),
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
                      child: Text(
                        news.language ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      news.content ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
