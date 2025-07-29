import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:insoblok/models/models.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryCommentReplyCell extends StatelessWidget {
  final StoryCommentModel comment;
  const StoryCommentReplyCell({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentProvider>.reactive(
      viewModelBuilder: () => CommentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: comment),
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: kStoryDetailAvatarSize / 2.0),
              padding: const EdgeInsets.only(
                left: kStoryDetailAvatarSize / 2.0 + 8.0,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 0.5, color: AIColors.speraterColor),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        viewModel.owner?.fullName ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        viewModel.comment.timestamp?.timeago ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withAlpha(128),
                        ),
                      ),
                    ],
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
            InkWell(
              onTap: viewModel.onTapUserAvatar,
              child: ClipOval(
                child: AIAvatarImage(
                  viewModel.owner?.avatar,
                  textSize: 22,
                  width: kStoryDetailAvatarSize * 0.66,
                  height: kStoryDetailAvatarSize * 0.66,
                  fullname: viewModel.owner?.nickId ?? 'Test',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
