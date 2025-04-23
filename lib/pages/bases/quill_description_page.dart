import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';

class QuillDescriptionPage extends StatelessWidget {
  final String? originQuill;

  const QuillDescriptionPage({super.key, this.originQuill});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuillDescriptionProvider>.reactive(
      viewModelBuilder: () => QuillDescriptionProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, originQuill: originQuill),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Feed Description'),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: viewModel.onClickSave,
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                QuillSimpleToolbar(
                  controller: viewModel.quillController,
                  config: QuillSimpleToolbarConfig(
                    showDividers: false,
                    showFontFamily: false,
                    showFontSize: false,
                    showColorButton: false,
                    showBackgroundColorButton: false,
                    showHeaderStyle: false,
                    showCodeBlock: false,
                    showInlineCode: false,
                    showIndent: false,
                    showSearchButton: false,
                    showUndo: false,
                    showRedo: false,
                    showQuote: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showListCheck: false,
                    showClearFormat: false,
                  ),
                ),
                Expanded(
                  child: QuillEditor(
                    focusNode: viewModel.focusNode,
                    scrollController: viewModel.scrollController,
                    controller: viewModel.quillController,
                    config: QuillEditorConfig(
                      placeholder: 'Start writing your notes...',
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
