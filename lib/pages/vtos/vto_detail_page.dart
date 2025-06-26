import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';

class VTODetailPage extends StatelessWidget {
  final VTODetailPageModel model;

  const VTODetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VTODetailProvider>.reactive(
      viewModelBuilder: () => VTODetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, model: model),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              AIImage(
                model.resultImage,
                width: double.infinity,
                height: double.infinity,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: viewModel.isShownText ? 5.0 : 0.0,
                  sigmaY: viewModel.isShownText ? 5.0 : 0.0,
                ),
                blendMode: BlendMode.srcOver,
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 12.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                if (viewModel.isBusy) return;
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 0.5,
                                  ),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary.withAlpha(64),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            if (viewModel.isShownText)
                              Text(
                                'InSoBlok AI',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            SizedBox(width: 32.0),
                          ],
                        ),
                      ),
                      if (viewModel.isShownText) ...{
                        const SizedBox(height: 4.0),
                        Text(
                          'Vote to Earn – Vybe Virtual Try-On',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      },
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              if (viewModel.strLoading.isNotEmpty)
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.0),
                    height: 200.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withAlpha(128),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 24.0,
                      children: [
                        Loader(size: 64.0),
                        Text(
                          viewModel.strLoading,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            key: viewModel.key,
            type: ExpandableFabType.fan,
            onOpen: () {
              viewModel.isShownText = true;
            },
            onClose: () {
              viewModel.isShownText = false;
            },
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                heroTag: null,
                child: const Icon(Icons.favorite_border),
                onPressed: () => viewModel.onTapActionButton(0),
              ),
              FloatingActionButton(
                shape: const CircleBorder(),
                heroTag: null,
                child: const Icon(Icons.share),
                onPressed: () => viewModel.onTapActionButton(1),
              ),
              FloatingActionButton(
                shape: const CircleBorder(),
                heroTag: null,
                child: const Icon(Icons.save),
                onPressed: () => viewModel.onTapActionButton(2),
              ),
            ],
          ),
        );
      },
    );
  }
}
