import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

final kLandingPageData = [
  {
    'title': 'Speak Your Vibe. Stay on Lock.',
    'description':
        'Yay/Nay chats with friends. Private. Encrypted. Untouchable.',
    'image': AIImages.imgSplash2,
  },
  
  {
    'title': 'Unlock Your World.',
    'description':
        'No forms. Just you. Tap in, explore and own your vibe - your way.',
    'image': AIImages.imgSplash1,
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
        final hideBrandOn0 = (cp == 0);
        final hideBottomTaglineOn0 = (cp == 0);

        // cp == 0 → hide "LivVybe" and hide the top subtitle "Swipe. React. Remix. Get Paid"
        final hideBrandOn1 = (cp == 1);
        final hideTopSubtitleOn1 = (cp == 1);

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
                  top: MediaQuery.of(context).padding.top,
                  left: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // NOTE: your project uses `spacing:` on Column;
                  // if that's an extension in your codebase, keep it.
                  // Otherwise, replace with SizedBox(height: 8).
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
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25.0, color: AIColors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // MIDDLE: pager of images
              Padding(
                padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.width,
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

              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Visibility(
                  visible: !hideBottomTaglineOn0,         // keeps your flag
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.25,                     // nice line height
                        color: Colors.white,              // or AIColors.white
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        const TextSpan(text: 'Connect, Vybe and build your\n'),
                        const TextSpan(text: 'Tastescore'),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.top,
                          child: Transform.translate(
                            offset: const Offset(0, -6),  // lift the ™ like superscript
                            child: Text(
                              '™',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.7), // or AIColors.greyTextColor
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // sign-in button
              Container(
                color: AIColors.darkScaffoldBackground.withAlpha(48),
                margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: GradientPillButton(
                  text: 'Sign in with Wallet',
                  loadingText: 'Signing in…',
                  loading: viewModel.isClickWallet,           // <- show spinner
                  onPressed: viewModel.isClickWallet
                      ? null                                 // <- disable taps while loading
                      : () => viewModel.login(),
                ),
              ),

              // checkbox
              Container(
                
                margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Enable Vybecam',
                      style: TextStyle(color: AIColors.white, fontSize: 20.0), 
                    ),

                    const SizedBox(width: 50),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SwitchTheme(
                          data: SwitchThemeData(
                            // Track fill (on/off)
                            trackColor: MaterialStateProperty.resolveWith((states) =>
                                states.contains(MaterialState.selected)
                                    ? Colors.indigo
                                    : Colors.indigo.withOpacity(0.15)),
                            // Thumb color (on/off)
                            thumbColor: MaterialStateProperty.resolveWith((states) =>
                                states.contains(MaterialState.selected)
                                    ? Colors.white
                                    : Colors.indigo),
                            // Track border
                            trackOutlineColor:
                                const MaterialStatePropertyAll<Color>(Colors.indigo),
                            trackOutlineWidth:
                                const MaterialStatePropertyAll<double>(2),
                          ),
                          child: Switch(
                            value: viewModel.isCheckScan,
                            onChanged: (v) {
                              viewModel.isCheckScan = v;
                              viewModel.notifyListeners();
                            },
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              // footer
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0, top: 10.0),
                child: Column(
                  children: [
                    Text(
                      'By proceeding you accept',
                      style: TextStyle(color: AIColors.white, fontSize: 18.0),
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
                              fontSize: 18.0,
                              color: AIColors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'and',
                          style: TextStyle(color: AIColors.white, fontSize: 18.0),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => AIHelpers.loadUrl(kPrivacyUrl),
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: AIColors.pink,
                              fontSize: 18.0,
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
        AIImage(data['image'], height: MediaQuery.of(context).size.width),
      ],
    );
  }
}

class GradientPillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double radius;

  /// When true, shows a spinner and disables taps.
  final bool loading;

  /// Optional label while loading (defaults to [text]).
  final String? loadingText;

  const GradientPillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56,
    this.radius = 10,
    this.loading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFF30C6C), // pink
        Color(0xFFC739EB), // purple
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: loading ? null : onPressed,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: loading
                    ? Row(
                        key: const ValueKey('loading'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            loadingText ?? text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        text,
                        key: const ValueKey('idle'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
