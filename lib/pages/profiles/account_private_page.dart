import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
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
                decoration: kTextFieldDecoration,
                child: AINoBorderTextField(
                  hintText: 'Emter your email',
                  initialValue: viewModel.account.email,
                  onChanged: viewModel.updateEmail,
                  readOnly: (viewModel.account.email?.isNotEmpty ?? false),
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Update Password'),
              ),
              Container(
                decoration: kTextFieldDecoration,
                child: AINoBorderTextField(
                  hintText: 'New password',
                  onChanged: viewModel.updatePassword,
                  readOnly: (viewModel.account.email?.isNotEmpty ?? false),
                ),
              ),
              const SizedBox(height: 12.0),
              Container(
                decoration: kTextFieldDecoration,
                child: AINoBorderTextField(
                  hintText: 'Confirm password',
                  onChanged: viewModel.updateConfirm,
                  readOnly: (viewModel.account.email?.isNotEmpty ?? false),
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Your city'),
              ),
              Container(
                decoration: kTextFieldDecoration,
                child: AINoBorderTextField(
                  hintText: 'Enter your city',
                  initialValue: viewModel.account.city,
                  onChanged: viewModel.updateCity,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Your Country'),
              ),
              Container(
                height: 48,
                decoration: kTextFieldDecoration,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButton<UserCountryModel>(
                  isExpanded: true,
                  value: viewModel.country,
                  dropdownColor: Theme.of(context).colorScheme.onSecondary,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  underline: Container(),
                  items:
                      viewModel.countries.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(
                            country.name ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }).toList(),
                  onChanged: viewModel.updateCountry,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Connect to Wallet'),
              ),
              Container(
                decoration: kTextFieldDecoration,
                child: AINoBorderTextField(
                  hintText: 'Connect to Wallet',
                  onChanged: viewModel.updateWallet,
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
