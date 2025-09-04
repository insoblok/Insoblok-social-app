import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class FaceDetailPage extends StatelessWidget {
  final String storyID;
  final String url;
  final File face;
  final List<AIFaceAnnotation> annotations;
  final bool editable;

  const FaceDetailPage({super.key, required this.storyID, required this.url, required this.face, required this.annotations, required this.editable});

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<FaceDetailProvider>.reactive(
      viewModelBuilder: () => FaceDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, storyID:storyID, url: url, face: face, annotations:annotations, editable:editable),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              AIImage(viewModel.url, width: double.infinity, height: double.infinity),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child:
                    viewModel.hypeFace != null
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 24.0,
                            children: [
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
                                    viewModel.hypeFace,
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
                                    for (var data in kReactionPostIconData) ...{
                                      InkWell(
                                        onTap:
                                            () => viewModel.onClickActionButton(
                                              kReactionPostIconData.indexOf(
                                                data,
                                              ),
                                            ),
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
                                              textAlign: TextAlign.center, // important for two-line centering
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
                        : Container(
                            color: Colors.black26,
                            child: const Center(child: Loader(size: 60)),
                          ),
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
