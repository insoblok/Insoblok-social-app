import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class StoryDetailPage extends StatelessWidget {
  final StoryModel story;

  const StoryDetailPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryDetailProvider>.reactive(
      viewModelBuilder: () => StoryDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: story),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                StoryDetailHeaderView(),
                const Divider(),
                StoryDetailSocialView(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StoryDetailHeaderView extends ViewModelWidget<StoryDetailProvider> {
  const StoryDetailHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var story = viewModel.story;
    var sliderHeight = 200.0;
    var iconSize = 80.0;

    return SizedBox(
      height: sliderHeight + iconSize / 2.0,
      child: Stack(
        children: [
          StoryCarouselView(
            story: story,
            height: sliderHeight,
            onChangePage: (index) => viewModel.pageIndex = index,
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24.0,
                left: 24.0,
              ),
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: AIColors.darkTransparentBackground,
                shape: BoxShape.circle,
              ),
              child: AIImage(Icons.arrow_back),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24.0,
                right: 24.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: AIColors.darkTransparentBackground,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${viewModel.pageIndex + 1} / ${(story.medias ?? []).length}',
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: iconSize,
              height: iconSize,
              margin: const EdgeInsets.only(left: 24.0),
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AIColors.yellow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iconSize),
                child: AIImage(
                  viewModel.owner?.avatar,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Post by:',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    viewModel.owner?.fullName ?? '',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const storySocialTitle = ['Likes', 'Follows', 'Comments'];

class StoryDetailSocialView extends ViewModelWidget<StoryDetailProvider> {
  const StoryDetailSocialView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < storySocialTitle.length; i++) ...{
                InkWell(
                  onTap: () => viewModel.tabIndex = i,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            viewModel.tabIndex == i
                                ? BorderSide(color: AIColors.yellow, width: 2.0)
                                : BorderSide.none,
                      ),
                    ),
                    child: Text(
                      storySocialTitle[i],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
              },
            ],
          ),
          const SizedBox(height: 16.0),
          if (viewModel.tabIndex == 0) StoryLikeListView(),
          if (viewModel.tabIndex == 1) StoryFollowListView(),
          if (viewModel.tabIndex == 2) StoryCommentListView(),
        ],
      ),
    );
  }
}

class StoryActionCover extends StatelessWidget {
  final Widget child;

  const StoryActionCover({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      width: double.infinity,
      height: 72.0,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AIColors.darkBar,
        border: Border.all(color: AIColors.yellow, width: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36.0),
          bottomLeft: Radius.circular(36.0),
          topRight: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

class StoryLikeListView extends ViewModelWidget<StoryDetailProvider> {
  const StoryLikeListView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var likes = viewModel.story.likes ?? [];
    return Column(
      children: [
        for (var i = 0; i < min(3, likes.length); i++) ...{
          FutureBuilder<UserModel?>(
            future: FirebaseHelper.getUser(likes[i]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              var user = snapshot.data;
              if (user == null) {
                return Container();
              }
              return StoryActionCover(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: AIImage(user.avatar, width: 64.0, height: 64.0),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4.0),
                          Text(user.regdate!),
                        ],
                      ),
                    ),
                    Icon(Icons.favorite, size: 18.0),
                    const SizedBox(width: 4.0),
                    Text((user.likes?.length ?? 0).socialValue),
                    const SizedBox(width: 16.0),
                    Icon(Icons.arrow_forward_ios, size: 14.0),
                    const SizedBox(width: 8.0),
                  ],
                ),
              );
            },
          ),
        },
        if (likes.length > 3) ...{
          const SizedBox(height: 24.0),
          Text(
            'View All'.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        },
      ],
    );
  }
}

class StoryFollowListView extends ViewModelWidget<StoryDetailProvider> {
  const StoryFollowListView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var follows = viewModel.story.follows ?? [];
    return Column(
      children: [
        for (var i = 0; i < min(3, follows.length); i++) ...{
          FutureBuilder<UserModel?>(
            future: FirebaseHelper.getUser(follows[i]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              var user = snapshot.data;
              if (user == null) {
                return Container();
              }
              return StoryActionCover(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: AIImage(user.avatar, width: 64.0, height: 64.0),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 4.0),
                          Text(user.regdate!),
                        ],
                      ),
                    ),
                    Icon(Icons.hearing, size: 18.0),
                    const SizedBox(width: 4.0),
                    Text((user.follows?.length ?? 0).socialValue),
                    const SizedBox(width: 16.0),
                    Icon(Icons.arrow_forward_ios, size: 14.0),
                    const SizedBox(width: 8.0),
                  ],
                ),
              );
            },
          ),
        },
        if (follows.length > 3) ...{
          const SizedBox(height: 24.0),
          Text(
            'View All'.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        },
      ],
    );
  }
}

class StoryCommentListView extends ViewModelWidget<StoryDetailProvider> {
  const StoryCommentListView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var comments = viewModel.story.comments ?? [];
    return Column(
      children: [
        for (var i = 0; i < min(3, comments.length); i++) ...{
          FutureBuilder<UserModel?>(
            future: FirebaseHelper.getUser(comments[i].uid!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              var user = snapshot.data;
              if (user == null) {
                return Container();
              }
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AIColors.yellow, width: 0.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: AIImage(user.avatar, width: 64.0, height: 64.0),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.fullName,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          AIHelpers.htmlRender(
                            comments[i].content,
                            fontSize: FontSize.small,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        },
        if (comments.length > 3) ...{
          const SizedBox(height: 24.0),
          Text(
            'View All'.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        },
      ],
    );
  }
}
