import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

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
              StoryHeaderView(story: story),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title ?? '---',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AIHelpers.htmlRender(story.text, fontSize: FontSize.medium),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AIImage(Icons.favorite, width: 18.0, height: 18.0),
                            const SizedBox(width: 4.0),
                            Text(
                              '${story.likes?.length ?? '--'}',
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
                              '${story.follows?.length ?? '--'}',
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
                              '${story.comments?.length ?? '--'}',
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

class StoryHeaderView extends StatelessWidget {
  const StoryHeaderView({super.key, required this.story});

  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.0,
      child: Stack(
        children: [
          AIImage(
            story.medias?[2].link,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          FutureBuilder<UserModel?>(
            future: FirebaseHelper.getUser(story.uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              var user = snapshot.data;
              if (user == null) {
                return Container();
              }
              return Container(
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
                      child: AIImage(user.avatar, width: 32.0, height: 32.0),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${story.regdate}',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '1 / ${story.medias?.length}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: PageableIndicator(pageLength: story.medias?.length ?? 0),
          ),
        ],
      ),
    );
  }
}
