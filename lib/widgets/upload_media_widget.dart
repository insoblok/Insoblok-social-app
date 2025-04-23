import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UploadMediaWidget extends StatelessWidget {
  final void Function()? onRefresh;

  final ScrollController? controller;

  const UploadMediaWidget({super.key, this.controller, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<UploadMediaProvider>();
    if (viewModel.medias.isEmpty) return Container();
    return GridView.builder(
      shrinkWrap: true,
      controller: controller,
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
            child: Stack(
              children: [
                AIImage(
                  File(media.file!.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      viewModel.removeMedia(media);
                      if (onRefresh != null) {
                        onRefresh!();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 4.0, right: 4.0),
                      width: 28.0,
                      height: 28.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            AppSettingHelper.themeMode == ThemeMode.dark
                                ? AIColors.darkTransparentBackground
                                : AIColors.lightTransparentBackground,
                      ),
                      child:
                          media.isUploaded
                              ? Icon(
                                Icons.check,
                                size: 18.0,
                                color: AIColors.blue,
                              )
                              : media.isUploading
                              ? Loader(
                                size: 22.0,
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
      itemCount: viewModel.medias.length,
    );
  }
}
