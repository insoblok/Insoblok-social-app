import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
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
          body: AppBackgroundView(
            child: CustomScrollView(
              controller: viewModel.scrollController,
              slivers: [
                SliverAppBar(
                  title: Text('Add Story'),
                  pinned: true,
                  flexibleSpace: AppBackgroundView(),
                  leading: IconButton(
                    onPressed: () {
                      viewModel.goToMainPage();
                      viewModel.mediaProvider.reset();
                      // Navigator.of(context).pop(true);
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
                          'Description of Story',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Container(
                        height: 200.0,
                        decoration: kCardDecoration,
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: viewModel.updateDescription,
                          child:
                              viewModel.quillDescription.isEmpty
                                  ? Center(
                                    child: Text(
                                      'Add Description',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
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
                              onPressed: viewModel.onAddMedia,
                              icon: Icon(Icons.add_a_photo),
                            ),
                          ],
                        ),
                      ),
                      UploadMediaWidget(),
                      const SizedBox(height: 40.0),
                      TextFillButton(
                        text: viewModel.txtUploadButton,
                        color: viewModel.isBusy ? AIColors.grey : AIColors.pink,
                        onTap: viewModel.onClickUploadButton,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: viewModel.isVoteImage,
                              onChanged: (bool? newValue) {
                                viewModel.setPostType(newValue ?? true);
                              },
                            ),
                          ),
                          Text(
                            'Post as a Vote Story',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: viewModel.isPrivate,
                              onChanged: (bool? newValue) {
                                viewModel.setPostAction(newValue ?? true);
                              },
                            ),
                          ),
                          Text(
                            'Make it private',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (viewModel.isPrivate) ...{
                        Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: viewModel.onClickAddUser,
                              child: Text('+ Add User'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: [
                            for (var user in viewModel.selectedUserList) ...{
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                  vertical: 2.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withAlpha(32),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Row(
                                  spacing: 4.0,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(user.fullName),
                                    InkWell(
                                      onTap: () {
                                        viewModel.selectedUserList.remove(user);
                                        viewModel.notifyListeners();
                                      },
                                      child: Icon(Icons.close, size: 14.0),
                                    ),
                                  ],
                                ),
                              ),
                            },
                          ],
                        ),
                      },
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
