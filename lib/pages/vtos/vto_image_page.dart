import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:stacked/stacked.dart';

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
                        child: Text(product.categoryName ?? ''),
                      ),
                      const Spacer(),
                      Text(
                        product.regdate?.timeago ?? '',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  AIHelpers.htmlRender(product.description),

                  const SizedBox(height: 24.0),
                  Text(
                    'Take a Model',
                    style: Theme.of(context).textTheme.titleSmall,
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
                        Row(
                          spacing: 12.0,
                          children: [
                            VTOOriginImageView(),
                            VTOResultImageView(),
                          ],
                        ),
                        if (viewModel.resultModel.isNotEmpty) ...{
                          Container(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                              right: 12.0,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 100.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Add Description',
                                  border: InputBorder.none,
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: null,
                                controller: viewModel.textController,
                                onChanged: (value) => viewModel.content = value,
                                onFieldSubmitted: (value) {},
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                        },
                        const SizedBox(height: 24.0),
                        TextFillButton(
                          text: 'Convert Now',
                          isBusy: viewModel.isConverting,
                          onTap: viewModel.onClickConvert,
                          color: Theme.of(context).primaryColor,
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
                    (viewModel.resultModel.isEmpty))
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
                        viewModel.resultModel.isNotEmpty
                            ? AIImage(
                              viewModel.resultModel,
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
                if (viewModel.resultModel.isNotEmpty) ...{
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
                                  viewModel.resultModel,
                                ]),
                          ),
                          CircleImageButton(
                            src: Icons.share,
                            onTap: viewModel.onClickShareButton,
                          ),
                          CircleImageButton(
                            src: Icons.download,
                            onTap: viewModel.onClickDownloadButton,
                          ),
                          CircleImageButton(
                            src: Icons.upload,
                            onTap: viewModel.onClickUploadButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12.0,
                    left: 0.0,
                    right: 0.0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: viewModel.savetoLookBook,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withAlpha(172),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Text(
                            viewModel.txtLookbookButton.isEmpty
                                ? 'Save to LookBook'
                                : viewModel.txtLookbookButton,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AIColors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (viewModel.txtLookbookButton.isNotEmpty)
                    Positioned.fill(
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader,
                            colors: [AIColors.pink],
                            strokeWidth: 2,
                          ),
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
