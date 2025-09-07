import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class FaceDetailPage extends StatelessWidget {
  final String storyID;
  final String url; // background image URL for blur backdrop
  final File face;  // original face image as File
  final List<AIFaceAnnotation> annotations;
  final bool editable;

  const FaceDetailPage({
    super.key,
    required this.storyID,
    required this.url,
    required this.face,
    required this.annotations,
    required this.editable,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaceDetailProvider>.reactive(
      viewModelBuilder: () => FaceDetailProvider(),
      onViewModelReady: (vm) => vm.init(
        context,
        storyID: storyID,
        url: url,
        face: face,
        annotations: annotations,
        editable: editable,
      ),
      builder: (context, vm, _) {
        return Scaffold(
          body: Stack(
            children: [
              // Background (story image)
              AIImage(vm.url, width: double.infinity, height: double.infinity),

              // Foreground blur + main content
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: vm.hypeFace != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Current face preview (original or edited)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.0),
                                child: AIImage(
                                  vm.hypeFace, // supports File or String in your project
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width * 0.7,
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Actions (includes "Edit")
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary
                                    .withAlpha(32),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (editable)
                                    _ActionItem(
                                      icon: Icons.edit,
                                      title: 'Edit',
                                      onTap: () => _openImageEditor(context, vm),
                                    ),
                                  const SizedBox(width: 32),

                                  // your existing actions
                                  for (final data in kReactionPostIconData) ...[
                                    InkWell(
                                      onTap: () => vm.onClickActionButton(
                                        kReactionPostIconData.indexOf(data),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AIImage(
                                            data['icon'],
                                            height: 24.0,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            data['title'] as String,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.headlineSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (data != kReactionPostIconData.last)
                                      const SizedBox(width: 32),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black26,
                        child: const Center(child: Loader(size: 60)),
                      ),
              ),

              const CustomCircleBackButton(),

              if (vm.isBusy) const Center(child: Loader(size: 60)),
            ],
          ),
        );
      },
    );
  }

  /// Open the editor with the current face (edited if available; else original).
  /// When user taps "Done", bytes are returned; we save to a temp file and
  /// update the VM so the edited image is shown.
  Future<void> _openImageEditor(BuildContext context, FaceDetailProvider vm) async {
    final dynamic current = vm.hypeFace ?? face;

    Uint8List? editedBytes;
    if (current is File) {
      editedBytes = await _openEditorFromFile(context, current);
    } else if (current is String && current.startsWith('http')) {
      editedBytes = await _openEditorFromNetwork(context, current);
    } else {
      editedBytes = await _openEditorFromFile(context, face);
    }

    if (editedBytes == null) return; // user closed without exporting

    final editedFile = await _saveBytesToTempFile(
      editedBytes,
      'edited_face_${DateTime.now().millisecondsSinceEpoch}.png',
    );

    logger.d("editedFile: ${editedFile.path}");
    
    vm.setHypeFaceFile(editedFile); // <-- replaces preview with edited image
  }

  Future<Uint8List?> _openEditorFromFile(BuildContext ctx, File file) {
    return Navigator.of(ctx).push<Uint8List>(
      MaterialPageRoute(
        builder: (innerCtx) => ProImageEditor.file(
          file, // required positional argument
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              // Done ✔️ -> return bytes & pop editor
              Navigator.of(innerCtx).pop(bytes);
            },
            // onCloseEditor: (mode) async {
            //   // X (close) -> just pop editor without data
            //   Navigator.of(innerCtx).pop(null);
            // },
          ),
        ),
      ),
    );
  }

  Future<Uint8List?> _openEditorFromNetwork(BuildContext ctx, String imageUrl) {
    return Navigator.of(ctx).push<Uint8List>(
      MaterialPageRoute(
        builder: (innerCtx) => ProImageEditor.network(
          imageUrl, // required positional argument
          callbacks: ProImageEditorCallbacks(
            onImageEditingComplete: (Uint8List bytes) async {
              Navigator.of(innerCtx).pop(bytes);
            },
            // onCloseEditor: (mode) async {
            //   Navigator.of(innerCtx).pop(null);
            // },
          ),
        ),
      ),
    );
  }

  Future<File> _saveBytesToTempFile(Uint8List bytes, String name) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

/// Small action item widget
class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24.0, color: Theme.of(context).primaryColor),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}

/// Helper extension to update the VM with a File (ensure your AIImage supports File)
extension FaceDetailProviderEditing on FaceDetailProvider {
  void setHypeFaceFile(File file) {
    hypeFace = file;
    notifyListeners();
  }
}
