import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterProvider>.reactive(
      viewModelBuilder: () => RegisterProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 80.0,
            ),
            children: [
              Center(
                child: ClipOval(
                  child: AIImage(AIImages.logo, width: 120.0, height: 120.0),
                ),
              ),
              const SizedBox(width: double.infinity, height: 40.0),
              Center(
                child: Text(
                  'Please complete your information!',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 48.0),
              Row(
                children: [
                  Expanded(
                    child: AITextField(
                      hintText: "First Name",
                      prefixIcon: Icon(Icons.account_circle),
                      onChanged: viewModel.updateFirstName,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: AITextField(
                      hintText: "Last Name",
                      prefixIcon: Icon(Icons.account_circle),
                      onChanged: viewModel.updateLastName,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: AITextField(
                      hintText: 'Bio (Optional)',
                      prefixIcon: Icon(Icons.biotech),
                      onChanged: (value) => viewModel.biometric = value,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: AITextField(
                      hintText: 'URL (Optional)',
                      prefixIcon: Icon(Icons.link),
                      onChanged: (value) => viewModel.website = value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: AITextField(
                      hintText: 'City (Optional)',
                      prefixIcon: Icon(Icons.location_city),
                      onChanged: viewModel.updateCity,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: AITextField(
                      hintText: 'Country (Optional)',
                      prefixIcon: Icon(Icons.location_city),
                      onChanged: viewModel.updateCountry,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              TextFillButton(
                text: "Confirm",
                color: AIColors.pink,
                isBusy: viewModel.isBusy,
                onTap: viewModel.onClickConfirm,
              ),
            ],
          ),
        );
      },
    );
  }
}
