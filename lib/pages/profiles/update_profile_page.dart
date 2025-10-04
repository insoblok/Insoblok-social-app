import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';
class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateProfileProvider>.reactive(
      viewModelBuilder: () => UpdateProfileProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: Text(
              'Update Profile',
            ),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(viewModel.account),
              icon: Icon(Icons.arrow_back),
            ),
            actions: [
              SizedBox(
                width: 36.0,
                height: 36.0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withAlpha(128),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      logger.d("updated account is ${viewModel.account}");
                      bool? result = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey,
                            content: Text(
                              "Are you sure want to save?",
                              style: Theme.of(context).textTheme.bodyLarge
                            ),
                            title: Text(""),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                      if (result ?? false) {
                        logger.d("This is save.");
                        viewModel.onClickUpdated();
                      }
                      else {
                        logger.d("cancel save.");
                      }

                    },
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.save),
                    iconSize: 24,
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
              ),
              SizedBox(width: 16.0)
            ],
          ),
          body: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                AccountPublicInfoView(),
                SizedBox(height: 12.0),
                Divider(
                  height: 1,
                  color: AIColors.greyTextColor,
                  thickness: 0.5,
                ),
                AccountPrivateInfoView(
                  updateFirstName: viewModel.updateFirstName, 
                  updateLastName: viewModel.updateLastName,
                  updateLocation: viewModel.updateLocation,
                  updateWebsite: viewModel.updateWebsite,
                ),
                Divider(
                  color: AIColors.greyTextColor,
                  thickness: 0.5 
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: SocialMediaInputView(
                    edit: true,
                    initialValue: viewModel.account.socials,
                    updateSocials: viewModel.updateSocials,
                    account: viewModel.account,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(24.0),
                //   child: TextFillButton(
                //     onTap: viewModel.onClickUpdated,
                //     isBusy: viewModel.isBusy,
                //     text: 'Update Profile',
                //     color: Theme.of(context).primaryColor,
                //   ),
                // ),
              ],
            ),
        );
      },
    );
  }
}
