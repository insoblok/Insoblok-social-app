import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class RegisterSecondPage extends StatelessWidget {
  final UserModel user;

  const RegisterSecondPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterSecondProvider>.reactive(
      viewModelBuilder: () => RegisterSecondProvider(),
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
                      'Enter 75XP points by providing your country and city name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AITextField(
                    hintText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                    onChanged: viewModel.updateCity,
                  ),
                  AITextField(
                    hintText: 'Country',
                    prefixIcon: Icon(Icons.location_city),
                    onChanged: viewModel.updateCountry,
                  ),
                  const Spacer(),
                  TextFillButton(
                    text: "Next",
                    color: AIColors.pink,
                    isBusy: viewModel.isBusy,
                    onTap: viewModel.onClickNext,
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
