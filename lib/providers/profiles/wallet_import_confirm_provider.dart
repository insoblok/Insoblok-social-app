import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insoblok/providers/profiles/account_wallet_provider.dart';
import 'dart:convert';

class WalletImportConfirmProvider extends InSoBlokViewModel {
  List<Map<String, dynamic>> _tokensToImport = [];
  List<Map<String, dynamic>> get tokensToImport => _tokensToImport;

  static const String _customTokensKey = 'custom_imported_tokens';

  Future<void> init(List<Map<String, dynamic>> tokens) async {
    _tokensToImport = tokens;
    notifyListeners();
  }

  Future<void> _saveCustomTokens(
    List<Map<String, dynamic>> customTokens,
  ) async {
    if (customTokens.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final existingTokens = await getCustomTokens();

    // Merge with existing tokens (avoid duplicates)
    final tokenMap = <String, Map<String, dynamic>>{};

    // Load existing tokens
    for (var token in existingTokens) {
      final key = _getTokenKey(token);
      tokenMap[key] = token;
    }

    // Add new tokens
    for (var token in customTokens) {
      final key = _getTokenKey(token);
      tokenMap[key] = token;
    }

    // Save back to SharedPreferences
    final tokensList = tokenMap.values.toList();
    final jsonString = jsonEncode(tokensList);
    await prefs.setString(_customTokensKey, jsonString);
  }

  static String _getTokenKey(Map<String, dynamic> token) {
    if (token.containsKey("token_address") &&
        token["token_address"] != null &&
        token["token_address"].toString().isNotEmpty) {
      return "${token["chain"]}:${token["token_address"]}";
    }
    return "${token["chain"]}:${token["short_name"]}";
  }

  static Future<List<Map<String, dynamic>>> getCustomTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_customTokensKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      logger.e('Error loading custom tokens: $e');
    }
    return [];
  }

  Future<void> handleImport(BuildContext context) async {
    if (isBusy) return;

    setBusy(true);

    try {
      final user = AuthHelper.user;
      if (user == null) {
        AIHelpers.showToast(msg: 'User not logged in');
        return;
      }

      // Get current favorite tokens
      var favoriteTokens = (user.favoriteTokens ?? []).toList();

      // Separate custom tokens and regular tokens
      List<Map<String, dynamic>> customTokens = [];

      // Add tokens to favorites
      for (var token in _tokensToImport) {
        String tokenId;

        if (token.containsKey("token_address") &&
            token["token_address"] != null &&
            token["token_address"].toString().isNotEmpty) {
          // Custom token - use format: "custom:chain:address"
          tokenId = "custom:${token["chain"]}:${token["token_address"]}";
          customTokens.add(token); // Store full custom token data
        } else if (token.containsKey("coingecko_id") &&
            token["coingecko_id"] != null &&
            token["coingecko_id"].toString().isNotEmpty) {
          // Regular token with CoinGecko ID
          tokenId = token["coingecko_id"].toString();
        } else {
          // Fallback: use symbol and chain as identifier
          tokenId = "${token["chain"]}:${token["short_name"]}";
        }

        // Only add if not already in favorites
        if (!favoriteTokens.contains(tokenId)) {
          favoriteTokens.add(tokenId);
        }
      }

      // Save custom tokens to SharedPreferences
      if (customTokens.isNotEmpty) {
        await _saveCustomTokens(customTokens);
      }

      // Update user with new favorite tokens
      UserModel updatedUser = user.copyWith(favoriteTokens: favoriteTokens);
      await AuthHelper.updateUser(updatedUser);

      // Refresh the AccountWalletProvider to reload imported tokens
      final accountWalletProvider = AccountWalletProvider.instance;
      if (accountWalletProvider != null) {
        await accountWalletProvider.refreshImportedTokens();
      }

      // Show success message
      if (context.mounted) {
        AIHelpers.showToast(msg: 'Tokens imported successfully');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      logger.e('Error importing tokens: $e');
      if (context.mounted) {
        AIHelpers.showToast(msg: 'Failed to import tokens');
      }
    } finally {
      setBusy(false);
    }
  }
}
