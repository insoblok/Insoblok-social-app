import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';

class AddStoryPage extends StatelessWidget {
  AddStoryPage({super.key});

  TextEditingController autoCompleteController = TextEditingController();

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
                      const SizedBox(height: 24.0),
                      Text(
                        "Place",
                        style: Theme.of(context).textTheme.labelMedium
                      ),
                      const SizedBox(height: 12.0),
                      PlaceSearchField(
                        /// The line `// controller: autoCompleteController,` is a commented-out line of
                        /// code in the `PlaceSearchField` widget initialization.
                        controller: autoCompleteController,
                        apiKey: GOOGLE_API_KEY,
                        isLatLongRequired: true,        // Fetch lat/long with place details
                        onPlaceSelected: (placeId, latLng) {
                          logger.d('Place ID: $placeId');
                          viewModel.placeId = placeId.place_id;
                          // viewModel.updatePlace(placeId.place_id);
                          logger.d('Latitude and Longitude: $latLng');
                        },
                        decorationBuilder: (context, child) {
                          return Material(
                            type: MaterialType.card,
                            elevation: 4,
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                            child: child,
                          );
                        },
                        builder: (context, controller, focusNode) {
                          return TextField(
                            controller: autoCompleteController,
                            focusNode: focusNode,
                            // autofocus: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.location_city, // 👈 any Material icon
                                color: Colors.white,   // icon color
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12), // corner radius
                                borderSide: BorderSide(
                                  color: Colors.grey, // border color when not focused
                                  width: 1,         // border width
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.blueAccent, // border color when focused
                                  width: 1,
                                ),
                              ),
                              )
                            );
                          },
                          itemBuilder: (context, prediction) => ListTile(
                            tileColor: Colors.black87,

                            selectedColor: Colors.black45,
                            textColor: Colors.black12,
                            leading: const Icon(Icons.location_on, color: Colors.white),
                            title: Text(
                              prediction.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)
                            ),
                          ),
                      ),
                      
                      SizedBox(height: 24.0),
                      Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFFF30C6C), Color(0xFFC739EB)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: TextFillButton(
                            text: viewModel.txtUploadButton,
                            color: viewModel.isBusy ? AIColors.grey : Colors.transparent,
                            onTap: viewModel.onClickUploadButton,
                          ),
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
