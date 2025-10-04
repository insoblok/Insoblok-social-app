import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class RegisterFirstPage extends StatelessWidget {
  final UserModel user;

  const RegisterFirstPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterFirstProvider>.reactive(
      viewModelBuilder: () => RegisterFirstProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, userModel: user),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Register'), centerTitle: true),
          body: SafeArea(
            child: Container(
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
                      'Enter 100XP points by providing your first and last name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SwitchTheme(
                        data: SwitchThemeData(
                          trackColor: MaterialStateProperty.resolveWith((states) =>
                              states.contains(MaterialState.selected)
                                  ? Colors.indigo
                                  : Colors.indigo.withOpacity(0.15)),
                          thumbColor: MaterialStateProperty.resolveWith((states) =>
                              states.contains(MaterialState.selected)
                                  ? Colors.white
                                  : Colors.indigo),
                          trackOutlineColor:
                              const MaterialStatePropertyAll<Color>(Colors.indigo),
                          trackOutlineWidth:
                              const MaterialStatePropertyAll<double>(2),
                        ),
                        child: Switch(
                          value: viewModel.biometricEnabled,
                          onChanged: (v) {
                            viewModel.updateBiometric(v);
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        "Enable Face ID Authentication",
                        style: Theme.of(context).textTheme.bodyLarge
                      )
                    ],
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
