import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insoblok/extensions/user_extension.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AIImage extends StatelessWidget {
  final dynamic src;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final bool noCache;
  final Color? backgroundColor;
  final bool noTransitions;
  final bool hasSpinner;

  const AIImage(
    this.src, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.noCache = false,
    this.backgroundColor,
    this.noTransitions = false,
    this.hasSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (ImageType.getImageType(src)) {
      case ImageType.onlineLink:
        return CachedNetworkImage(
          imageUrl: src as String,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          fadeInDuration: Duration(milliseconds: noTransitions ? 0 : 500),
          errorWidget: (context, e, _) {
            return AIDefaultImage(
              width: width,
              height: height,
              hasSpinner: hasSpinner,
            );
          },
          placeholder:
              (ctx, _) => AIDefaultImage(
                width: width,
                height: height,
                hasSpinner: hasSpinner,
              ),
        );
      case ImageType.offlineSvg:
        return SvgPicture.asset(
          src as String,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          colorFilter:
              color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
        );
      case ImageType.offlineImage:
        return Image.asset(
          src as String,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return AIDefaultImage(
              width: width,
              height: height,
              hasSpinner: hasSpinner,
            );
          },
        );
      case ImageType.binary:
        return Image.memory(
          src as Uint8List,
          width: width,
          height: height,
          fit: fit ?? BoxFit.contain,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            logger.e(error);
            return AIDefaultImage(
              width: width,
              height: height,
              hasSpinner: hasSpinner,
            );
          },
        );
      case ImageType.iconData:
        return Icon(
          src as IconData,
          size:
              (width != null && height != null)
                  ? max(width!, height!)
                  : (width != null)
                  ? width
                  : (height != null)
                  ? height
                  : null,
          color: color,
        );
      case ImageType.file:
        return Image.file(
          src as File,
          width: width,
          height: height,
          fit: fit ?? BoxFit.none,
          color: color,
        );
      default:
        return AIDefaultImage(
          width: width,
          height: height,
          hasSpinner: hasSpinner,
        );
    }
  }
}

class AIDefaultImage extends StatelessWidget {
  final double? width;
  final double? height;
  final bool hasSpinner;

  const AIDefaultImage({
    super.key,
    this.width,
    this.height,
    this.hasSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    if (width != null && height != null) {
      return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        color: hasSpinner ? AIColors.transparent : AIColors.placeholdBackground,
        child:
            hasSpinner
                ? Center(child: Loader())
                : AIImage(
                  AIImages.placehold,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                ),
      );
    }
    if (width != null) {
      return AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          width: width,
          alignment: Alignment.center,
          color:
              hasSpinner ? AIColors.transparent : AIColors.placeholdBackground,
          child:
              hasSpinner
                  ? Center(child: Loader())
                  : AIImage(
                    AIImages.placehold,
                    width: width,
                    fit: BoxFit.contain,
                  ),
        ),
      );
    }
    if (height != null) {
      return Container(
        height: height,
        alignment: Alignment.center,
        color: hasSpinner ? AIColors.transparent : AIColors.placeholdBackground,
        child:
            hasSpinner
                ? Center(child: Loader())
                : AIImage(
                  AIImages.placehold,
                  height: height,
                  fit: BoxFit.contain,
                ),
      );
    }
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: hasSpinner ? AIColors.transparent : AIColors.placeholdBackground,
        child:
            hasSpinner
                ? Center(child: Loader())
                : AIImage(
                  AIImages.placehold,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;
  final double? size;

  const Loader({super.key, this.color, this.strokeWidth, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: LoadingIndicator(
        indicatorType: Indicator.ballSpinFadeLoader,
        colors: [Theme.of(context).primaryColor],
        strokeWidth: 2,
      ),
    );
  }
}

class AIAvatarImage extends StatelessWidget {
  final dynamic avatar;
  final String fullname;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final double? textSize;
  final bool noCache;
  final Color? backgroundColor;
  final bool noTransitions;
  final bool hasSpinner;

  const AIAvatarImage(
    this.avatar, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.noCache = false,
    this.backgroundColor,
    this.noTransitions = false,
    this.hasSpinner = false,
    required this.fullname,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return ImageType.getImageType(avatar) == ImageType.onlineLink
        ? CachedNetworkImage(
          imageUrl: avatar as String,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          fadeInDuration: Duration(milliseconds: noTransitions ? 0 : 500),
          errorWidget: (context, e, _) {
            return AIDefaultImage(
              width: width,
              height: height,
              hasSpinner: hasSpinner,
            );
          },
          placeholder:
              (ctx, _) => AIDefaultImage(
                width: width,
                height: height,
                hasSpinner: hasSpinner,
              ),
        )
        : Container(
          width: width,
          height: height,
          color:
              fullname.length > kAvatarColors.length
                  ? AIColors.pink
                  : kAvatarColors[fullname.length - 1],
          child: Align(
            alignment: Alignment.center,
            child: Text(
              fullname[0].toUpperCase(),
              style: TextStyle(
                fontSize: textSize ?? 14.0,
                color: AIColors.white,
              ),
            ),
          ),
        );
  }
}

enum ImageType {
  onlineLink,
  offlineSvg,
  offlineImage,
  binary,
  iconData,
  file,
  asset;

  static ImageType? getImageType(dynamic src) {
    if (src is String) {
      var data = src;
      if (data.isEmpty) return null;
      if (data.contains('http')) {
        return ImageType.onlineLink;
      } else {
        if (data.contains('.svg')) {
          return ImageType.offlineSvg;
        } else {
          return ImageType.offlineImage;
        }
      }
    }
    if (src is File) {
      return ImageType.file;
    }
    if (src is IconData) {
      return ImageType.iconData;
    }
    if ((src is List) || (src is Uint8List)) {
      return ImageType.binary;
    }
    return null;
  }
}
