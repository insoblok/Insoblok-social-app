import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PrivacyProvider>.reactive(
      viewModelBuilder: () => PrivacyProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                // InAppWebView(
                //   key: GlobalKey(),
                //   initialUrlRequest: URLRequest(
                //     url: WebUri('https://www.insoblokai.io/privacy-policy'),
                //   ),
                //   initialUserScripts: UnmodifiableListView<UserScript>([]),
                //   initialSettings: viewModel.settings,
                //   onWebViewCreated: (controller) async {
                //     viewModel.webViewController = controller;
                //   },
                //   onLoadStart: (controller, url) {
                //     logger.d(url);
                //   },
                //   onPermissionRequest: (controller, request) async {
                //     return PermissionResponse(
                //       resources: request.resources,
                //       action: PermissionResponseAction.GRANT,
                //     );
                //   },
                //   shouldOverrideUrlLoading: (
                //     controller,
                //     navigationAction,
                //   ) async {
                //     var uri = navigationAction.request.url!;

                //     if (![
                //       "http",
                //       "https",
                //       "file",
                //       "chrome",
                //       "data",
                //       "javascript",
                //       "about",
                //     ].contains(uri.scheme)) {
                //       if (await canLaunchUrl(uri)) {
                //         await launchUrl(uri);
                //         return NavigationActionPolicy.CANCEL;
                //       }
                //     }

                //     return NavigationActionPolicy.ALLOW;
                //   },
                //   onLoadStop: (controller, url) {
                //     logger.d('onLoadStop');
                //   },
                //   onReceivedError: (controller, request, error) {
                //     logger.d('onReceivedError');
                //   },
                //   onProgressChanged: (controller, progress) {
                //     logger.d(progress);
                //   },
                //   onUpdateVisitedHistory: (controller, url, isReload) {
                //     logger.d(url);
                //   },
                //   onConsoleMessage: (controller, consoleMessage) {
                //     logger.d(consoleMessage);
                //   },
                // ),
                Container(
                  width: double.infinity,
                  height: 80.0,
                  color: AppSettingHelper.background,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon:
                            Platform.isIOS
                                ? Icon(Icons.arrow_back_ios)
                                : Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: AppSettingHelper.textColor,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(width: 40.0, height: 24.0),
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
