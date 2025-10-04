import 'package:flutter/material.dart';
import 'package:insoblok/services/services.dart';

class MultipleInputWidget extends StatefulWidget {
  final MultipleInputController? controller;
  final int maxItems;
  final VoidCallback? onItemsChanged; // Optional direct callback
  
  const MultipleInputWidget({
    super.key,
    this.controller,
    this.maxItems = 6,
    this.onItemsChanged,
  });

  @override
  State<MultipleInputWidget> createState() => _MultipleInputWidgetState();
}

class _MultipleInputWidgetState extends State<MultipleInputWidget> {
  late MultipleInputController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? MultipleInputController();
    _controller.onChanged = _handleControllerChange;
  }

  void _handleControllerChange() {
    setState(() {});
    // Also call the direct callback if provided
    widget.onItemsChanged?.call();
  }

  void _onReorder(int oldIndex, int newIndex) {
    // Delegate to controller - it will call onChanged automatically
    _controller.reorderItems(oldIndex, newIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade900
      ),
      child: SizedBox(
        height: 80,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _controller.items.length,
          // buildDefaultDragHandles: false,
          // onReorder: _onReorder,
          itemBuilder: (context, index) {
            final icon = _controller.items[index];
            return Container(
              // index: index,
              // key: ValueKey('$index-${icon ?? 'empty'}'),
              child: GestureDetector(
                onTap: () {
                  if (icon != null) {
                    // Remove item on tap - controller will notify
                    _controller.removeItemAt(index);
                  } else {
                    // Show dialog to add new item
                    _showAddIconDialog();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 60,
                  height: 60,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: icon == null ? Colors.grey.shade700 : Colors.transparent, width: 1.5),
                    color: Colors.transparent,
                  ),
                  child: icon != null
                      ? AIImage(icon, width: 28, height: 28)
                      : Container(child: Icon(Icons.add, color: Colors.white, size: 28)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddIconDialog() {
    // Show dialog to select icon
    // When icon is selected, call: _controller.addItem(selectedIconPath);
  }
}

class MultipleInputController {
  List<String?> _items = [];
  VoidCallback? _onChanged;

  // Set the callback
  set onChanged(VoidCallback? callback) {
    _onChanged = callback;
  }

  // Add item and notify
  void addItem(String icon) {
    if (_items.contains(icon) || icon.isEmpty) return;
    
    final firstEmptyIndex = _items.indexWhere((item) => item == null);
    if (firstEmptyIndex != -1) {
      _items[firstEmptyIndex] = icon;
      _notifyChanged();
    }
  }

  // Remove item and notify
  void removeItem(String icon) {
    final index = _items.indexWhere((item) => item == icon);
    if (index != -1) {
      _items[index] = null;
      _notifyChanged();
    }
  }

  // Remove item at index and notify
  void removeItemAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index] = null;
      _notifyChanged();
    }
  }

  // Clear all items and notify
  void clearItems() {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = null;
    }
    _notifyChanged();
  }

  // Reorder items and notify
  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    
    final String? item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    _notifyChanged();
  }

  // Initialize with items and notify
  void initializeItems(List<String> items, int maxItems) {
    _items.clear();
    _items.addAll(List<String?>.filled(maxItems, null));
    for (int i = 0; i < items.length && i < maxItems; i++) {
      _items[i] = items[i];
    }
    _notifyChanged();
  }

  // Get current items (read-only)
  List<String?> get items => List<String?>.from(_items);
  set items(List<String?> list) {
    _items = list;
    _notifyChanged();
  } 
  // Get non-null items only
  List<String> get nonNullItems => _items.whereType<String>().toList();

  // Check if there are any items
  bool get hasItems => _items.any((item) => item != null);

  // Get count of non-null items
  int get itemCount => _items.where((item) => item != null).length;

  // Private method to notify changes
  void _notifyChanged() {
    _onChanged?.call();
  }

  // Dispose the controller
  void dispose() {
    _onChanged = null;
  }
}