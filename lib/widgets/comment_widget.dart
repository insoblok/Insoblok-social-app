import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryDetailCommentCell extends StatefulWidget {
  final StoryCommentModel comment;
  final bool isLast;
  final bool selected;
  final void Function()? onTap;

  const StoryDetailCommentCell({
    super.key,
    required this.comment,
    this.isLast = false,
    this.selected = false,
    this.onTap,
  });

  @override
  State<StoryDetailCommentCell> createState() => _StoryDetailCommentCellState();
}

class _StoryDetailCommentCellState extends State<StoryDetailCommentCell> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentProvider>.reactive(
      viewModelBuilder: () => CommentProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, model: widget.comment),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.fullName ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (widget.comment.content != null)
                    AIHelpers.htmlRender(
                      widget.comment.content,
                      fontSize: FontSize(12.0),
                    ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              widget.comment.timestamp?.timeago ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withAlpha(128),
                              ),
                            ),
                            const SizedBox(width: 24),
                            InkWell(
                              onTap: widget.onTap,
                              child: Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      widget.selected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color: Theme.of(context).colorScheme.onPrimary
                                      .withAlpha(widget.selected ? 255 : 128),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          viewModel.updateLike();
                        },
                        child: Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withAlpha(128),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (viewModel.comment.likes ?? []).length.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                  if (viewModel.commentReplies.isNotEmpty) ...{
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: InkWell(
                        onTap: () {
                          viewModel.isShowReplies = !viewModel.isShowReplies;
                        },
                        child: Text(
                          'View ${viewModel.commentReplies.length} Replies',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary.withAlpha(128),
                          ),
                        ),
                      ),
                    ),
                  },
                  if (viewModel.isShowReplies) ...{
                    for (var comment in viewModel.commentReplies) ...{
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 4.0,
                        ),
                        constraints: BoxConstraints(maxHeight: 200.0),
                        child: StoryCommentReplyCell(
                          key: GlobalKey(
                            debugLabel: '${comment.id} - ${comment.commentId}',
                          ),
                          comment: comment,
                        ),
                      ),
                    },
                  },
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
                  borderRadius: kStoryDetailAvatarSize / 2,
                  fullname: user?.fullName ?? 'Test',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
