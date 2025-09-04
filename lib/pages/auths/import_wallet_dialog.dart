import 'package:flutter/material.dart';
import 'package:insoblok/services/crypto_service.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/widgets/text_widget.dart';

class ImportWalletDialog extends StatefulWidget {
  final CryptoService cryptoService;

  const ImportWalletDialog({super.key, required this.cryptoService});

  @override
  State<ImportWalletDialog> createState() => _ImportWalletDialogState();
}

class _ImportWalletDialogState extends State<ImportWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _secretController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  ImportMethod _selectedMethod = ImportMethod.mnemonic;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _secretController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _importWallet(BuildContext ctx) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final secret = _secretController.text.trim();
      final password = _passwordController.text;

      NewWalletResult result;
      
      if (_selectedMethod == ImportMethod.mnemonic) {
        result = await widget.cryptoService.importFromMnemonic(
          secret, 
          password,
          returnMnemonic: false,
        );
      } else {
        result = await widget.cryptoService.importFromPrivateKey(secret, password);
      }
      var authUser = await AuthHelper.signIn(
        result.address,
        true,
      );

      logger.d("authUser : $authUser");
      Navigator.pop(ctx, null);
      if (authUser?.walletAddress?.isEmpty ?? true) {
        Routers.goToRegisterFirstPage(
          context,
          user: UserModel(walletAddress: result.address),
        );
      } else {
        AuthHelper.updateStatus('Online');
        Routers.goToMainPage(context);
      }
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String? _validateSecret(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your ${_selectedMethod == ImportMethod.mnemonic ? 'mnemonic phrase' : 'private key'}';
    }

    if (_selectedMethod == ImportMethod.mnemonic) {
      final words = value.trim().split(RegExp(r'\s+'));
      if (words.length != 12 && words.length != 24) {
        return 'Mnemonic must be 12 or 24 words';
      }
      if (!widget.cryptoService.validateMnemonic(value)) {
        return 'Invalid mnemonic phrase';
      }
    } else {
      try {
        widget.cryptoService.normalizePrivateKey(value);
      } catch (e) {
        return 'Invalid private key format';
      }
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AIColors.modalBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Import Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[400]),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Import Method Selector
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildMethodButton(ImportMethod.mnemonic, 'Mnemonic'),
                    _buildMethodButton(ImportMethod.privateKey, 'Private Key'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Secret Input
                    TextFormField(
                      controller: _secretController,
                      maxLines: _selectedMethod == ImportMethod.mnemonic ? 3 : 1,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        labelText: _selectedMethod == ImportMethod.mnemonic 
                            ? 'Recovery Phrase (12 or 24 words)' 
                            : 'Private Key',
                        labelStyle: Theme.of(context).textTheme.labelLarge,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(width: 0.33),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(width: 0.33, color: AIColors.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(
                            width: 0.33,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      validator: _validateSecret,
                    ),

                    const SizedBox(height: 16),

                    // Password Input
                    AIPasswordField(
                      controller: _passwordController,
                      hintText: "Password",
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password Input
                    AIPasswordField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm Password",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Error Message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[900]!.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red[200]),
                  ),
                ),

              if (_errorMessage != null) const SizedBox(height: 16),

              // Import Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _importWallet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.blue[800],
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Import Wallet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 8),

              // Help Text
              Text(
                _selectedMethod == ImportMethod.mnemonic
                    ? 'Enter your 12 or 24 word recovery phrase'
                    : 'Enter your private key (64 hex characters)',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodButton(ImportMethod method, String text) {
    final isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = method;
            _secretController.clear();
            _errorMessage = null;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[600] : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

enum ImportMethod { mnemonic, privateKey }