import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chewie/chewie.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/generated/l10n.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginProvider>.reactive(
      viewModelBuilder: () => LoginProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              viewModel.videoPlayerController.value.isInitialized
                  ? LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: AspectRatio(
                          aspectRatio:
                              viewModel.videoPlayerController.value.aspectRatio,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width:
                                  viewModel
                                      .videoPlayerController
                                      .value
                                      .size
                                      .width,
                              height:
                                  viewModel
                                      .videoPlayerController
                                      .value
                                      .size
                                      .height,
                              child: Chewie(
                                controller: viewModel.chewieController,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  : AIImage(
                    AIImages.imgBackSplash,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.top + 16.0,
                    ),
                    const SizedBox(width: 16.0),
                    Row(
                      children: [
                        AIImage(
                          AIImages.logoInsoblok,
                          width: 48.0,
                          height: 48.0,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          S.current.title.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedTextKit(
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(
                              'First Layer 1 SocialFi &',
                              textStyle: TextStyle(
                                fontSize: 32.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AnimatedTextKit(
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(
                              'Influencer Commerce',
                              textStyle: TextStyle(
                                fontSize: 32.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        AnimatedTextKit(
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(
                              'Platform',
                              textStyle: TextStyle(
                                fontSize: 32.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    SlideTransition(
                      position: _positionAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Powering Influencer Commerce, P2P Payments, Dynamic Soveringity ,User Driven Ecosytem',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80.0),
                    Row(
                      children: [
                        const SizedBox(width: 24.0),
                        Expanded(
                          child: Container(
                            color: AIColors.darkScaffoldBackground.withAlpha(
                              216,
                            ),
                            child: OutlineButton(
                              isBusy: viewModel.isBusy,
                              borderColor: AIColors.yellow,
                              onTap: viewModel.login,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AIImage(AIImages.imgMetamask, width: 28.0),
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
                          ),
                        ),
                        const SizedBox(width: 24.0),
                      ],
                    ),
                    const SizedBox(height: 60.0),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text('If you already have an account?'),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () => Routers.goToAuthPage(context),
                        child: Text(
                          'Login with Email',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AIColors.yellow),
                        ),
                      ),
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
