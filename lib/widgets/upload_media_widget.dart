import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UploadMediaWidget extends StatelessWidget {
  const UploadMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.read<UploadMediaProvider>();
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
              File(media.file!.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      itemCount: viewModel.medias.length,
    );
  }
}
