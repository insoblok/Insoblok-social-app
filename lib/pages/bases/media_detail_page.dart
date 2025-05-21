import 'package:flutter/material.dart';
import 'package:insoblok/services/image_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class MediaDetailPage extends StatelessWidget {
  final List<String> medias;
  const MediaDetailPage({super.key, required this.medias});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MediaDetailProvider>.reactive(
      viewModelBuilder: () => MediaDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              AIImage(
                medias.first,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
              CustomCircleBackButton(),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    top: MediaQuery.of(context).padding.top + 12.0,
                  ),
                  child: CircleImageButton(
                    src: Icons.share,
                    size: 36.0,
                    onTap: () => AIHelpers.shareFileToSocial(medias.first),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
