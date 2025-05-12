import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class VTOClothingPage extends StatelessWidget {
  const VTOClothingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VTOClothingProvider>.reactive(
      viewModelBuilder: () => VTOClothingProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('VTO Clothing'), centerTitle: true),
          body: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              Text(
                'Important: You will first receive an id number with this call. Then you will have to retrieve the image after 30/40 seconds during the second call using this id number (asynchronous generation).',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 24.0),
              Text('Photo of Model'),
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                height: 160.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.33,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child:
                    viewModel.photoModel.isNotEmpty
                        ? AIImage(
                          viewModel.photoModel,
                          width: double.infinity,
                          height: 160.0,
                          fit: BoxFit.contain,
                        )
                        : viewModel.selectedFile != null
                        ? AIImage(
                          File(viewModel.selectedFile!.path),
                          width: double.infinity,
                          height: 160.0,
                          fit: BoxFit.contain,
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
              const SizedBox(height: 24.0),
              Text('Photo of Clothing'),
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                height: 160.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.33,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: AIImage(
                  kDefaultClothesModelLink,
                  width: double.infinity,
                  height: 160.0,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 24.0),
              TextFillButton(
                text: 'Convert Now',
                isBusy: viewModel.isConverting,
                onTap: viewModel.onClickConvert,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24.0),
              Text('Photo of Result'),
              const SizedBox(height: 12.0),
              Container(
                width: double.infinity,
                height: 160.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.33,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child:
                    viewModel.resultModel.isNotEmpty
                        ? AIImage(
                          viewModel.resultModel,
                          width: double.infinity,
                          height: 160.0,
                          fit: BoxFit.contain,
                        )
                        : Center(
                          child: Text('That will be taken around a min'),
                        ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }
}
