import 'package:flutter/material.dart';
import 'package:insoblok/services/image_service.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class VerticalReactionToggle extends StatelessWidget {
  final bool isVideoSelected;
  final bool showFaceDialog;
  final ValueChanged<bool> onChanged;

  const VerticalReactionToggle({
    super.key,
    required this.isVideoSelected,
    this.showFaceDialog = false,
    required this.onChanged,
  });

  static const LinearGradient _gradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF30C6C), Color(0xFFC739EB)], // pink → purple
  );

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ReactionSegment(
            label: 'V',
            selected: isVideoSelected,
            gradient: _gradient,
            borderRadius: borderRadius,
            onTap: () => onChanged(true),
          ),
          const SizedBox(height: 8),
          _ReactionSegment(
            label: 'I', 
            selected: !isVideoSelected,
            gradient: _gradient,
            borderRadius: borderRadius,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ReactionSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  const _ReactionSegment({
    required this.label,
    required this.selected,
    required this.gradient,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // If you used kStoryAvatarSize elsewhere, it should already be in scope via your utils.

    final decoration = BoxDecoration(
      borderRadius: borderRadius,
      gradient: selected ? gradient : null,
      color: selected ? null : Colors.transparent,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Ink(
          decoration: decoration,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  
                  color: selected
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
