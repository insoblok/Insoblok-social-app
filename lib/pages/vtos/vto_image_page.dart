import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
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
          body: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              Row(
                spacing: 24.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12.0),
                          child: AIImage(
                            viewModel.product.modelImage,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text('Information'),
                        VTOInformationView(),
                        const SizedBox(height: 24.0),
                        TextFillButton(
                          text: 'Take Model',
                          isBusy: viewModel.isConverting,
                          onTap: viewModel.onClickConvert,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
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
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
        const SizedBox(height: 8.0),
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
        // const SizedBox(height: 12.0),
        // AIHelpers.htmlRender(viewModel.product.description),
      ],
    );
  }
}
