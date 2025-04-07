import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginProvider>.reactive(
      viewModelBuilder: () => LoginProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
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
                  S.current.login_title,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80.0),
                OutlineButton(
                  width: 320.0,
                  isBusy: viewModel.isBusy,
                  borderColor: AIColors.yellow,
                  onTap: viewModel.login,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(
                        AIImages.imgMetamask,
                        width: 28.0,
                      ),
                      const SizedBox(width: 24.0),
                      Text(
                        S.current.login_button,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.yellow,
                        ),
                      ),
                    ],
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
