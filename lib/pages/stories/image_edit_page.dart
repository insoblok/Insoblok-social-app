// Dart imports:
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import 'package:insoblok/utils/utils.dart';

/// A widget that provides a default example of a stateful widget.
///
/// The [DefaultExample] widget is a simple stateful widget that serves as
/// a basic example or template for creating a new widget with state management.
/// It can be used as a starting point when building more complex widgets.
///
/// The state for this widget is managed by the [_DefaultExampleState] class.
///
/// Example usage:
/// ```dart
/// DefaultExample();
/// ```
class ImageEditorPage extends StatefulWidget {
  /// Creates a new [DefaultExample] widget.
  final String path;
  const ImageEditorPage({super.key, required this.path});

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

/// The state for the [DefaultExample] widget.
///
/// This class manages the behavior and state of the [DefaultExample] widget.
class _ImageEditorPageState extends State<ImageEditorPage>
    with ExampleHelperState<ImageEditorPage> {
  late final _configs = ProImageEditorConfigs(
    designMode: platformDesignMode,
  );
  late final _callbacks = ProImageEditorCallbacks(
    onImageEditingStarted: onImageEditingStarted,
    onImageEditingComplete: onImageEditingComplete,
    onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
    mainEditorCallbacks: MainEditorCallbacks(
      helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
    ),
  );


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
        
      ),
      body: ProImageEditor.file(
        File(widget.path),
        callbacks: _callbacks,
        configs: _configs,
      )
    );
  }

}