import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/providers/profiles/account_wallet_provider.dart';

class WalletSearchProvider extends InSoBlokViewModel {
  AccountWalletProvider? _accountWalletProvider;

  void setAccountWalletProvider(AccountWalletProvider provider) {
    if (_accountWalletProvider != provider) {
      _accountWalletProvider = provider;
      // Recalculate filtered tokens when provider is set
      _filteredTokens = _getFilteredTokens();
      notifyListeners();
    }
  }

  /// Refresh filtered tokens (useful when popular tokens are loaded later)
  void refreshFilteredTokens() {
    // Try to get AccountWalletProvider if not set
    if (_accountWalletProvider == null) {
      _accountWalletProvider = AccountWalletProvider.instance;
    }
    _filteredTokens = _getFilteredTokens();
    notifyListeners();
  }

  final TextEditingController searchController = TextEditingController();
  final TextEditingController customTokenAddressController =
      TextEditingController();
  final TextEditingController customTokenSymbolController =
      TextEditingController();
  final TextEditingController customTokenDecimalController =
      TextEditingController();

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Map<String, dynamic> _selectedNetwork = kWalletTokenList.firstWhere(
    (token) => token["chain"] == 'ethereum',
    orElse:
        () =>
            kWalletTokenList.firstWhere((token) => token["chain"] == 'sepolia'),
  );

  Map<String, dynamic> get selectedNetwork => _selectedNetwork;
  set selectedNetwork(Map<String, dynamic> network) {
    _selectedNetwork = network;
    _filteredTokens = _getFilteredTokens();
    notifyListeners();
  }

  List<Map<String, dynamic>> _selectedTokens = [];
  List<Map<String, dynamic>> get selectedTokens => _selectedTokens;

  bool isTokenSelected(Map<String, dynamic> token) {
    return _selectedTokens.any(
      (t) =>
          t["chain"] == token["chain"] &&
          t["short_name"] == token["short_name"],
    );
  }

