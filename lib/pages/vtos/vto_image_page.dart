import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:insoblok/routers/routers.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class VTOImagePage extends StatelessWidget {
  final ProductModel product;

  const VTOImagePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VTOImageProvider>.reactive(
      viewModelBuilder: () => VTOImageProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, p: product),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text(product.name ?? 'VTO'), centerTitle: true),
          body: Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                children: [
                  AIImage(
                    viewModel.product.modelImage,
                    width: double.infinity,
                    height: 240.0,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => viewModel.tagIndex = 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border:
                                  viewModel.tagIndex == 0
                                      ? Border(
                                        bottom: BorderSide(
                                          width: 2.0,
                                          color: AIColors.pink,
                                        ),
                                      )
                                      : null,
                            ),
                            child: Text(
                              'Information',
                              style:
                                  viewModel.tagIndex == 0
                                      ? Theme.of(context).textTheme.bodyMedium
                                      : Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => viewModel.tagIndex = 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border:
                                  viewModel.tagIndex == 1
                                      ? Border(
                                        bottom: BorderSide(
                                          width: 2.0,
                                          color: AIColors.pink,
                                        ),
                                      )
                                      : null,
                            ),
                            child: Text(
                              'Uesr Gallery(s)',
                              style:
                                  viewModel.tagIndex == 1
                                      ? Theme.of(context).textTheme.bodyMedium
                                      : Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  viewModel.tagIndex == 0
                      ? VTOInformationView()
                      : VTOGalleryView(),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Take a Model',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Important: You will first receive an id number with this call. Then you will have to retrieve the image after 30/40 seconds during the second call using this id number (asynchronous generation).',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 12.0),
                        if (viewModel.product.category ==
                            ProductCategory.CLOTHING) ...{
                          Row(
                            spacing: 12.0,
                            children: [
                              VTOOriginImageView(),
                              VTOResultImageView(),
                            ],
                          ),
                        },

                        if (viewModel.product.category ==
                            ProductCategory.JEWELRY) ...{
                          VTOFashionImageView(),
                        },

                        const SizedBox(height: 24.0),
                        TextFillButton(
                          text:
                              viewModel.serverUrl != null
                                  ? 'Save to LOOKBOOK'
                                  : 'Convert Now',
                          isBusy: viewModel.isConverting,
                          onTap:
                              viewModel.serverUrl != null
                                  ? viewModel.savetoLookBook
                                  : viewModel.onClickConvert,
                          color: Theme.of(context).primaryColor,
                        ),
                        if (viewModel.serverUrl != null)
                          Column(
                            children: [
                              const SizedBox(height: 8.0),
                              OutlineButton(
                                isBusy: viewModel.isConverting,
                                onTap: viewModel.onClickShareButton,
                                borderColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'Share to Twitter',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              OutlineButton(
                                isBusy: viewModel.isConverting,
                                onTap: viewModel.saveToPost,
                                borderColor: Theme.of(context).primaryColor,
                                child: Text(
                                  'Create Yay/Nay Poll',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24.0),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class VTOFashionImageView extends ViewModelWidget<VTOImageProvider> {
  const VTOFashionImageView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      children: [
        Row(
          spacing: 12.0,
          children: [
            if (viewModel.countries.isNotEmpty)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Country'),
                    const SizedBox(height: 4.0),
                    Container(
                      height: 44.0,
                      decoration: kNoBorderDecoration,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton<UserCountryModel>(
                        isExpanded: true,
                        value: viewModel.selectedCountry,
                        dropdownColor:
                            Theme.of(context).colorScheme.onSecondary,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: Container(),
                        items:
                            viewModel.countries.map((country) {
                              return DropdownMenuItem(
                                value: country,
                                child: Text(
                                  country.name ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            }).toList(),
                        onChanged: (c) => viewModel.selectedCountry = c,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gender'),
                  const SizedBox(height: 4.0),
                  Container(
                    height: 44.0,
                    decoration: kNoBorderDecoration,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: viewModel.gender,
                      dropdownColor: Theme.of(context).colorScheme.onSecondary,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: Container(),
                      items:
                          [ProductCategory.MAN, ProductCategory.WOMAN].map((
                            name,
                          ) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(
                                name.toTitleCase,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          }).toList(),
                      onChanged: (g) => viewModel.gender = g,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Age (30 ~ 70)'),
                  const SizedBox(height: 4.0),
                  Container(
                    height: 44.0,
                    decoration: kNoBorderDecoration,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: viewModel.age,
                      dropdownColor: Theme.of(context).colorScheme.onSecondary,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      underline: Container(),
                      items:
                          List<int>.generate(41, (index) => index + 30).map((
                            value,
                          ) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          }).toList(),
                      onChanged: (i) => viewModel.age = i,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Text('Fashion Image'),
        const SizedBox(height: 12.0),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.33,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child:
                      viewModel.serverUrl != null
                          ? AIImage(
                            viewModel.serverUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          : Center(
                            child: Text(
                              'That will be taken around a min.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                ),
              ),
              if (viewModel.serverUrl != null) ...{
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8.0,
                      children: [
                        CircleImageButton(
                          src: Icons.fullscreen,
                          onTap:
                              () => AIHelpers.goToDetailView(context, [
                                viewModel.serverUrl!,
                              ]),
                        ),
                        CircleImageButton(
                          src: Icons.share,
                          onTap: viewModel.onClickShareButton,
                        ),
                      ],
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class VTOOriginImageView extends ViewModelWidget<VTOImageProvider> {
  const VTOOriginImageView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Expanded(
      child: Column(
        children: [
          Text('Origin Image'),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.33,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: AspectRatio(
                    aspectRatio: 0.7,
                    child:
                        viewModel.selectedFile != null
                            ? AIImage(
                              File(viewModel.selectedFile!.path),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : Center(
                              child: InkWell(
                                onTap: viewModel.onClickAddPhoto,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AIImage(Icons.add_a_photo),
                                    const SizedBox(height: 12.0),
                                    Text('Add Photo'),
                                  ],
                                ),
                              ),
                            ),
                  ),
                ),
                if ((viewModel.selectedFile != null) &&
                    (viewModel.serverUrl == null))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleImageButton(
                      src: Icons.close,
                      onTap: viewModel.onClickCloseButton,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VTOResultImageView extends ViewModelWidget<VTOImageProvider> {
  const VTOResultImageView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Expanded(
      child: Column(
        children: [
          Text('Result Image'),
          const SizedBox(height: 12.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.33,
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: AspectRatio(
                    aspectRatio: 0.7,
                    child:
                        viewModel.serverUrl != null
                            ? AIImage(
                              viewModel.serverUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                            : Center(
                              child: Text(
                                'That will be taken\naround a min.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                  ),
                ),
                if (viewModel.serverUrl != null) ...{
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8.0,
                        children: [
                          CircleImageButton(
                            src: Icons.fullscreen,
                            onTap:
                                () => AIHelpers.goToDetailView(context, [
                                  viewModel.serverUrl!,
                                ]),
                            // onTap: () => Routers.goToVTODetailPage(context),
                          ),
                          CircleImageButton(
                            src: Icons.share,
                            onTap: viewModel.onClickShareButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VTOInformationView extends ViewModelWidget<VTOImageProvider> {
  const VTOInformationView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24.0),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Text(viewModel.product.categoryName ?? ''),
            ),
            const Spacer(),
            Text(
              viewModel.product.timestamp?.timeago ?? '',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        if ((viewModel.product.tags ?? []).isNotEmpty) ...{
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: [
              for (var tag in viewModel.product.tags ?? []) ...{
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 0.33,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              },
            ],
          ),
        },
        const SizedBox(height: 12.0),
        AIHelpers.htmlRender(viewModel.product.description),
      ],
    );
  }
}

class VTOGalleryView extends ViewModelWidget<VTOImageProvider> {
  const VTOGalleryView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    List<MediaStoryModel> medias = viewModel.product.medias ?? [];
    logger.d(medias.length);
    var restValue = medias.length - 3;

    return SizedBox(
      height: 200,
      child:
          medias.isEmpty
              ? Center(
                child: Text(
                  'Not have any gallery image yet!',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
              : Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  spacing: 8.0,
                  children: [
                    for (var i = 0; i < min(3, medias.length); i++) ...{
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap:
                                // () => AIHelpers.goToDetailView(
                                //   context,
                                //   medias
                                //       .map((media) => media.link ?? '')
                                //       .toList(),
                                // ),
                                () => Routers.goToVTODetailPage(context),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: [
                                  AIImage(
                                    medias[i].link,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                  if (restValue > 0 && i == 2) ...{
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withAlpha(127),
                                      alignment: Alignment.center,
                                      child: Text('More +$restValue'),
                                    ),
                                  },
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    },
                    if (restValue < 0) ...{
                      for (var i = 0; i < (3 - medias.length); i++) ...{
                        Spacer(key: GlobalKey(debugLabel: '$i')),
                      },
                    },
                  ],
                ),
              ),
    );
  }
}
