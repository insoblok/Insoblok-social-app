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
                width: 0.33,
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
    // var category = (product.tags ?? []).isEmpty ? null : product.tags!.first;
    return Container(
      decoration: BoxDecoration(
        color: AppSettingHelper.background,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppSettingHelper.greyBackground,
            blurRadius: 2.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    AIImage(
                      product.avatarImage ?? product.modelImage,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    if (product.avatarImage == null &&
                        (product.medias?.isNotEmpty ?? false))
                      Positioned(
                        right: 4.0,
                        bottom: 4.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: AIImage(
                            product.medias?.first.link,
                            width: 80.0,
                            height: 100.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 8.0,
                    //     vertical: 4.0,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Theme.of(context).primaryColor,
                    //       width: 0.33,
                    //     ),
                    //     borderRadius: BorderRadius.circular(24.0),
                    //   ),
                    //   child: Text(
                    //     product.categoryName ?? '',
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //   ),
                    // ),
                    // if (category != null) ...{
                    //   const SizedBox(height: 8.0),
                    //   Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 8.0,
                    //       vertical: 4.0,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: Theme.of(context).primaryColor,
                    //         width: 0.33,
                    //       ),
                    //       borderRadius: BorderRadius.circular(24.0),
                    //     ),
                    //     child: Text(
                    //       category,
                    //       style: Theme.of(context).textTheme.bodySmall,
                    //     ),
                    //   ),
                    // },
                    // const SizedBox(height: 8.0),
                    Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    // const SizedBox(height: 2.0),
                    // Text(
                    //   product.timestamp?.timeago ?? '',
                    //   style: Theme.of(context).textTheme.labelSmall,
                    // ),
                    // const SizedBox(height: 8.0),
                    // Container(
                    //   constraints: BoxConstraints(maxHeight: 80.0),
                    //   child: AIHelpers.htmlRender(
                    //     product.description,
                    //     fontSize: FontSize(12.0),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
