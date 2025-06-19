import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountPublicPage extends StatelessWidget {
  const AccountPublicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountPublicProvider>.reactive(
      viewModelBuilder: () => AccountPublicProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Public Information'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: viewModel.onClickUpdateProfile,
                icon: Icon(Icons.check),
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                    child: Text('First Name'),
                  ),
                  Container(
                    decoration: kNoBorderDecoration,
                    child: AINoBorderTextField(
                      hintText: 'Emter your first name',
                      initialValue: viewModel.account.firstName,
                      onChanged: viewModel.updateFirstName,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                    child: Text('Last Name'),
                  ),
                  Container(
                    decoration: kNoBorderDecoration,
                    child: AINoBorderTextField(
                      hintText: 'Emter your last name',
                      initialValue: viewModel.account.lastName,
                      onChanged: viewModel.updateLastName,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                    child: Text('Nick ID'),
                  ),
                  Container(
                    decoration: kNoBorderDecoration,
                    child: AINoBorderTextField(
                      hintText: 'Emter your nick ID',
                      initialValue: viewModel.account.nickId,
                      onChanged: viewModel.updateNickID,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Description'),
                        InkWell(
                          onTap: viewModel.updateDescription,
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Icon(Icons.edit, size: 18.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 160.0,
                    padding: const EdgeInsets.all(16.0),
                    decoration: kCardDecoration,
                    child:
                        viewModel.account.desc != null
                            ? AIHelpers.htmlRender(viewModel.account.desc)
                            : Column(children: []),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discovery Image'),
                        InkWell(
                          onTap: viewModel.updateDiscovery,
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(Icons.add_a_photo, size: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 160.0,
                    decoration: kCardDecoration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child:
                          viewModel.selectedFile != null
                              ? AIImage(
                                File(viewModel.selectedFile!.path),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                              : AIImage(
                                viewModel.account.discovery ??
                                    AIImages.imgBackSplash,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                ],
              ),
              if (viewModel.isBusy) ...{Center(child: Loader(size: 60))},
            ],
          ),
        );
      },
    );
  }
}
