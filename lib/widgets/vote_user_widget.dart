import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class VotedUserCell extends StatelessWidget {
  final StoryVoteModel voteModel;

  const VotedUserCell({super.key, required this.voteModel});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProvider>.reactive(
      viewModelBuilder: () => UserProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, id: voteModel.userId!),
      builder: (context, viewModel, _) {
        var user = viewModel.owner;
        return Row(
          children: [
            InkWell(
              onTap: viewModel.goToDetailPage,
              child: AIAvatarImage(
                user?.avatar,
                textSize: 22,
                width: kStoryDetailAvatarSize,
                height: kStoryDetailAvatarSize,
                fullname: user?.fullName ?? 'Test',
                isBorder: true,
                borderRadius: kStoryDetailAvatarSize / 2,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? '---',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    voteModel.timestamp?.timeago ?? '10m ago',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            AIImage(
              voteModel.vote == true
                  ? AIImages.icYayOutline
                  : AIImages.icNayOutline,
              width: 24.0,
              height: 24.0,
              color: voteModel.vote == true ? AIColors.green : AIColors.pink,
            ),
          ],
        );
      },
    );
  }
}

// const SizedBox(height: 4),
// Row(
//   // mainAxisAlignment: MainAxisAlignment.spaceAround,
//   children: [
//     VoteFloatingButton(
//       onTap: () {},
//       textSize: 12,
//       imgSize: 20,
//       horizontal: 24,
//       text: 'Yay',
//       textColor:
//           voteModel.vote == true
//               ? AIColors.white
//               : AIColors.green,
//       src: AIImages.icYay,
//       backgroundColor:
//           voteModel.vote == true
//               ? AIColors.green
//               : AIColors.white,
//       borderColor: AIColors.green,
//     ),
//     const SizedBox(width: 24),
//     VoteFloatingButton(
//       onTap: () {},
//       textSize: 12,
//       imgSize: 20,
//       horizontal: 24,
//       text: 'Nay',
//       textColor:
//           voteModel.vote == false
//               ? AIColors.white
//               : AIColors.pink,
//       src: AIImages.icNay,
//       backgroundColor:
//           voteModel.vote == false
//               ? AIColors.pink
//               : AIColors.white,
//       borderColor: AIColors.pink,
//     ),
//   ],
// ),
