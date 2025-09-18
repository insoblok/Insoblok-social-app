import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
/// A reusable widget for confirming a seed phrase.
/// 
/// Example:
/// ```dart
/// SeedConfirmWidget(
///   seedWords: seedWords, // List<String>
///   onConfirmed: () {
///     // Go to success page or next step
///   },
/// )
/// ```
class SeedPhraseConfirmationWidget extends StatefulWidget {
  final List<String> seedWords;
  final VoidCallback onConfirmed;

  const SeedPhraseConfirmationWidget({
    Key? key,
    required this.seedWords,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  State<SeedPhraseConfirmationWidget> createState() => SeedPhraseConfirmationWidgetState();
}

class SeedPhraseConfirmationWidgetState extends State<SeedPhraseConfirmationWidget> {
  late final List<_WordItem> _shuffled;

  @override
  void initState() {
    super.initState();
    _prepareShuffled();
  }

  void _prepareShuffled() {
    _shuffled = List<_WordItem>.generate(
      widget.seedWords.length,
      (i) => _WordItem(word: widget.seedWords[i], originalIndex: i),
    );
    _shuffleList(_shuffled);
  }

  void _shuffleList(List list) {
    final rnd = Random.secure();
    for (var i = list.length - 1; i > 0; i--) {
      final j = rnd.nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final wordCount = widget.seedWords.length;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AIColors.modalBackground
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            Container(
              child: Center(
                child: Text(
                  'Confirm your seed phrase',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 36),
        
            
            // Selected words
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material( // 👈 Add this
                color: Colors.transparent, // keep your container bg
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(wordCount, (i) {
                    final chipWidth = (MediaQuery.of(context).size.width - 48) / 3;
                    if (i < widget.seedWords.length) {
                      final item = widget.seedWords[i];
                      return SizedBox(
                        width: chipWidth,
                        child: GestureDetector(
                          onTap: () {},
                          child: Chip(
                            label: Text('${i + 1}. $item'),
                            backgroundColor: Colors.green.shade50,
                          ),
                        ),
                      );
                    } else {
                      return const Chip(label: Text('—'));
                    }
                  }),
                ),
              ),
            ),

        
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Copy Seed Phrase",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.seedWords.join(" ")));
                      AIHelpers.showToast(msg: "Copied Seed Phrase to Clipboard");
                    },
                    tooltip: "Copy to clipboard",
                  ),
                ],
              ),
            ),
        
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: GradientPillButton(
                  text: "Next",
                  onPressed: widget.onConfirmed
                ),
              )
            )            
          ],
        ),
      )
    );
  }
}

class _WordItem {
  final String word;
  final int originalIndex;
  _WordItem({required this.word, required this.originalIndex});
}

/// helper to compare lists
class ListEquality {
  bool equals(List a, List b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
