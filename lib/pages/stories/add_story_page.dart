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
            controller: viewModel.scrollController,
            slivers: [
              SliverAppBar(
                title: Text('Add Story'),
                pinned: true,
                leading: IconButton(
                  onPressed: () {
                    viewModel.provider.reset();
                    Navigator.of(context).pop();
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
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    AITextField(
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Input Feed Title...',
                      onChanged: (value) => viewModel.title = value,
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Description of Story',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      decoration: kCardDecoration,
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: viewModel.updateDescription,
                        child:
                            viewModel.quillDescription.isEmpty
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.description, size: 32.0),
                                      const SizedBox(height: 12.0),
                                      Text(
                                        'Add Description',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                )
                                : AIHelpers.htmlRender(
                                  viewModel.quillDescription,
                                ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Galleries of Story',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: viewModel.onClickAddMediaButton,
                            icon: Icon(Icons.add_a_photo),
                          ),
                        ],
                      ),
                    ),
                    UploadMediaWidget(
                      controller: viewModel.scrollController,
                      onRefresh: () {
                        viewModel.notifyListeners();
                      },
                    ),
                    const SizedBox(height: 40.0),
                    TextFillButton(
                      text: viewModel.txtUploadButton,
                      color: viewModel.isBusy ? AIColors.grey : AIColors.pink,
                      onTap: viewModel.onClickUploadButton,
                    ),
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
