import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/upload_media_widget.dart';

class AddStoryPage extends StatelessWidget {
  const AddStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddStoryProvider>.reactive(
      viewModelBuilder: () => AddStoryProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(title: Text('Add Story'), pinned: true),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    height: 60.0,
                    decoration: kCardDecoration,
                    alignment: Alignment.center,
                    child: Text(
                      '+ Add Medias',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  UploadMediaWidget(),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
