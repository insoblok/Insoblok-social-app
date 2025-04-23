import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
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
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    AITextField(
                      prefixIcon: Icon(Icons.title),
                      hintText: 'Input Feed Title...',
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Description of Story',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: viewModel.updateDescription,
                            icon: Icon(Icons.edit_note),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Container(
                      height: 240.0,
                      decoration: kCardDecoration,
                      padding: const EdgeInsets.all(16.0),
                      child: QuillEditor(
                        focusNode: viewModel.focusNode,
                        scrollController: viewModel.quillScrollController,
                        controller: viewModel.quillController,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Galleries of Story',
                            style: Theme.of(context).textTheme.headlineLarge,
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
                    TextFillButton(text: 'Upload Story', color: AIColors.blue),
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
