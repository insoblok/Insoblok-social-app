import 'package:flutter/material.dart';
import 'package:insoblok/services/crypto_service.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/pages/pages.dart';

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
  int _currentStep = 0; // 0: Secret input, 1: Password input, 2: Confirmation

  @override
  void dispose() {
    _secretController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    logger.d("Width and height in import dialog is ${MediaQuery.of(context).size.width}, ${MediaQuery.of(context).size.height}");
    if (_currentStep == 0) {
      if (_validateSecret(_secretController.text) == null) {
        setState(() {
          _currentStep = 1;
          _errorMessage = null;
        });
      } else {
        _formKey.currentState?.validate();
      }
    } else if (_currentStep == 1) {
      if (_validatePassword(_passwordController.text) == null && 
          _validateConfirmPassword(_confirmPasswordController.text) == null) {
        setState(() {
          _currentStep = 2;
          _errorMessage = null;
        });
      } else {
        _formKey.currentState?.validate();
      }
    }
  }

  void _goToPreviousStep() {
    setState(() {
      _currentStep--;
      _errorMessage = null;
    });
  }

  Future<void> _importWallet(BuildContext ctx) async {
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
      if(_selectedMethod == ImportMethod.mnemonic) Navigator.pop(ctx, null);
      if (authUser?.walletAddress?.isEmpty ?? true) {
        Routers.goToRegisterFirstPage(
          ctx,
          user: UserModel(walletAddress: result.address),
        );
      } else {
        AuthHelper.updateStatus('Online');
        Routers.goToMainPage(ctx);
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
    logger.d("Input is $value");
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

  void _showSeedPhraseConfirmation(BuildContext context) {
    if (_validatePassword(_passwordController.text) == null && 
          _validateConfirmPassword(_confirmPasswordController.text) == null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SeedPhraseConfirmationDialog(
          originalSeedPhrase: _secretController.text.trim(),
          onConfirm: () {
            _importWallet(context);
          },
          onCancel: () {
            Navigator.pop(context); // Close confirmation dialog
            setState(() {
              _isLoading = false;
            });
          },
          showSeedPhrase: false,
        ),
      );
    }
    else {
        _formKey.currentState?.validate();
    }
    
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
        children: [
      // Title in the center (fills available space)
          Align(
            child: Center(
              child: Text(
                _currentStep == 0 ? 'Import Wallet' : 'Set Password',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Right button
          Positioned(
            right: -10,
            top: -10,
            child:_currentStep == 0 ? 
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[400]),
                onPressed: () => Navigator.of(context).pop(),
              ) :
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey[400]),
                onPressed: _goToPreviousStep,
              )
          )
        ],
      );
  }

  Widget _buildMethodSelector() {
    return Container(
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
            color: isSelected ? Colors.pink[600] : Colors.transparent,
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

  Widget _buildSecretInputStep() {
    return Column(
      children: [
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
        Text(
          _selectedMethod == ImportMethod.mnemonic
              ? 'Enter your 12 or 24 word recovery phrase'
              : 'Enter your private key (64 hex characters)',
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPasswordInputStep() {
    return Column(
      children: [
        Text(
          'Set a password to secure your wallet',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 60,
          child: AIPasswordField(
            controller: _passwordController,
            hintText: "Password",
            validator: _validatePassword,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 60,
          child: AIPasswordField(
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
            validator: _validateConfirmPassword,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
        const SizedBox(height: 8),
        
        SizedBox(
          height: 20,
          child: _buildPasswordValidationHint(),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Column(
      children: [
        const Icon(
          Icons.security,
          size: 64,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        
        Text(
          'Confirm Your Seed Phrase',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Please verify your seed phrase to ensure it was entered correctly',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 24),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800]!.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[600]!),
          ),
          child: Text(
            _secretController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          '⚠️ Make sure this matches your backup exactly!',
          style: TextStyle(
            color: Colors.orange[300],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
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
    );
  }


  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _currentStep == 0
              ? GradientPillButton(
                  text: "Continue",
                  onPressed: _goToNextStep,
                )
              : _currentStep == 1
                ? GradientPillButton(
                    text: "Import Wallet",
                    onPressed: () {
                      if (_selectedMethod == ImportMethod.mnemonic) {
                        _showSeedPhraseConfirmation(context);
                      } else {
                        _importWallet(context);
                      }
                    },
                    loading: _isLoading,
                    loadingText: "... importing",
                  )
                : GradientPillButton(
                    text: "Confirm & Import Wallet",
                    loading: _isLoading,
                    loadingText: "... Verifying",
                    onPressed: () {
                    }                  
                  ),
        ),
        SizedBox(height: 40.0)
      ],
    );
  }
  Widget _buildPasswordValidationHint() {
    final passwordError = _validatePassword(_passwordController.text);
    final confirmError = _validateConfirmPassword(_confirmPasswordController.text);
    
    if (passwordError != null) {
      return Text(
        passwordError,
        style: TextStyle(color: Colors.red[300], fontSize: 12),
      );
    } else if (confirmError != null && _confirmPasswordController.text.isNotEmpty) {
      return Text(
        confirmError,
        style: TextStyle(color: Colors.red[300], fontSize: 12),
      );
    } else {
      return Text(
        'Password must be at least 6 characters',
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Width and height in build function is ${MediaQuery.of(context).size.width}, ${MediaQuery.of(context).size.height}");

    return Dialog(
      backgroundColor: AIColors.modalBackground,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: Colors.white)
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 32.0),
                  _buildHeader(context),
                  const SizedBox(height: 64),

                  if (_currentStep == 0) ...[
                    _buildMethodSelector(),
                    const SizedBox(height: 48),
                  ],

                  Form(
                    key: _formKey,
                    child: _currentStep == 0
                        ? _buildSecretInputStep()
                        : _currentStep == 1
                          ? _buildPasswordInputStep()
                          : _buildConfirmationStep(),
                  ),

                  const SizedBox(height: 20),

                  if (_errorMessage != null) _buildErrorMessage(),

                  if (_errorMessage != null) const SizedBox(height: 16),

                  
                ],
              ),
              _buildActionButtons(),
            ],
          ),
      ),
    );
  }
}

enum ImportMethod { mnemonic, privateKey }