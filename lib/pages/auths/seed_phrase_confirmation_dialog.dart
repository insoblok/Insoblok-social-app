import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';


class SeedPhraseConfirmationDialog extends StatefulWidget {
  final String originalSeedPhrase;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool showSeedPhrase;

  const SeedPhraseConfirmationDialog({
    super.key,
    required this.originalSeedPhrase,
    required this.onConfirm,
    required this.onCancel,
    required this.showSeedPhrase
  });

  @override
  State<SeedPhraseConfirmationDialog> createState() => SeedPhraseConfirmationDialogState();
}

class SeedPhraseConfirmationDialogState extends State<SeedPhraseConfirmationDialog> {
  final TextEditingController _confirmationController = TextEditingController();
  final FocusNode _confirmationFocusNode = FocusNode();
  String? _errorMessage;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
  }

  bool get _isConfirmed {
    final enteredPhrase = _confirmationController.text.trim();
    final originalPhrase = widget.originalSeedPhrase.trim();
    return enteredPhrase.toLowerCase() == originalPhrase.toLowerCase();
  }

  void _checkConfirmation() {
    setState(() {
      _isChecking = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_isConfirmed) {
        widget.onConfirm();
      } else {
        setState(() {
          _errorMessage = 'Seed phrases do not match. Please try again.';
          _isChecking = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    _confirmationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: AIColors.modalBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[400]),
                    onPressed: () {},
                  ),
                ),
                Text(
                  'Confirm Seed Phrase',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[400]),
                  onPressed: widget.onCancel,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            Text(
              widget.showSeedPhrase ? "Please store your seed phrase safely." : 'Please re-enter your seed phrase to confirm you have it correctly',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              widget.showSeedPhrase ? "" : 'This ensures you have properly backed up your recovery phrase',
              style: TextStyle(
                color: Colors.orange[300],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Seed Phrase Input
            widget.showSeedPhrase == true ? 
              Text("") :
              TextFormField(
                controller: _confirmationController,
                focusNode: _confirmationFocusNode,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  labelText: 'Re-enter Seed Phrase',
                  labelStyle: Theme.of(context).textTheme.labelLarge,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(width: 0.33),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(width: 0.33, color: AIColors.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      width: 0.33,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  suffixIcon: _confirmationController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                          onPressed: () {
                            _confirmationController.clear();
                            setState(() {
                              _errorMessage = null;
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = null;
                  });
                },
              ),
              
            const SizedBox(height: 16),
            
            // Word count indicator
            
            const SizedBox(height: 8),
            
            // Error message
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[900]!.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[200], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[200], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (_errorMessage != null) const SizedBox(height: 16),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: BorderSide(color: Colors.grey[600]!),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmationController.text.isNotEmpty && !_isChecking
                        ? () {
                          _checkConfirmation();
                        }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isConfirmed 
                          ? Colors.green 
                          : Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: _isChecking
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Help text
            Text(
              'Make sure the seed phrase matches exactly',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

