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
    // helper that hides but preserves space/position
    Widget keepSpace({required bool visible, required Widget child}) {
      return Visibility(
        visible: visible,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: child,
      );
    }

    return ViewModelBuilder<LoginProvider>.reactive(
      viewModelBuilder: () => LoginProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        final cp = viewModel.currentPage; // 0 or 1

        // Rules:
        // cp == 1 → hide "LivVybe", and hide the TWO bottom-tagline texts
        final hideBrandOn0 = (cp == 1);
        final hideBottomTaglineOn0 = (cp == 1);

        // cp == 0 → hide "LivVybe" and hide the top subtitle "Swipe. React. Remix. Get Paid"
        final hideBrandOn1 = (cp == 0);
        final hideTopSubtitleOn1 = (cp == 0);

        final hideBrand = hideBrandOn0 || hideBrandOn1;

        return Scaffold(
          backgroundColor: AIColors.landingBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TOP: Brand + subtitle area
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 24.0,
                  left: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // NOTE: your project uses `spacing:` on Column;
                  // if that's an extension in your codebase, keep it.
                  // Otherwise, replace with SizedBox(height: 8).
                  spacing: 8,
                  children: [
                    // "LivVybe" + TM (HIDDEN on both page 0 and 1 per your rules)
                    keepSpace(
                      visible: !hideBrand,
                      child: Row(
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
                    ),

                    // Subtitle: "Swipe. React. Remix. Get Paid"
                    // HIDE on page 1 (visible on page 0)
                    keepSpace(
                      visible: !hideTopSubtitleOn1,
                      child: Text(
                        'Swipe. React. Remix. Get Paid',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18.0, color: AIColors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // MIDDLE: pager of images
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width - 64,
                  child: PageView(
                    controller: viewModel.pageController,
                    onPageChanged: viewModel.onPageChanged, // <-- track page
                    children: [
                      for (var data in kLandingPageData) ...{
                        LoginPageView(data: data),
                      },
                    ],
                  ),
                ),
              ),

              // dots
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

              // BOTTOM: tagline block ("Your Face..." + "Connect, Vybe...")
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 32.0, left: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    // "Your Face is your ticket" — HIDE on page 0
                    keepSpace(
                      visible: !hideBottomTaglineOn0,
                      child: Text(
                        'Your Face is your ticket',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AIColors.white,
                        ),
                      ),
                    ),

                    // "Connect, Vybe and build your TasetScore" (+ TM) — HIDE on page 0
                    keepSpace(
                      visible: !hideBottomTaglineOn0,
                      child: Row(
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
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // sign-in button
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

              // checkbox
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: viewModel.isCheckScan,
                      onChanged: (value) {
                        viewModel.isCheckScan = !viewModel.isCheckScan;
                        viewModel.notifyListeners(); // ensure UI updates
                      },
                    ),
                    Text(
                      'Vybe scan enable',
                      style: TextStyle(color: AIColors.white, fontSize: 14.0),
                    ),
                  ],
                ),
              ),

              // footer
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
                          onTap: () => AIHelpers.loadUrl(kPrivacyUrl),
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
                          onTap: () => AIHelpers.loadUrl(kPrivacyUrl),
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
      children: [
        AIImage(data['image'], height: MediaQuery.of(context).size.width - 64),
      ],
    );
  }
}
