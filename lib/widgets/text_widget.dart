import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:intl/intl.dart';

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
  final Color? borderColor;
  final Color? focusedColor;
  final Color? fillColor;

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
    this.borderColor = Colors.transparent,
    this.focusedColor = Colors.blueAccent,
    this.fillColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 44.0,
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        cursorColor: Colors.white,
        autofocus: autofocus,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
          // labelText: hintText,
          hintText: hintText,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(width: 0.66),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(width: 0.66, color: borderColor!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              width: 1,
              color: focusedColor!,
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
class AIPasswordField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final double? height;
  final Widget? prefixIcon;
  final bool autofocus;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const AIPasswordField({
    super.key,
    this.initialValue,
    this.height,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.autofocus = false,
    this.onChanged,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
  });

  @override
  State<AIPasswordField> createState() => _AIPasswordFieldState();
}

class _AIPasswordFieldState extends State<AIPasswordField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 44.0,
      child: TextFormField(
        initialValue: widget.initialValue,
        controller: widget.controller,
        autofocus: widget.autofocus,
        obscureText: _obscureText,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          labelText: widget.hintText,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          prefixIcon: widget.prefixIcon,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).textTheme.labelLarge?.color?.withOpacity(0.6),
              size: 20,
            ),
            onPressed: _toggleObscureText,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: const BorderSide(width: 0.66),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              width: 0.66,
              color: AIColors.borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(
              width: 0.66,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onChanged: widget.onChanged,
        onTapOutside: widget.onTapOutside,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        validator: widget.validator,
      ),
    );
  }
}


class AITextArea extends StatefulWidget {
  final int? minLines;
  final int? maxLines;
  final double? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final double? focusedBorderRadius;
  final Color? focusedBorderColor;
  final double? focusedBorderWidth;
  final String? hintText;
  final String? initialText;
  final Color? cursorColor;
  final Color? fillColor;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final TextEditingController controller;

  AITextArea({
    this.minLines = 3, 
    this.maxLines = 5, 
    this.borderRadius = 12.0, 
    this.borderColor = Colors.transparent, 
    this.borderWidth = 2.0, 
    this.focusedBorderRadius = 12.0,
    this.focusedBorderColor = Colors.blueAccent,
    this.focusedBorderWidth = 2.0,
    this.hintText = "",
    this.initialText = "",
    this.cursorColor = Colors.white,
    this.fillColor = const Color(0x20F5F5F5),
    this.onChanged,
    this.onEditingComplete,
    required this.controller,
  });

  @override
  AITextAreaState createState() => AITextAreaState();
}

class AITextAreaState extends State<AITextArea> {

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialText ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 5,
      minLines: 3,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          borderSide: BorderSide(color: widget.borderColor!, width: widget.borderWidth!)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.focusedBorderRadius!),
          borderSide: BorderSide(color: widget.focusedBorderColor!, width: widget.focusedBorderWidth!),
        ),
      ),
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final DateTime? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final double? height;
  final bool? autofocus;
  final Color? fillColor;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final VoidCallback? onTapOutside;

  const DatePickerWidget({
    super.key,
    this.initialValue,
    this.controller,
    this.helperText,
    this.hintText,
    this.prefixIcon,
    this.height = 44.0,
    this.autofocus = false,
    this.fillColor,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.onTapOutside,
  });

  @override
  State<DatePickerWidget> createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();

    // If an initial date value exists, set it and format it
    if (widget.initialValue != null) {
      _selectedDate = widget.initialValue;
      _controller.text = _formatDate(widget.initialValue!);
    }
  }

  Future<void> _selectDate(BuildContext ctx) async {
    final DateTime? picked = await showDatePicker(
      context: ctx,
      initialDate: _selectedDate ??
          DateTime.now(), // default 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)), // must be ≥ 13 years old
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.grey,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(picked);
      });

      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) return 'Please select your birthday';
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      final today = DateTime.now();
      final minAgeDate = DateTime(today.year - 13, today.month, today.day);

      if (date.isAfter(minAgeDate)) {
        return 'You must be at least 13 years old';
      }
    } catch (_) {
      return 'Invalid date format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TextFormField(
        controller: _controller,
        readOnly: true, // prevent manual typing
        autofocus: widget.autofocus ?? false,
        style: Theme.of(context).textTheme.bodyMedium,
        
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          labelText: widget.hintText ?? '',
          labelStyle: Theme.of(context).textTheme.labelLarge,
          prefixIcon: widget.prefixIcon ?? Icon(Icons.calendar_today, color: Colors.white),
          filled: true,
          fillColor: widget.fillColor ?? Colors.grey.shade900,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(width: 0.66),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(width: 0.66, color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(width: 0.9, color: Theme.of(context).primaryColor),
          ),
        ),
        validator: widget.validator ?? _validateDate,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        onTapOutside: (_) => widget.onTapOutside?.call(),
        onTap: () => _selectDate(context),
      ),
    );
  }
}
