import 'package:flutter/material.dart';

class NumberPlateController extends ChangeNotifier {
  String _value = '';

  String get value => _value;

  set value(String newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  void clear() {
    value = '';
  }
}

class NumberPlateWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final int maxLength;
  final NumberPlateController? controller;

  const NumberPlateWidget({
    super.key,
    this.onChanged,
    this.maxLength = 20,
    this.controller,
  });

  @override
  State<NumberPlateWidget> createState() => _NumberPlateWidgetState();
}

class _NumberPlateWidgetState extends State<NumberPlateWidget> {
  late NumberPlateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? NumberPlateController();
    _controller.addListener(_onExternalChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onExternalChange);
    if (widget.controller == null) {
      // Only dispose if we created it internally
      _controller.dispose();
    }
    super.dispose();
  }

  void _onExternalChange() {
    if (mounted) setState(() {});
  }

  void _onKeyPressed(String key) {
    if (key == 'back') {
      if (_controller.value.isNotEmpty) {
        _controller.value = _controller.value.substring(0, _controller.value.length - 1);
      }
    } else {
      if (_controller.value.length < widget.maxLength) {
        _controller.value = _controller.value + key;
      }
    }

    widget.onChanged?.call(_controller.value);
  }

  @override
  Widget build(BuildContext context) {
    final keys = <Widget>[
      for (var i = 1; i <= 9; i++)
        _NumericKey(label: '$i', onTap: () => _onKeyPressed('$i')),
      _NumericKey(label: '.', onTap: () => _onKeyPressed('.')),
      _NumericKey(label: '0', onTap: () => _onKeyPressed('0')),
      _NumericKey.icon(
        icon: Icons.backspace_outlined,
        semanticLabel: 'Backspace',
        onTap: () => _onKeyPressed('back'),
        onLongPress: () {
          _controller.clear();
          widget.onChanged?.call(_controller.value);
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Display area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            _controller.value.isEmpty ? ' ' : _controller.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Numeric grid
        AspectRatio(
          aspectRatio: 3 / 3,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2 / 1,
            children: keys,
          ),
        ),
      ],
    );
  }
}

class _NumericKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String? semanticLabel;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _NumericKey({
    this.label,
    this.icon,
    this.semanticLabel,
    required this.onTap,
    this.onLongPress,
  });

  factory _NumericKey.icon({
    required IconData icon,
    String? semanticLabel,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) =>
      _NumericKey(
        icon: icon,
        semanticLabel: semanticLabel,
        onTap: onTap,
        onLongPress: onLongPress,
      );

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey.shade400,
      fontWeight: FontWeight.w500,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 22, color: Colors.grey.shade400, semanticLabel: semanticLabel)
              : Text(label!, style: textStyle),
        ),
      ),
    );
  }
}
