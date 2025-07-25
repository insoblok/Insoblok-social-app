import 'dart:io';

import 'package:flutter/material.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/video_widget.dart';
import 'package:stacked/stacked.dart';

class UploadMediaWidget extends ViewModelWidget<AddStoryProvider> {
  const UploadMediaWidget({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    var medias = viewModel.mediaProvider.medias;

    if (medias.isEmpty) return Container();
    return GridView.builder(
      shrinkWrap: true,
      controller: viewModel.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        var media = medias[index];
        var mediaPath = media.file!.path;
        var mediaType = mediaPath.endsWith('mp4') ? 'video' : 'image';
        return Container(
          key: GlobalKey(debugLabel: 'media-$index'),
          decoration: kCardDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                mediaType == 'image'
                    ? AIImage(
                      File(media.file!.path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : VideoView(
                      videoUrl: mediaPath,
                      width: double.infinity,
                      height: double.infinity,
                      loaderSize: 20.0,
                    ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => viewModel.onRemoveMedia(media),
                    child: Container(
                      margin: const EdgeInsets.only(top: 4.0, right: 4.0),
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppSettingHelper.transparentBackground,
                      ),
                      child:
                          media.isUploaded
                              ? Icon(
                                Icons.check,
                                size: 18.0,
                                color: AIColors.pink,
                              )
                              : media.isUploading
                              ? Loader(
                                size: 20.0,
                                color: AIColors.red,
                                strokeWidth: 0.5,
                              )
                              : Icon(Icons.close, size: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: medias.length,
    );
  }
}
