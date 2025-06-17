import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  final String walletAddress;

  const RegisterPage({super.key, required this.walletAddress});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterProvider>.reactive(
      viewModelBuilder: () => RegisterProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, walletAddress: walletAddress),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 24.0,
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top),
                ClipOval(
                  child: AIImage(AIImages.logo, width: 120.0, height: 120.0),
                ),
                AuthRegisterView(),
                SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AuthRegisterView extends ViewModelWidget<RegisterProvider> {
  const AuthRegisterView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        spacing: 16.0,
        children: [
          Text('Please complete your information!'),
          const SizedBox(height: 8.0),
          AITextField(
            hintText: "First Name",
            prefixIcon: Icon(Icons.account_circle_outlined),
            onChanged: viewModel.updateFirstName,
          ),
          AITextField(
            hintText: "Last Name",
            prefixIcon: Icon(Icons.account_circle_outlined),
            onChanged: viewModel.updateLastName,
          ),
          AITextField(
            hintText: 'Bio (Optional)',
            prefixIcon: Icon(Icons.biotech),
            onChanged: (value) => viewModel.biometric = value,
          ),
          AITextField(
            hintText: 'URL (Optional)',
            prefixIcon: Icon(Icons.link),
            onChanged: (value) => viewModel.website = value,
          ),
          AITextField(
            hintText: 'City (Optional)',
            prefixIcon: Icon(Icons.location_city),
            onChanged: viewModel.updateCity,
          ),
          AITextField(
            hintText: 'Country (Optional)',
            prefixIcon: Icon(Icons.location_city),
            onChanged: viewModel.updateCountry,
          ),
          const SizedBox(height: 16.0),
          TextFillButton(
            text: "Register",
            color: AIColors.pink,
            isBusy: viewModel.isBusy,
            onTap: viewModel.onClickRegister,
          ),
        ],
      ),
    );
  }
}
