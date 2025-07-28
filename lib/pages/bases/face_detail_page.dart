import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class FaceDetailPage extends StatelessWidget {
  final String url;
  const FaceDetailPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaceDetailProvider>.reactive(
      viewModelBuilder: () => FaceDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, url: url),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              AIImage(url, width: double.infinity, height: double.infinity),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child:
                    viewModel.face != null
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 24.0,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 24.0,
                                  children: [
                                    for (var content
                                        in viewModel.annotations) ...{
                                      Column(
                                        spacing: 4.0,
                                        children: [
                                          AIImage(
                                            content.icon,
                                            width: 60.0,
                                            height: 60.0,
                                          ),
                                          Text(
                                            '${content.title}\n${content.desc}',
                                            textAlign: TextAlign.center,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    },
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(24.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24.0),
                                  child: AIImage(
                                    viewModel.face,
                                    fit: BoxFit.contain,
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                ),
                              ),
                              SizedBox(height: 40.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withAlpha(32),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 40.0,
                                  children: [
                                    for (var data in kMediaDetailIconData) ...{
                                      InkWell(
                                        // onTap:
                                        //     () => viewModel.onClickActionButton(
                                        //       kMediaDetailIconData.indexOf(
                                        //         data,
                                        //       ),
                                        //     ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AIImage(
                                              data['icon'],
                                              height: 24.0,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                            ),
                                            Text(
                                              data['title'] as String,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    },
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        : Container(),
              ),
              CustomCircleBackButton(),
              if (viewModel.isBusy)
                Align(
                  alignment: Alignment.center,
                  child: Center(child: Loader(size: 60.0)),
                ),
            ],
          ),
        );
      },
    );
  }
}
