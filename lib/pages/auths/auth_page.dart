import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthProvider>.reactive(
      viewModelBuilder: () => AuthProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Login with Email'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              Text(
                'If you have already created an account, You can try to login using email and password.',
              ),
              const SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Email Address'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Emter your email',
                  onChanged: (value) => viewModel.emailAddress = value,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Password'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Emter your password',
                  obscureText: viewModel.obscureText,
                  suffix: InkWell(
                    onTap: () => viewModel.obscureText = !viewModel.obscureText,
                    child: Icon(
                      viewModel.obscureText ? Icons.lock : Icons.lock_open,
                      size: 18.0,
                    ),
                  ),
                  onChanged: (value) => viewModel.password = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                child: InkWell(
                  onTap: viewModel.onTapForgotPassword,
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
              TextFillButton(
                onTap: viewModel.onTapLoginButton,
                isBusy: viewModel.isBusy,
                text: 'Login with Email',
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 60.0),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text('If you have not an account yet?'),
              ),
              const SizedBox(height: 8.0),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Text(
                    '< Go back',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
