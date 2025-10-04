import 'dart:io';

import 'package:flutter/material.dart';

// import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

class ProductImageView extends StatelessWidget {
  final String title;
  final String? imagePath;
  final void Function()? onTap;

  const ProductImageView({
    super.key,
    required this.title,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 0.66,
                color: Theme.of(context).primaryColor,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SizedBox(
                  child: AspectRatio(
                    aspectRatio: 0.7,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        imagePath == null
                            ? Container()
                            : AIImage(File(imagePath!), fit: BoxFit.contain),
                        if (imagePath == null)
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              size: 80.0,
                              Icons.add_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;
  final void Function()? onTap;

  const ProductItemWidget({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    var medias = product.medias ?? [];
    return Container(
      decoration: BoxDecoration(
        color: AppSettingHelper.background,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppSettingHelper.greyBackground,
            blurRadius: 1.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              AIImage(
                product.avatarImage ??
                    (
                      medias.isNotEmpty ? medias.last.link : product.modelImage,
                    ),
                width: double.infinity,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    color: Theme.of(
                      context,
                    ).colorScheme.onSecondary.withAlpha(160),
                    child: Text(
                      product.name ?? '',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
