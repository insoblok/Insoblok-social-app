import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

final kLandingPageData = [
  {
    'title': 'Unlock Your World.',
    'description':
        'No forms. Just you. Tap in, explore and own your vibe - your way.',
    'image': AIImages.imgSplash1,
  },
  {
    'title': 'Speak Your Vibe. Stay on Lock.',
    'description':
        'Yay/Nay chats with friends. Private. Encrypted. Untouchable.',
    'image': AIImages.imgSplash2,
  },
];

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginProvider>.reactive(
      viewModelBuilder: () => LoginProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: AIColors.landingBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24.0,
                  left: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LivVybe',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: AIColors.pink,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'TM',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 11.0,
                            color: AIColors.pink,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Swipe. React. Remix. Get Paid',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 18.0, color: AIColors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width - 64,
                  child: PageView(
                    controller: viewModel.pageController,
                    children: [
                      for (var data in kLandingPageData) ...{
                        LoginPageView(data: data),
                      },
                    ],
                  ),
                ),
              ),
              SmoothPageIndicator(
                controller: viewModel.pageController,
                count: 2,
                effect: ExpandingDotsEffect(
                  dotWidth: 36.0,
                  dotHeight: 4.0,
                  spacing: 4.0,
                  dotColor: AIColors.white,
                  activeDotColor: AIColors.pink,
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 32.0, left: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      'Your Face is your ticket',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AIColors.white,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connect, Vybe and build your TasetScore',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AIColors.greyTextColor,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'TM',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 8.0,
                            color: AIColors.greyTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                color: AIColors.darkScaffoldBackground.withAlpha(48),
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                child: OutlineButton(
                  isBusy: viewModel.isClickWallet,
                  borderColor: AIColors.pink,
                  onTap: viewModel.login,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // AIImage(AIImages.imgMetamask, width: 28.0),
                      // const SizedBox(width: 24.0),
                      Text(
                        'Sign in with Wallet',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: viewModel.isCheckScan,
                      onChanged: (value) {
                        viewModel.isCheckScan = !viewModel.isCheckScan;
                      },
                    ),
                    Text(
                      'Vybe scan enable',
                      style: TextStyle(color: AIColors.white, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0, top: 36.0),
                child: Column(
                  children: [
                    Text(
                      'By proceeding you accept InSoBlok',
                      style: TextStyle(color: AIColors.white, fontSize: 14.0),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            AIHelpers.loadUrl(kPrivacyUrl);
                          },
                          child: Text(
                            'Terms of Use',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: AIColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'and',
                          style: TextStyle(
                            color: AIColors.white,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            AIHelpers.loadUrl(kPrivacyUrl);
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: AIColors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LoginPageView extends StatelessWidget {
  final dynamic data;

  const LoginPageView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      // spacing: 12.0,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         data['title'],
        //         style: TextStyle(
        //           fontSize: 18.0,
        //           fontWeight: FontWeight.bold,
        //           color: AIColors.white,
        //         ),
        //       ),
        //       const SizedBox(height: 8.0),
        //       Text(
        //         data['description'],
        //         style: TextStyle(fontSize: 14.0, color: AIColors.white),
        //       ),
        //     ],
        //   ),
        // ),
        AIImage(data['image'], height: MediaQuery.of(context).size.width - 64),
      ],
    );
  }
}
