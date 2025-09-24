import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:insoblok/widgets/text_widget.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/pages/pages.dart';

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

typedef MenuEntry = DropdownMenuEntry<String>;

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
            final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
              LoginProvider.loginMethods.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
            );
            final cp = viewModel.currentPage; // 0 or 1

            // Corrected visibility rules based on your comments:
            // Page 0: Show brand, show top subtitle, show bottom tagline
            // Page 1: Hide brand, hide top subtitle, hide bottom tagline
            
            final hideBrand = (cp == 1);          // Hide brand on page 1
            final hideTopSubtitle = (cp == 1);    // Hide top subtitle on page 1
            final hideBottomTagline = (cp == 1);  // Hide bottom tagline on page 1

            void _handleClickCreateNewWallet(BuildContext buildContext) {
              
              Routers.goToPincodeRegisterPage(buildContext);
              // showDialog<String>(
              //   context: buildContext,
              //   builder: (bContext) {
              //     final TextEditingController _passwordController = TextEditingController();
              //     final TextEditingController _confirmController = TextEditingController();

              //     return _CreateWalletDialog(
              //       passwordController: _passwordController,
              //       confirmController: _confirmController,
              //       onCancel: () {
              //         viewModel.isClickCreateNewWallet = false;
              //       },
              //       onCreateWallet: (password) async {
              //         try {
              //           final newWalletResult = await viewModel.cryptoService.createAndStoreWallet(password);

              //           Navigator.pop(bContext);
              //           logger.d("Wallet creation result is ${newWalletResult.address}, ${newWalletResult.mnemonic}");
              //           await showDialog(
              //             context: context,
              //             barrierDismissible: false,
              //             builder: (context) => SeedPhraseConfirmationWidget(
              //               seedWords: (newWalletResult.mnemonic ?? "").split(" ").toList(), 
              //               onConfirmed: () {
              //                 showDialog(
              //                   context: context,
              //                   barrierDismissible: false,
              //                   builder: (context) => SeedPhraseConfirmationDialog(
              //                     originalSeedPhrase: newWalletResult.mnemonic!.trim(),
              //                     onConfirm: () {
              //                       Routers.goToRegisterFirstPage(buildContext,
              //                         user: UserModel(walletAddress: newWalletResult.address)
              //                       );
              //                     },
              //                     onCancel: () {
              //                       Navigator.pop(context); // Close confirmation dialog
              //                     },
              //                     showSeedPhrase: false,
              //                   ),
              //                 );
              //               } 
              //             )
              //           );
                        
              //         } catch (e) {
              //           logger.e(e);
              //           rethrow; // Re-throw to handle in the dialog
              //         }
              //       },
              //     );
              //   },
              // ).then((_) {
              //   viewModel.isClickCreateNewWallet = false;
              // });
            }

            // Separate StatefulWidget for the dialog
            

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
                            top: 16,
                            left: 16.0,
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
                        if(viewModel.isCheckingWallet)
                          Column(
                            children: [
                              CircularProgressIndicator(strokeWidth: 2),
                              Text("Checking wallet status ...")
                            ],
                          )
                        
                        else if(viewModel.walletExists)
                          Column(
                            children: [
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                      child: GradientPillButton(
                                        text: "Sign In", 
                                        onPressed: () {
                                          viewModel.handleClickSignIn(context);
                                        }
                                      ),
                                    ),
                                  ),
                                  // child: DropdownButton<String>(
                                  //   value: viewModel.loginMethod,
                                  //   isExpanded: true,
                                  //   icon: const Icon(Icons.keyboard_arrow_down),
                                  //   dropdownColor: Theme.of(context).colorScheme.onSecondary,
                                  //   items: viewModel.loginMethods.map((String value) {
                                  //     return DropdownMenuItem<String>(
                                  //       value: value,
                                  //       child: Align(
                                  //         alignment: Alignment.center,
                                  //         child: Text(
                                  //           value,
                                  //           style: Theme.of(context).textTheme.bodyLarge
                                  //         ),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  //   onChanged: (String? newValue) {
                                  //       viewModel.handleChangeLoginMethod(newValue ?? "");
                                  //   },
                                  // ),
                              //     Container(
                              //       decoration: BoxDecoration(
                              //         border: Border.all(color: Colors.pink, width: 1), // border color & width
                              //         borderRadius: BorderRadius.circular(36), // border radius
                              //       ),
                              //       child: DropdownButtonHideUnderline(
                              //         child: DropdownMenuTheme(
                              //           data: DropdownMenuThemeData(
                              //             inputDecorationTheme: InputDecorationTheme(
                              //               border: InputBorder.none, // removes default white border
                              //               enabledBorder: InputBorder.none,
                              //               focusedBorder: InputBorder.none,
                              //               contentPadding: EdgeInsets.symmetric(
                              //                 horizontal: 42,
                              //               ),
                              //             ),
                              //             menuStyle: MenuStyle(
                              //               backgroundColor: MaterialStateProperty.all(Colors.black87),
                              //               padding: MaterialStateProperty.all(
                              //                 EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                              //               ),
                              //             )
                              //           ),
                              //         child: DropdownMenu<String>(
                              //           initialSelection: LoginProvider.loginMethods.first,
                              //           width: MediaQuery.of(context).size.width * 0.7,
                              //           textStyle: const TextStyle(
                              //             color: Colors.white,
                              //             fontSize: 16,
                              //             height: 1.2,
                              //             textBaseline: TextBaseline.alphabetic,
                              //           ),
                              //           onSelected: (value) => viewModel.handleChangeLoginMethod(value!),
                              //           dropdownMenuEntries: LoginProvider.loginMethods.map((method) {
                              //             return DropdownMenuEntry<String>(
                              //               value: method,
                              //               label: method,
                              //               style: ButtonStyle(
                              //                 alignment: Alignment.center,
                              //                 padding: const MaterialStatePropertyAll(
                              //                   EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              //                 ),
                              //                 backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                              //                   (states) {
                              //                     if (states.contains(WidgetState.focused)) {
                              //                       return Colors.pink; // active background
                              //                     }
                              //                     return Colors.transparent;
                              //                   },
                              //                 ),
                              //                 foregroundColor: MaterialStateProperty.resolveWith<Color>(
                              //                   (states) {
                              //                     if (states.contains(WidgetState.focused)) {
                              //                       return Colors.white; // active text
                              //                     }
                              //                     return Colors.white70; // inactive text
                              //                   },
                              //                 ),
                              //                 shape: MaterialStatePropertyAll(
                              //                   RoundedRectangleBorder(
                              //                     borderRadius: BorderRadius.circular(12),
                              //                   ),
                              //                 ),
                              //                 minimumSize: MaterialStateProperty.all(
                              //                   Size(MediaQuery.of(context).size.width * 0.7, 48), 
                              //                 ),
                              //                 elevation: MaterialStateProperty.resolveWith<double>(
                              //                   (states) {
                              //                     if (method == viewModel.loginMethod) {
                              //                       return 3.0; // shadow elevation when focused
                              //                     }
                              //                     return 0.0;
                              //                   },
                              //                 ),
                              //                 shadowColor: MaterialStateProperty.all(Colors.grey),
                              //               ),
                              //             );
                              //           }).toList(),
                              //         ),
                              //       ),
                              //     ),
                              // ),
                              SizedBox(height: 8.0),
                              Center(
                                child: GestureDetector(
                                  onTap: viewModel.handleClickForgotPassword,
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                      color: Colors.blue,            // blue like a hyperlink
                                      decoration: TextDecoration.underline, // underline
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
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
                                      : () => _handleClickCreateNewWallet(context),
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
                                      : () => viewModel.showImportDialog(viewModel.context),
                                ),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: viewModel.handleSignInWithPassword,
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.blue,            // blue like a hyperlink
                                      decoration: TextDecoration.underline, // underline
                                      fontSize: 16,
                                    ),
                                  ),
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
          }
        );
    }
}

