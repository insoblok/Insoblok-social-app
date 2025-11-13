import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gif_view/gif_view.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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
            logger.e(error);
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
      case ImageType.gif:
        if ((src as String).contains('http')) {
          return GifView.network(
            src,
            width: width,
            height: height,
            fit: fit ?? BoxFit.none,
            color: color,
          );
        }
        if (src is File) {
          return GifView.memory(
            (src as File).readAsBytesSync(),
            width: width,
            height: height,
            fit: fit ?? BoxFit.none,
            color: color,
          );
        }
        return GifView.asset(
          src,
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
        colors: [color ?? Theme.of(context).primaryColor],
        strokeWidth: 2,
      ),
    );
  }
}

class AIAvatarDefaultView extends StatelessWidget {
  final String fullname;
  final double? textSize;
  final double? width;
  final double? height;
  final double? borderWidth;
  final double? borderRadius;
  final bool? borderGradient;
  final bool? isBorder;

  const AIAvatarDefaultView({
    super.key,
    required this.fullname,
    this.textSize,
    this.width,
    this.height,
    this.borderWidth,
    this.borderRadius,
    this.borderGradient,
    this.isBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 60,
      height: height ?? 60,
      decoration:
          (isBorder ?? false)
              ? BoxDecoration(
                border:
                    borderGradient != null && borderGradient == true
                        ? GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: getGradientColors(fullname.length),
                          ),
                          width: borderWidth ?? 2,
                        )
                        : null,
                borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
              )
              : BoxDecoration(),

      child: ClipOval(
        child: Container(
          color: kAvatarColors[(fullname.trim().length) % 8],
          child: Align(
            alignment: Alignment.center,
            child: Text(
              fullname.trim()[0].toUpperCase(),
              style: TextStyle(
                fontSize: textSize ?? 14.0,
                color: AIColors.white,
              ),
            ),
          ),
        ),
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
  final double? borderWidth;
  final double? borderRadius;
  final bool? borderGradient;
  final bool noCache;
  final Color? backgroundColor;
  final bool noTransitions;
  final bool hasSpinner;
  final bool isBorder;

  const AIAvatarImage(
    this.avatar, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.borderWidth,
    this.borderRadius,
    this.noCache = false,
    this.borderGradient = true,
    this.backgroundColor,
    this.noTransitions = false,
    this.hasSpinner = false,
    required this.fullname,
    this.textSize,
    this.isBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return ImageType.getImageType(avatar) == ImageType.onlineLink
        ? Container(
          width: width ?? 60,
          height: height ?? 60,
          decoration:
              isBorder
                  ? BoxDecoration(
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: getGradientColors(fullname.length),
                      ),
                      width: borderWidth ?? 2,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
                  )
                  : BoxDecoration(),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: avatar as String,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              fadeInDuration: Duration(milliseconds: noTransitions ? 0 : 500),
              errorWidget: (context, e, _) {
                return AIAvatarDefaultView(
                  fullname: fullname,
                  textSize: textSize,
                  width: width,
                  height: height,
                  borderWidth: borderWidth,
                  borderRadius: borderRadius,
                );
              },
              placeholder:
                  (ctx, _) => AIAvatarDefaultView(
                    fullname: fullname,
                    textSize: textSize,
                    width: width,
                    height: height,
                    borderWidth: borderWidth,
                    borderRadius: borderRadius,
                  ),
            ),
          ),
        )
        : AIAvatarDefaultView(
          fullname: fullname,
          textSize: textSize,
          width: width,
          height: height,
          borderWidth: borderWidth,
          borderRadius: borderRadius,
          borderGradient: borderGradient,
          isBorder: isBorder,
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
  gif,
  asset;

  static ImageType? getImageType(dynamic src) {
    if (src is String) {
      var data = src;
      if (data.isEmpty) return null;
      if (data.contains('.gif')) return ImageType.gif;
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
