import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:aiavatar/providers/providers.dart';
import 'package:aiavatar/services/services.dart';
import 'package:aiavatar/utils/utils.dart';
import 'package:aiavatar/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterProvider>.reactive(
      viewModelBuilder: () => RegisterProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 80.0,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: AIImage(
                    AIImages.logo,
                    width: 120.0,
                    height: 120.0,
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 40.0,
                ),
                Text(
                  'Please complete your information!',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48.0),
                AITextField(
                  initialValue: viewModel.user.firstName,
                  hintText: 'First Name',
                  prefixIcon: Icon(Icons.account_circle),
                  onChanged: viewModel.updateFirstName,
                ),
                const SizedBox(height: 24.0),
                AITextField(
                  hintText: 'Last Name',
                  prefixIcon: Icon(Icons.account_circle),
                  onChanged: viewModel.updateLastName,
                ),
                const SizedBox(height: 40.0),
                InkWell(
                  onTap: viewModel.onClickConfirm,
                  child: Container(
                    width: double.infinity,
                    height: 52.0,
                    decoration: BoxDecoration(
                      color: AIColors.blue,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
