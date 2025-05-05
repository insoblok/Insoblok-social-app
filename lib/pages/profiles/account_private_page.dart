import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountPrivatePage extends StatelessWidget {
  const AccountPrivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountPrivateProvider>.reactive(
      viewModelBuilder: () => AccountPrivateProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Private Information'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: viewModel.onClickUpdateProfile,
                icon: Icon(Icons.check),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Email Address'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Emter your email',
                  initialValue: viewModel.account.firstName,
                  onChanged: viewModel.updateEmail,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Update Password'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Update password',
                  initialValue: viewModel.account.firstName,
                  onChanged: viewModel.updatePassword,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Confirm Password'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Update password',
                  initialValue: viewModel.account.firstName,
                  onChanged: viewModel.updateConfirm,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Your city'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Emter your city',
                  initialValue: viewModel.account.firstName,
                  onChanged: viewModel.updateCity,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Your Country'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Emter your country',
                  initialValue: viewModel.account.firstName,
                  onChanged: viewModel.updateCountry,
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }
}
