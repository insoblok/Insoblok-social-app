import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
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
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 80.0,
            ),
            child: Column(
              children: [
                ClipOval(
                  child: AIImage(AIImages.logo, width: 120.0, height: 120.0),
                ),
                const SizedBox(width: double.infinity, height: 40.0),
                Text(
                  S.current.register_detail,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 48.0),
                AITextField(
                  hintText: S.current.first_name,
                  prefixIcon: Icon(Icons.account_circle),
                  onChanged: viewModel.updateFirstName,
                ),
                const SizedBox(height: 24.0),
                AITextField(
                  hintText: S.current.last_name,
                  prefixIcon: Icon(Icons.account_circle),
                  onChanged: viewModel.updateLastName,
                ),
                const SizedBox(height: 40.0),
                TextFillButton(
                  text: S.current.register_confirm,
                  color: AIColors.blue,
                  isBusy: viewModel.isBusy,
                  onTap: viewModel.onClickConfirm,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
