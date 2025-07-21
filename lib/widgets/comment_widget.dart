import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryDetailCommentCell extends StatelessWidget {
  final StoryCommentModel comment;
  final bool isLast;

  const StoryDetailCommentCell({
    super.key,
    required this.comment,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentProvider>.reactive(
      viewModelBuilder: () => CommentProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: comment),
      builder: (context, viewModel, _) {
        var user = viewModel.owner;
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user?.fullName ?? '---',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        comment.timestamp?.timeago ?? '---',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  if (comment.content != null)
                    AIHelpers.htmlRender(
                      comment.content,
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
                  user?.avatar,
                  textSize: 22,
                  width: kStoryDetailAvatarSize,
                  height: kStoryDetailAvatarSize,
                  fullname: user?.nickId ?? 'Test',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
