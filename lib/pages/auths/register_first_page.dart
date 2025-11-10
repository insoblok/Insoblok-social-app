import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';


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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter 100XP points by providing your first and last name',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  AITextField(
                    hintText: "First Name",
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    borderColor: Colors.grey,
                    onChanged: viewModel.updateFirstName,
                  ),
                  AITextField(
                    hintText: "Last Name",
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    borderColor: Colors.grey,
                    onChanged: viewModel.updateLastName,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 0.85,
                        child: SwitchTheme(
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
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        "Enable Face ID Authentication",
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const Spacer(),
                  GradientPillButton(
                    text: "Next",
                    onPressed: viewModel.onClickNext,
                    loading: viewModel.isBusy,
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
