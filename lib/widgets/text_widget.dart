import 'package:flutter/material.dart';

class AITextField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;

  const AITextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onChanged: onChanged,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
    );
  }
}
