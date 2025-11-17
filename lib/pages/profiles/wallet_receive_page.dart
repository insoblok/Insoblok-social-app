import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/locator.dart';

class WalletReceivePage extends StatelessWidget {
  const WalletReceivePage({super.key});

  /// Shorten wallet address like 0xB8fc6...5854B
  String _shortenAddress(String addr) {
    if (addr.length <= 10) return addr;
    return "${addr.substring(0, 6)}...${addr.substring(addr.length - 5)}";
  }

  /// Split address into two lines for display
  List<String> _splitAddress(String address) {
    if (address.length <= 20) {
      return [address];
    }
    final midPoint = address.length ~/ 2;
    // Try to split at a natural point (not in the middle of hex characters)
    return [address.substring(0, midPoint), address.substring(midPoint)];
  }

  /// Get scan URL for address (not transaction)
  String _getAddressScanUrl(String scanUrl) {
    if (scanUrl.contains('/tx')) {
      return scanUrl.replaceAll('/tx', '/address');
    }
    // Default to etherscan if no scanUrl provided
    return 'https://etherscan.io/address';
  }

  void _showQRCodeDialog(
    BuildContext context,
    String address,
    String tokenName,
    Map<String, dynamic>? token,
  ) {
    final tokenIcon = token?['icon'];
    final scanUrl = token?['scanUrl']?.toString() ?? '';
    final addressScanUrl =
        scanUrl.isNotEmpty
            ? _getAddressScanUrl(scanUrl)
            : 'https://etherscan.io/address';
    final addressLines = _splitAddress(address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title: "Account 2 / Ethereum" format
                  Text(
                    tokenName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // QR Code with logo overlay
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        WalletQrDisplay(
                          data: address,
                          size: 240,
                          backgroundColor: Colors.white,
                        ),
                        // Logo overlay in center
                        if (tokenIcon != null)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AIImage(
                                tokenIcon,
                                width: 48.0,
                                height: 48.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "Ethereum Address" heading
                  Text(
                    '$tokenName Address',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description text
                  Text(
                    'Use this address to receive tokens and collectibles on $tokenName.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  // Full address in two lines
                  SelectableText(
                    addressLines.join('\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Copy address button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _copyAddress(context, address);
                        },
                        icon: const Icon(
                          Icons.copy,
                          size: 18,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          'Copy address',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // View on Etherscan button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        AIHelpers.launchExternalSource(
                          '$addressScanUrl/$address',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey.shade700),
                      ),
                      child: const Text(
                        'View on Etherscan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _copyAddress(BuildContext context, String address) {
    Clipboard.setData(ClipboardData(text: address));
    AIHelpers.showToast(msg: "Address copied to clipboard");
  }

  /// Get address for a specific token based on its chain
  String _getTokenAddress(
    Map<String, dynamic> token,
    String defaultAddress,
    Map<String, String> storedAddresses,
  ) {
    final chain = token['chain']?.toString().toLowerCase() ?? '';

    // For EVM-compatible chains (ethereum, sepolia, usdt, insoblok), use ETH address
    if (chain == 'ethereum' ||
        chain == 'sepolia' ||
        chain == 'usdt' ||
        chain == 'insoblok') {
      return defaultAddress;
    }

    // For other chains, try to get stored address
    final storedAddress = storedAddresses[chain];
    if (storedAddress != null && storedAddress.isNotEmpty) {
      return storedAddress;
    }

    return defaultAddress;
  }

  @override
  Widget build(BuildContext context) {
    final cryptoService = locator<CryptoService>();
    final defaultAddress = cryptoService.privateKey?.address.hex ?? "";

    // Filter tokens - show all tokens except XP and Inso
    final displayTokens =
        kWalletTokenList.where((token) {
          final chain = token['chain']?.toString().toLowerCase() ?? '';
          final name = token['name']?.toString().toLowerCase() ?? '';
          final shortName = token['short_name']?.toString().toLowerCase() ?? '';
          return !chain.contains('xp') &&
              !chain.contains('inso') &&
              !name.contains('xp') &&
              !name.contains('inso') &&
              !shortName.contains('xp') &&
              !shortName.contains('inso');
        }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Receiving address'), centerTitle: true),
      body: FutureBuilder<Map<String, String>>(
        future: cryptoService.getStoredAddresses(),
        builder: (context, snapshot) {
          final storedAddresses = snapshot.data ?? {};

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            children: [
              for (var token in displayTokens) ...[
                Builder(
                  builder: (context) {
                    final tokenAddress = _getTokenAddress(
                      token,
                      defaultAddress,
                      storedAddresses,
                    );
                    final tokenName =
                        token['displayName']?.toString() ??
                        token['short_name']?.toString() ??
                        token['name']?.toString() ??
                        'Token';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Token Icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  token['icon'] != null
                                      ? AIImage(
                                        token['icon'],
                                        width: 48.0,
                                        height: 48.0,
                                      )
                                      : Container(
                                        color: Colors.grey.shade400,
                                        child: const Icon(
                                          Icons.account_balance_wallet,
                                          color: Colors.white,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Token Name and Address
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tokenName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _shortenAddress(tokenAddress),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Copy and QR Code Icons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.white70,
                                ),
                                onPressed:
                                    () => _copyAddress(context, tokenAddress),
                                tooltip: 'Copy address',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.qr_code,
                                  color: Colors.white70,
                                ),
                                onPressed:
                                    () => _showQRCodeDialog(
                                      context,
                                      tokenAddress,
                                      tokenName,
                                      token,
                                    ),
                                tooltip: 'Show QR code',
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
