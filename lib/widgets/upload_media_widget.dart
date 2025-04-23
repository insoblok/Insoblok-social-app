import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UploadMediaWidget extends StatelessWidget {
  const UploadMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UploadMediaProvider>.reactive(
      viewModelBuilder: () => UploadMediaProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        if (viewModel.medias.isEmpty) return Container();
        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
          ),
          itemBuilder: (context, index) {
            var media = viewModel.medias[index];
            return Container(
              decoration: kCardDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: AIImage(
                  media.file,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          itemCount: viewModel.medias.length,
        );
      },
    );
  }
}
