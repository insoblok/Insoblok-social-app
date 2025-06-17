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
              SizedBox(
                height: 512.0,
                child: PageView(
                  controller: viewModel.pageController,
                  children: [
                    for (var data in kLandingPageData) ...{
                      LoginPageView(data: data),
                    },
                  ],
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
                color: AIColors.darkScaffoldBackground.withAlpha(48),
                margin: const EdgeInsets.symmetric(horizontal: 40.0),
                child: OutlineButton(
                  isBusy: viewModel.isClickWallet,
                  borderColor: AIColors.pink,
                  onTap: viewModel.login,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(AIImages.imgMetamask, width: 28.0),
                      const SizedBox(width: 24.0),
                      Text(
                        'Start with MetaMask',
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
              Column(
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
                        style: TextStyle(color: AIColors.white, fontSize: 14.0),
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
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: AIColors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  data['description'],
                  style: TextStyle(fontSize: 14.0, color: AIColors.white),
                ),
              ],
            ),
          ),
          AspectRatio(aspectRatio: 1, child: AIImage(data['image'])),
        ],
      ),
    );
  }
}
