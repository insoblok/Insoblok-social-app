import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountAvatarPage extends StatelessWidget {
  const AccountAvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Setting'), centerTitle: true),
      body: ViewModelBuilder<AvatarProvider>.reactive(
        viewModelBuilder: () => AvatarProvider(),
        onViewModelReady: (viewModel) => viewModel.init(context),
        builder: (context, viewModel, _) {
          return Stack(
            children: [
              InAppWebView(
                key: GlobalKey(),
                initialUrlRequest: URLRequest(url: WebUri(kScrappingUrl)),
                initialSettings: InAppWebViewSettings(
                  isInspectable: kDebugMode,
                  useOnLoadResource: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: false,
                  iframeAllow: "camera; microphone",
                  iframeAllowFullscreen: true,
                  disableVerticalScroll: false,
                  disableHorizontalScroll: true,
                  allowsBackForwardNavigationGestures: false,
                  allowsLinkPreview: false,
                  useHybridComposition: true,
                  supportZoom: false,
                ),
                onWebViewCreated: (controller) {
                  viewModel.webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  logger.d('onLoadStart: $url');
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  logger.d('onLoadStop: $url');
                  viewModel.setWebview();
                },
                onReceivedError: (controller, request, error) {
                  logger.d('onReceivedError: $error');
                },
                onProgressChanged: (controller, progress) {
                  logger.d('onProgressChanged: $progress');
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  logger.d('onUpdateVisitedHistory: $url');
                },
                onConsoleMessage: (controller, consoleMessage) {
                  logger.d('onUpdateVisitedHistory: $consoleMessage');
                },
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Column(
                    children: [
                      ValueListenableBuilder<AccountProviderState>(
                        valueListenable: viewModel.stateListener,
                        builder: (context, value, _) {
                          if (value == AccountProviderState.init) {
                            return AccountHeaderInitView();
                          }
                          if (value == AccountProviderState.loaded) {
                            return AccountHeaderLoadedView();
                          }
                          return AccountHeaderReadyView();
                        },
                      ),
                      Expanded(
                        child: ValueListenableBuilder<AccountProviderState>(
                          valueListenable: viewModel.stateListener,
                          builder: (context, value, _) {
                            if (value == AccountProviderState.init) {
                              return AccountBodyInitView();
                            }
                            return Container(
                              width: double.infinity,
                              color: AppSettingHelper.background,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 58,
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: viewModel.onClickConvertImage,
                                    child: Container(
                                      width: 280.0,
                                      height: 44.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                        color: AIColors.pink,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Create Image',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 50.0),
                                  Container(
                                    width: double.infinity,
                                    height: 188.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2.0,
                                        color: AIColors.borderColor,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child:
                                        value == AccountProviderState.done
                                            ? AIImage(viewModel.aiImageUrl)
                                            : Text(
                                              'Created AI Image',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                  ),
                                  const SizedBox(height: 50.0),
                                  InkWell(
                                    onTap: viewModel.onClickConfirm,
                                    child: Container(
                                      width: 280.0,
                                      height: 44.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                        color: Colors.red,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Confirm',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<AccountProviderState>(
                valueListenable: viewModel.stateListener,
                builder: (context, value, _) {
                  return value == AccountProviderState.creating
                      ? Align(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.black38,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Loader(size: 60),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24.0,
                                  horizontal: 60.0,
                                ),
                                child: Text(
                                  'Your image will be ready in nearly 60 seconds. Thank you for your patience!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class AccountHeaderInitView extends ViewModelWidget<AvatarProvider> {
  const AccountHeaderInitView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      width: double.infinity,
      color: AppSettingHelper.background,
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 58),
      child: ShimmerContainer(
        child: Container(
          width: double.infinity,
          height: 188,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AccountHeaderLoadedView extends ViewModelWidget<AvatarProvider> {
  const AccountHeaderLoadedView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 52.0,
          color: AppSettingHelper.background,
          padding: const EdgeInsets.symmetric(horizontal: 58.0),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 2.0,
            color: AIColors.borderColor,
          ),
        ),
        Row(
          children: [
            Container(
              height: 184.0,
              width: 60.0,
              decoration: BoxDecoration(
                color: AppSettingHelper.background,
                border: Border(
                  right: BorderSide(width: 2.0, color: AIColors.borderColor),
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 184.0,
              width: 60.0,
              decoration: BoxDecoration(
                color: AppSettingHelper.background,
                border: Border(
                  left: BorderSide(width: 2.0, color: AIColors.borderColor),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 52.0,
          color: AppSettingHelper.background,
          padding: const EdgeInsets.symmetric(horizontal: 58.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 2.0,
                color: AIColors.borderColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccountHeaderReadyView extends ViewModelWidget<AvatarProvider> {
  const AccountHeaderReadyView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    final cleanBase64 = viewModel.base64Org!.split(',').last;
    final bytes = base64.decode(cleanBase64);

    return Container(
      width: double.infinity,
      color: AppSettingHelper.background,
      padding: const EdgeInsets.symmetric(horizontal: 58),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50.0,
            alignment: Alignment.center,
            child: InkWell(
              onTap: viewModel.onClickClearButton,
              child: Text(
                'Clear'.toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 188,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: AIColors.borderColor),
            ),
            child: AIImage(bytes, fit: BoxFit.contain),
          ),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

class AccountBodyInitView extends ViewModelWidget<AvatarProvider> {
  const AccountBodyInitView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Container(
      width: double.infinity,
      color: AppSettingHelper.background,
      padding: const EdgeInsets.symmetric(horizontal: 58),
      child: Column(
        children: [
          ShimmerContainer(
            child: Container(
              width: 280.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          ShimmerContainer(
            child: Container(
              width: double.infinity,
              height: 188.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 50.0),
          ShimmerContainer(
            child: Container(
              width: 280.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
