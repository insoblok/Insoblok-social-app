import 'package:flutter/material.dart';
import 'package:insoblok/widgets/text_widget.dart';

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

        return ViewModelBuilder<LoginProvider>.reactive(
  viewModelBuilder: () => LoginProvider(),
  onViewModelReady: (viewModel) => viewModel.init(context),
  builder: (context, viewModel, _) {
    final cp = viewModel.currentPage; // 0 or 1

    // Corrected visibility rules based on your comments:
    // Page 0: Show brand, show top subtitle, show bottom tagline
    // Page 1: Hide brand, hide top subtitle, hide bottom tagline
    
    final hideBrand = (cp == 1);          // Hide brand on page 1
    final hideTopSubtitle = (cp == 1);    // Hide top subtitle on page 1
    final hideBottomTagline = (cp == 1);  // Hide bottom tagline on page 1

    return Scaffold(
      backgroundColor: AIColors.landingBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
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
                    children: [
                      // "LivVybe" + TM - Hide on page 1
                      keepSpace(
                        visible: !hideBrand,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          ],
                        ),
                      ),

                      // Subtitle: "Swipe. React. Remix. Get Paid" - Hide on page 1
                      keepSpace(
                        visible: !hideTopSubtitle,
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
  child: AspectRatio(
    aspectRatio: 1.0, // Square aspect ratio
    child: PageView(
      controller: viewModel.pageController,
      onPageChanged: viewModel.onPageChanged,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                  child: Visibility(
                    visible: !hideBottomTagline, // Hide on page 1
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1.25,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          const TextSpan(text: 'Connect, Vybe and build your\n'),
                          const TextSpan(text: 'Tastescore'),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.top,
                            child: Transform.translate(
                              offset: const Offset(0, -6),
                              child: Text(
                                '™',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.7),
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

                // Conditional wallet buttons
                if(viewModel.walletExists)
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                        child: AIPasswordField(
                          controller: viewModel.existingPasswordController
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                        child: OutlineButton(
                          onTap: () => viewModel.handleClickSignIn(context),
                          child: const Text("Unlock")
                        )
                      ),
                    ]        
                  )
                else
                  Column(
                    children: [ 
                      Container(
                        color: AIColors.darkScaffoldBackground.withAlpha(48),
                        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                        child: GradientPillButton(
                          text: 'Create a New Wallet',
                          loadingText: 'Creating …',
                          onPressed: viewModel.isClickCreateNewWallet
                              ? null
                              : () => viewModel.handleClickCreateNewWallet(context),
                        ),
                      ),
                      Container(
                        color: AIColors.darkScaffoldBackground.withAlpha(48),
                        margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
                        child: GradientPillButton(
                          text: 'Import From an Existing Wallet',
                          loadingText: 'Importing …',
                          onPressed: viewModel.isClickImportWallet
                              ? null
                              : () => viewModel.showImportDialog(context),
                        ),
                      )
                    ]
                  ),

                // checkbox
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Enable Vybecam',
                        style: TextStyle(color: AIColors.white, fontSize: 18.0), 
                      ),
                      const SizedBox(width: 50),
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ),
    );
  },
);},
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
    this.height = 48,
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
