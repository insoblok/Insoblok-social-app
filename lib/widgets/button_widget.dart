import 'package:flutter/material.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class OutlineButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isBusy;
  final void Function()? onTap;

  const OutlineButton({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderColor,
    this.backgroundColor,
    this.onTap,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 52.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            width: 2.0,
            color: borderColor ?? AIColors.borderColor,
          ),
        ),
        alignment: Alignment.center,
        child:
            isBusy
                ? Center(child: Loader(color: borderColor, size: 28.0))
                : child,
      ),
    );
  }
}

class TextFillButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool isBusy;
  final void Function()? onTap;

  const TextFillButton({
    super.key,
    required this.text,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.isBusy = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 48.0,
        decoration: BoxDecoration(
          color: color ?? AIColors.borderColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.center,
        child:
            isBusy
                ? Center(child: Loader(color: Colors.white, size: 28.0))
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize ?? 16.0,
                    fontWeight: fontWeight ?? FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}

class PageableIndicator extends StatelessWidget {
  final int pageLength;
  final int? index;

  const PageableIndicator({
    super.key,
    required this.pageLength,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < pageLength; i++) ...{
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: i == index ? AIColors.white : null,
              border: Border.all(
                color: i == index ? Colors.transparent : AIColors.white,
              ),
              shape: BoxShape.circle,
            ),
          ),
        },
      ],
    );
  }
}

class MenuButtonCover extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const MenuButtonCover({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  final dynamic src;
  final void Function()? onTap;

  const CustomFloatingButton({super.key, required this.src, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 56.0,
        height: 56.0,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
          right: 24.0,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AIColors.pink,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: AIImage(src, width: 22.0, height: 22.0),
      ),
    );
  }
}

class CustomCircleBackButton extends StatelessWidget {
  const CustomCircleBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 36.0,
        height: 36.0,
        margin: EdgeInsets.only(
          left: 20.0,
          top: MediaQuery.of(context).padding.top + 12.0,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withAlpha(128),
        ),
        child: Icon(Icons.arrow_back, size: 18.0),
      ),
    );
  }
}

class CircleImageButton extends StatelessWidget {
  final dynamic src;
  final double? size;
  final void Function()? onTap;

  const CircleImageButton({
    super.key,
    required this.src,
    this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size ?? 36.0,
        height: size ?? 36.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(128),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AIImage(src, width: 20.0, height: 20.0),
      ),
    );
  }
}

class VoteFloatingButton extends StatefulWidget {
  final dynamic src;
  final void Function()? onTap;
  final double? imgSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final String text;
  final double? textSize;
  final Color? textColor;
  final double? horizontal;
  final double? vertical;

  const VoteFloatingButton({
    super.key,
    required this.src,
    this.onTap,
    this.imgSize,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    required this.text,
    this.textSize,
    this.textColor,
    this.horizontal,
    this.vertical,
  });

  @override
  State<VoteFloatingButton> createState() => _VoteFloatingButton();
}

class _VoteFloatingButton extends State<VoteFloatingButton>
    with SingleTickerProviderStateMixin {
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
  }

  void onTapDown(TapDownDetails details) {
    setState(() {
      scale = 0.9;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(scale),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 24.0),
            border: Border.all(
              color: widget.borderColor ?? Theme.of(context).primaryColor,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AIImage(
                widget.src,
                width: widget.imgSize ?? 32,
                height: widget.imgSize ?? 32,
                // color: widget.textColor ?? AIColors.white,
              ),
              const SizedBox(width: 16),
              Text(
                widget.text,
                style: TextStyle(
                  fontSize: widget.textSize ?? 16.0,
                  color: widget.textColor ?? AIColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubTabButton extends StatelessWidget {
  final void Function()? onTap;
  final bool selected;
  final String title;

  const SubTabButton({
    super.key,
    required this.selected,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 36.0,
        width: 112.0,
        decoration: BoxDecoration(
          color:
              selected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary.withAlpha(16),
          borderRadius: BorderRadius.circular(18.0),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color:
                selected
                    ? AIColors.white
                    : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

class GradientPillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double radius;

  /// When true, shows a spinner and disables taps.
  final bool loading;

  /// Optional label while loading (defaults to [text]).
  final String? loadingText;

  const GradientPillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 48,
    this.radius = 10,
    this.loading = false,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFF30C6C), // pink
        Color(0xFFC739EB), // purple
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: height),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: loading ? null : onPressed,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: loading
                    ? Row(
                        key: const ValueKey('loading'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.white24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            loadingText ?? text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        text,
                        key: const ValueKey('idle'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class AIBlueGradientButton extends StatelessWidget {
  final bool? showBoxShadow;
  final String text;
  final IconData? icon;
  final bool? showIcon;
  final VoidCallback onPressed;
  const AIBlueGradientButton({super.key, this.showBoxShadow = true, required this.text, this.icon, this.showIcon = true, required this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3CFF), // Deep blue
            Color(0xFF00FFA3), // Greenish gradient
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          showBoxShadow! ? BoxShadow(
            color: const Color(0xFF00FFA3).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ) : BoxShadow()
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            if (showIcon ?? false) ... {
              SizedBox(width: 3.0),
              Icon(Icons.navigate_next, color: Colors.white),
            }
          ],
        ),
      ),
    );
  }
}
