import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vs_story_designer/vs_story_designer.dart';

/// Image editor page using VSStoryDesigner package
class ImageEditorDesignerPage extends StatefulWidget {
  final String path;
  const ImageEditorDesignerPage({super.key, required this.path});

  @override
  State<ImageEditorDesignerPage> createState() =>
      _ImageEditorDesignerPageState();
}

class _ImageEditorDesignerPageState extends State<ImageEditorDesignerPage> {
  bool _isValid = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _validateFile();
  }

  Future<void> _validateFile() async {
    try {
      final file = File(widget.path);

      // Wait for file to be ready (exists, non-zero, and size stabilizes)
      final ready = await _waitForFileReady(
        widget.path,
        timeout: const Duration(seconds: 2),
      );

      if (!ready) {
        setState(() {
          _isValid = false;
          _errorMessage = 'Image file is not ready. Please try again.';
        });
        return;
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        setState(() {
          _isValid = false;
          _errorMessage = 'Image file is empty';
        });
        return;
      }

      // Small delay to ensure file is fully written
      await Future.delayed(const Duration(milliseconds: 200));

      setState(() {
        _isValid = true;
      });
    } catch (e) {
      setState(() {
        _isValid = false;
        _errorMessage = 'Error validating file: $e';
      });
    }
  }

  /// Waits until a local file exists, is non-zero, and its size stabilizes.
  Future<bool> _waitForFileReady(
    String path, {
    required Duration timeout,
  }) async {
    final deadline = DateTime.now().add(timeout);
    int? lastSize;

    while (DateTime.now().isBefore(deadline)) {
      try {
        final file = File(path);
        if (await file.exists()) {
          final len = await file.length();
          if (len > 0) {
            if (lastSize != null && lastSize == len) {
              return true; // stable size
            }
            lastSize = len;
          }
        }
      } catch (_) {
        // ignore; retry
      }
      await Future.delayed(const Duration(milliseconds: 150));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValid) {
      return Scaffold(
        appBar: AppBar(title: const Text('Image Editor')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Invalid image file',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Ensure the path is absolute and properly formatted
    final file = File(widget.path);
    final mediaPath = file.absolute.path;

    return VSStoryDesigner(
      centerText: "Start Creating Your Story",
      themeType: ThemeType.light,
      galleryThumbnailQuality: 250,
      onDone: (uri) {
        // Return the edited image path back to the caller
        if (mounted) {
          Navigator.of(context).pop(uri);
        }
      },
      mediaPath: mediaPath,
    );
  }
}