  void toggleTokenSelection(Map<String, dynamic> token) {
    if (isTokenSelected(token)) {
      _selectedTokens.removeWhere(
        (t) =>
            t["chain"] == token["chain"] &&
            t["short_name"] == token["short_name"],
      );
    } else {
      _selectedTokens.add(token);
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> _filteredTokens = [];
  List<Map<String, dynamic>> get filteredTokens => _filteredTokens;

  /// Helper method to check if a token has a valid name
  bool _hasValidName(Map<String, dynamic> token) {
    final name = (token['name'] ?? '').toString().trim();
    final shortName = (token['short_name'] ?? '').toString().trim();
    final displayName = (token['displayName'] ?? '').toString().trim();
    return name.isNotEmpty || shortName.isNotEmpty || displayName.isNotEmpty;
  }

  List<Map<String, dynamic>> _getFilteredTokens() {
    final searchQuery = searchController.text.toLowerCase().trim();

    // Get base tokens from kWalletTokenList
    // Explicitly convert each token to ensure type compatibility
    final filteredKWalletTokens =
        kWalletTokenList
            .where((token) => token["chain"] == _selectedNetwork["chain"])
            .toList();

    // Convert to List<Map<String, dynamic>> explicitly and filter out tokens without names
    List<Map<String, dynamic>> networkTokens =
        filteredKWalletTokens
            .map((token) => Map<String, dynamic>.from(token))
            .where((token) => _hasValidName(token))
            .toList();

    // If searching on ethereum-mainnet, also include popular tokens
    // Try to get AccountWalletProvider if not set
    if (_accountWalletProvider == null) {
      _accountWalletProvider = AccountWalletProvider.instance;
    }

    // When search is empty, show popular tokens first (for Ethereum network)
    if (searchQuery.isEmpty &&
        _selectedNetwork["chain"] == 'ethereum' &&
        _accountWalletProvider != null &&
        _accountWalletProvider!.popularTokens.isNotEmpty) {
      // Return only popular tokens when search is empty
      List<Map<String, dynamic>> popularTokensList = [];
      for (var popularToken in _accountWalletProvider!.popularTokens) {
        // Create a new map with explicit type conversions to ensure compatibility
        final newToken = Map<String, dynamic>.from({
          'chain': popularToken['chain']?.toString() ?? 'ethereum',
          'name': popularToken['name']?.toString() ?? '',
          'short_name': popularToken['short_name']?.toString() ?? '',
          'displayName': popularToken['displayName']?.toString() ?? '',
          'token_address': popularToken['token_address']?.toString() ?? '',
          'icon': popularToken['icon']?.toString() ?? '',
          'decimals':
              popularToken['decimals'] is int
                  ? popularToken['decimals'] as int
                  : (popularToken['decimals'] is num
                      ? (popularToken['decimals'] as num).toInt()
                      : 18),
          'coingecko_id': popularToken['coingecko_id']?.toString() ?? '',
          'test':
              popularToken['test'] is bool
                  ? popularToken['test'] as bool
                  : false,
        });
        // Only add tokens with valid names
        if (_hasValidName(newToken)) {
          popularTokensList.add(newToken);
        }
      }

      return popularTokensList;
    }

    // When searching, include both base tokens and popular tokens
    if (_selectedNetwork["chain"] == 'ethereum' &&
        _accountWalletProvider != null &&
        _accountWalletProvider!.popularTokens.isNotEmpty) {
      // Merge popular tokens with existing tokens, avoiding duplicates
      final existingAddresses =
          networkTokens
              .map((t) => (t["token_address"] ?? "").toString().toLowerCase())
              .toSet();

      for (var popularToken in _accountWalletProvider!.popularTokens) {
        final address =
            (popularToken["token_address"] ?? "").toString().toLowerCase();
        if (address.isNotEmpty && !existingAddresses.contains(address)) {
          // Create a new map with explicit type conversions to ensure compatibility
          // Use Map.from to ensure proper type conversion
          final newToken = Map<String, dynamic>.from({
            'chain': popularToken['chain']?.toString() ?? 'ethereum',
            'name': popularToken['name']?.toString() ?? '',
            'short_name': popularToken['short_name']?.toString() ?? '',
            'displayName': popularToken['displayName']?.toString() ?? '',
            'token_address': popularToken['token_address']?.toString() ?? '',
            'icon': popularToken['icon']?.toString() ?? '',
            'decimals':
                popularToken['decimals'] is int
                    ? popularToken['decimals'] as int
                    : (popularToken['decimals'] is num
                        ? (popularToken['decimals'] as num).toInt()
                        : 18),
            'coingecko_id': popularToken['coingecko_id']?.toString() ?? '',
            'test':
                popularToken['test'] is bool
                    ? popularToken['test'] as bool
                    : false,
          });
          // Only add tokens with valid names
          if (_hasValidName(newToken)) {
            networkTokens.add(newToken);
            existingAddresses.add(address);
          }
        }
      }
    }

    if (searchQuery.isEmpty) {
      // Filter out tokens without names before returning
      return networkTokens.where((token) => _hasValidName(token)).toList();
    }

    return networkTokens.where((token) {
      // First check if token has a valid name
      if (!_hasValidName(token)) {
        return false;
      }

      final name = (token["name"] ?? "").toString().toLowerCase();
      final shortName = (token["short_name"] ?? "").toString().toLowerCase();
      final displayName = (token["displayName"] ?? "").toString().toLowerCase();

      return name.contains(searchQuery) ||
          shortName.contains(searchQuery) ||
          displayName.contains(searchQuery);
    }).toList();
  }

  void onSearchChanged(String query) {
    // Ensure AccountWalletProvider is available
    if (_accountWalletProvider == null) {
      _accountWalletProvider = AccountWalletProvider.instance;
    }
    _filteredTokens = _getFilteredTokens();
    notifyListeners();
  }

  bool get canProceed {
    if (_selectedTabIndex == 0) {
      // Search tab: check if tokens are selected
      return _selectedTokens.isNotEmpty;
    } else {
      // Custom token tab: check if all three fields are filled
      return customTokenAddressController.text.trim().isNotEmpty &&
          customTokenSymbolController.text.trim().isNotEmpty &&
          customTokenDecimalController.text.trim().isNotEmpty;
    }
  }

  bool get _isCustomTokenValid {
    return customTokenAddressController.text.trim().isNotEmpty &&
        customTokenSymbolController.text.trim().isNotEmpty &&
        customTokenDecimalController.text.trim().isNotEmpty;
  }

  Map<String, dynamic>? get customToken {
    if (_selectedTabIndex == 1 && _isCustomTokenValid) {
      // Create custom token object using symbol as name
      return {
        "chain": _selectedNetwork["chain"],
        "name": customTokenSymbolController.text.trim(),
        "short_name": customTokenSymbolController.text.trim(),
        "displayName": customTokenSymbolController.text.trim(),
        "icon": _selectedNetwork["icon"], // Use network icon as fallback
        "token_address": customTokenAddressController.text.trim(),
        "decimals":
            int.tryParse(customTokenDecimalController.text.trim()) ?? 18,
        "test": _selectedNetwork["test"],
      };
    }
    return null;
  }

  List<Map<String, dynamic>> get tokensToImport {
    if (_selectedTabIndex == 0) {
      return _selectedTokens;
    } else {
      final token = customToken;
      return token != null ? [token] : [];
    }
  }

  Future<void> init(BuildContext context) async {
    // Note: We don't add a listener to searchController here because
    // the onChanged callback in the UI already calls onSearchChanged

    // Listen to custom token field changes
    customTokenAddressController.addListener(() {
      notifyListeners();
    });
    customTokenSymbolController.addListener(() {
      notifyListeners();
    });
    customTokenDecimalController.addListener(() {
      notifyListeners();
    });

    // Try to get AccountWalletProvider instance
    if (_accountWalletProvider == null) {
      _accountWalletProvider = AccountWalletProvider.instance;
    }

    // Listen to AccountWalletProvider changes to refresh when popular tokens are loaded
    _accountWalletProvider?.addListener(_onAccountWalletProviderChanged);

    // Ensure popular tokens are being fetched if not already loaded
    if (_accountWalletProvider != null) {
      // If popular tokens are empty, trigger a fetch
      if (_accountWalletProvider!.popularTokens.isEmpty) {
        // Trigger fetch of popular tokens (this will notify listeners when done)
        await _accountWalletProvider!.getSupportedNetworks();
      } else {
        // Trigger a refresh if popular tokens are already loaded
        _filteredTokens = _getFilteredTokens();
        notifyListeners();
      }
    }

    // Initial load of filtered tokens
    _filteredTokens = _getFilteredTokens();
    notifyListeners();
  }

  void _onAccountWalletProviderChanged() {
    // Refresh filtered tokens when popular tokens are updated
    _filteredTokens = _getFilteredTokens();
    notifyListeners();
  }

  @override
  void dispose() {
    // Remove listener from AccountWalletProvider
    _accountWalletProvider?.removeListener(_onAccountWalletProviderChanged);

    searchController.dispose();
    customTokenAddressController.dispose();
    customTokenSymbolController.dispose();
    customTokenDecimalController.dispose();
    super.dispose();
  }
}
