import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  final UserModel user;

  const RegisterPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterProvider>.reactive(
      viewModelBuilder: () => RegisterProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, userModel: user),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Register'), centerTitle: true),
          body: SingleChildScrollView(
            child: Container(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewPadding.top -
                  MediaQuery.of(context).viewPadding.bottom,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 24.0,
                children: [
                  const SizedBox(height: 16),
                  ClipOval(
                    child: AIImage(AIImages.logo, width: 120.0, height: 120.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Enter 25XP points by providing your Website',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AITextField(
                    hintText: 'URL',
                    prefixIcon: Icon(Icons.link),
                    onChanged: (value) => viewModel.website = value,
                  ),
                  AITextField(
                    hintText: 'Bio (option)',
                    prefixIcon: Icon(Icons.biotech),
                    onChanged: (value) => viewModel.biometric = value,
                  ),
                  const Spacer(),
                  TextFillButton(
                    text: "Register",
                    color: AIColors.pink,
                    isBusy: viewModel.isBusy,
                    onTap: viewModel.onClickRegister,
                  ),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
