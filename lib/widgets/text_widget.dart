import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';

class AITextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final int? maxLines;
  final bool obscureText;

  const AITextField({
    super.key,
    this.initialValue,
    this.height,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffix,
    this.suffixIcon,
    this.autofocus = false,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 44.0,
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        autofocus: autofocus,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          labelText: hintText,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(width: 0.33),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(width: 0.33, color: AIColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              width: 0.33,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onChanged: onChanged,
        onTapOutside: onTapOutside,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        maxLines: maxLines,
        obscureText: obscureText,
      ),
    );
  }
}

class AINoBorderTextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final double? height;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final String? suffixText;
  final bool autofocus;
  final bool readOnly;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final int? minLines;
  final int? maxLines;
  final bool obscureText;

  const AINoBorderTextField({
    super.key,
    this.initialValue,
    this.height,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.suffixText,
    this.autofocus = false,
    this.readOnly = false,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.minLines = 1,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48.0,
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        autofocus: autofocus,
        readOnly: readOnly,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          labelText: hintText,
          hintStyle: Theme.of(context).textTheme.labelLarge,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          suffix: suffix,
          border: InputBorder.none,
        ),
        onChanged: onChanged,
        onTapOutside: onTapOutside,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        minLines: minLines,
        maxLines: maxLines,
        obscureText: obscureText,
      ),
    );
  }
}
