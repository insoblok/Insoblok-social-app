import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';

class MessagePageData {
  MessagePageData({
    required this.room,
    required this.chatUser,
  });

  final RoomModel room;
  final UserModel chatUser;
}

class MessagePage extends StatelessWidget {
  final MessagePageData data;

  const MessagePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageProvider>.reactive(
      viewModelBuilder: () => MessageProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, data: data),
      builder: (context, viewModel, _) {
        return Scaffold();
      },
    );
  }
}
