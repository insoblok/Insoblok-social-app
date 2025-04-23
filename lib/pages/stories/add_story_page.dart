import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

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
              SliverAppBar(
                title: Text('Add Story'),
                pinned: true,
                leading: IconButton(
                  onPressed: () {
                    viewModel.provider.reset();
                    Navigator.of(context).pop(false);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Title of Story',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    AITextField(
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Input Feed Title...',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 24.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Description of Story',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    InkWell(
                      onTap: viewModel.onClickAddMediaButton,
                      child: Container(
                        height: 60.0,
                        decoration: kCardDecoration,
                        alignment: Alignment.center,
                        child: Text(
                          '+ Add Medias',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                    ),
                    UploadMediaWidget(),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
