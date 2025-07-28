import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryCommentReplyCell extends ViewModelWidget<CommentProvider> {
  const StoryCommentReplyCell({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
      children: [
        InkWell(
          onTap: viewModel.onTapUserAvatar,
          child: ClipOval(
            child: AIAvatarImage(
              viewModel.user?.avatar,
              textSize: 22,
              width: kStoryDetailAvatarSize,
              height: kStoryDetailAvatarSize,
              fullname: viewModel.user?.nickId ?? 'Test',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: kStoryDetailAvatarSize / 2.0),
          padding: const EdgeInsets.only(
            left: kStoryDetailAvatarSize / 2.0 + 8.0,
          ),
          // width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 0.5, color: AIColors.speraterColor),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                viewModel.user?.fullName ?? '',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (viewModel.comment.content != null)
                AIHelpers.htmlRender(
                  viewModel.comment.content,
                  fontSize: FontSize(12.0),
                ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ],
    );
  }
}