class _CreateWalletDialog extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final VoidCallback onCancel;
  final Future Function(String) onCreateWallet;

  const _CreateWalletDialog({
    required this.passwordController,
    required this.confirmController,
    required this.onCancel,
    required this.onCreateWallet,
  });

  @override
  State<_CreateWalletDialog> createState() => _CreateWalletDialogState();
}

class _CreateWalletDialogState extends State<_CreateWalletDialog> {
  bool _processing = false;

  Future<void> _handleOkClick() async {
    final password = widget.passwordController.text.trim();
    final confirm = widget.confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      AIHelpers.showToast(msg: "Please enter both fields.");
      return;
    }
    if (password != confirm) {
      AIHelpers.showToast(msg: "Passwords don't match.");
      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      await widget.onCreateWallet(password);
    } catch (e) {
      AIHelpers.showToast(msg: "Failed to create wallet: $e");
      setState(() {
        _processing = false;
      });
    }
  }

  void _handleClickCancel() {
    widget.onCancel();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero, // full screen
      backgroundColor: Colors.transparent,
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            color: AIColors.modalBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // 🔹 Header with title + close button
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: null,
                      ),
                    ),
                    const Text(
                      "Create a New Wallet",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _handleClickCancel,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // 🔹 Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    AIPasswordField(
                      hintText: "Password",
                      controller: widget.passwordController
                    ),
                    const SizedBox(height: 18),
                    AIPasswordField(
                      hintText: "Confirm Password",
                      controller: widget.confirmController)
                    ,
                  ],
                    ),
              ),
              // 🔹 Footer actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _processing ? null : _handleClickCancel,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 24.0),
                    GestureDetector(
                      onTap: _processing ? null : _handleOkClick,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFF30C6C), // pink
                              Color(0xFFC739EB), // purple
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 8.0),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            child: _processing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2.0, color: Colors.white),
                                  )
                                : const Text("OK"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

