import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class MediaRemixWidget extends ViewModelWidget<MediaDetailProvider> {
  const MediaRemixWidget({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFF30C6C), // pink
        Color(0xFFC739EB), // purple
      ],
    );
    return Center(
      child: RepaintBoundary(
        key: viewModel.globalkey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'VTO REMIX!',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800,
                      color: AIColors.white,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Row(
                      spacing: 2.0,
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 0.54,
                            child: AIImage(viewModel.medias[viewModel.index]),
                          ),
                        ),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 0.54,
                            child: AIImage(viewModel.imgRemix),
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.double_arrow_sharp,
                          color: Theme.of(context).primaryColor,
                          size: 60.0,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10.0,
                      child: Column(
                        children: [
                          const Spacer(),
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                'Before'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  color: AIColors.white,
                                ),
                              ),
                              Spacer(flex: 2),
                              Text(
                                'After'.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  color: AIColors.white,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RemixActionView extends ViewModelWidget<MediaDetailProvider> {
  const RemixActionView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    final bool isOwner =
        (AuthHelper.user?.id == viewModel.storyUser &&
            viewModel.storyUser != '');

    return Column(
      spacing: 12.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary.withAlpha(32),
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 15.0,
            children: [
              for (var data in kMediaDetailIconData) ...{
                if (isOwner || data['title'] != 'Remove')
                  InkWell(
                    onTap:
                        () => viewModel.onClickActionButton(
                          kMediaDetailIconData.indexOf(data),
                        ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AIImage(
                          data['icon'],
                          height: 24.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          data['title'] as String,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
              },
            ],
          ),
        ),
        if (viewModel.isRemixingDialog)
          Container(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary.withAlpha(32),
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12.0,
              children: [
                SizedBox(
                  height: 120.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      spacing: 8.0,
                      children: [
                        for (var product in viewModel.products) ...{
                          AspectRatio(
                            aspectRatio: 0.75,
                            child: InkWell(
                              onTap: () => viewModel.selectedProduct = product,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Stack(
                                  children: [
                                    AIImage(
                                      product.avatarImage ?? product.modelImage,
                                      height: double.infinity,
                                    ),
                                    if (product == viewModel.selectedProduct)
                                      Align(
                                        alignment: Alignment.center,
                                        child: AIImage(
                                          AIImages.icColorSet,
                                          width: 24.0,
                                          height: 24.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                Wrap(
                  runSpacing: 8.0,
                  spacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var key in kRemixColorSet.keys) ...{
                      InkWell(
                        onTap: () {
                          viewModel.remixKey = key;
                        },
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: kRemixColorSet[key],
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child:
                              viewModel.remixKey == key
                                  ? AIImage(
                                    AIImages.icColorSet,
                                    width: 24.0,
                                    height: 24.0,
                                  )
                                  : null,
                        ),
                      ),
                    },
                    InkWell(
                      onTap: viewModel.onEventRemix,
                      child: Container(
                        height: 32.0,
                        width: 64.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFF30C6C), Color(0xFFC739EB)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Text(
                          'Set'.toUpperCase(),
                          style: TextStyle(
                            color: AIColors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.isRemixingDialog = false;
                        viewModel.remixKey = '';
                      },
                      child: Container(
                        height: 32.0,
                        width: 64.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Cancel'.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
