import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/providers/providers.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatProvider>.reactive(
      viewModelBuilder: () => ChatProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Text(S.current.chat),
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_circle),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ]),
            ),
          ],
        );
      },
    );
  }
}
