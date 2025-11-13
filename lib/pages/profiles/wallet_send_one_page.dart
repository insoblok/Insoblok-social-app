import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class WalletSendOnePage extends StatefulWidget {
  const WalletSendOnePage({super.key});

  @override
  State<WalletSendOnePage> createState() => WalletSendOnePageState();
}

class _TransactionConfirmDialog extends StatefulWidget {
  final WalletSendProvider viewModel;
  final double price;
  final double amountValue;
  final String tokenSymbol;
  final Map<String, dynamic> selectedToken;
  final String receiverAddress;
  final double fee;
  final double feeInUsd;
  final double currentBalance;
  final double totalPrice;
  final String senderAddress;
  final String network;

  const _TransactionConfirmDialog({
    required this.viewModel,
    required this.price,
    required this.amountValue,
    required this.tokenSymbol,
    required this.selectedToken,
    required this.receiverAddress,
    required this.fee,
    required this.feeInUsd,
    required this.currentBalance,
    required this.totalPrice,
    required this.senderAddress,
    required this.network,
  });

  @override
  State<_TransactionConfirmDialog> createState() =>
      _TransactionConfirmDialogState();
}

class _TransactionConfirmDialogState extends State<_TransactionConfirmDialog> {
  bool _isSending = false;

  Future<void> _handleConfirm() async {
    setState(() {
      _isSending = true;
    });

    try {
      final success = await widget.viewModel.handleClickSend(
        context,
        widget.senderAddress,
        widget.receiverAddress,
        widget.network,
        widget.amountValue,
      );

      if (mounted) {
        // Close the confirm dialog
        Navigator.of(context).pop(success);
      }
    } catch (e) {
      if (mounted) {
        // Close the confirm dialog with failure
        Navigator.of(context).pop(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount in USD
            Center(
              child: Text(
                "${widget.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Amount in Token
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.selectedToken["icon"] != null)
                    ClipOval(
                      child: Container(
                        color: Colors.grey.shade400,
                        child: AIImage(
                          widget.selectedToken["icon"],
                          width: 32.0,
                          height: 32.0,
                        ),
                      ),
                    ),
                  if (widget.selectedToken["icon"] != null)
                    const SizedBox(width: 12),
                  Text(
                    "${AIHelpers.formatDouble(widget.amountValue, 10)} ${widget.tokenSymbol}",
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.blueGrey),
            const SizedBox(height: 24),
            // Transaction Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // To (Receiver Address)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "To",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SelectableText(
                        widget.receiverAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Network
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Network",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.selectedToken["displayName"]?.toString() ??
                            widget.tokenSymbol,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Network Fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Network fee",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${AIHelpers.formatDouble(widget.fee, 6)} ${widget.tokenSymbol}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${widget.feeInUsd.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Spend Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Spend time",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Est. less than 10 minutes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Current Balance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Current balance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${AIHelpers.formatDouble(widget.currentBalance, 6)} ${widget.tokenSymbol}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed:
                        _isSending
                            ? null
                            : () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSending ? null : _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isSending
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              "Confirm",
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WalletSendOnePageState extends State<WalletSendOnePage> {
  String amount = "0";

  void _onKeyTap(String value) {
    setState(() {
      if (value == "⌫") {
        if (amount.isNotEmpty && amount != "0") {
          amount = amount.substring(0, amount.length - 1);
          if (amount.isEmpty) amount = "0";
        }
      } else if (value == ".") {
        // Handle decimal point - only allow one decimal point
        if (!amount.contains(".")) {
          if (amount == "0") {
            amount = "0.";
          } else {
            amount += value;
          }
        }
      } else {
        if (amount == "0") {
          amount = value;
        } else {
          amount += value;
        }
      }
    });
  }

  Future<void> _showTransactionConfirmDialog(
    BuildContext context,
    WalletSendProvider viewModel,
    double amountValue,
  ) async {
    // Get selected token info
    final selectedToken = kWalletTokenList[viewModel.selectedFromToken];
    final network = selectedToken["chain"].toString();
    final tokenSymbol = selectedToken["short_name"]?.toString() ?? "";
    final receiverAddress = viewModel.receiverController.text;
    final senderAddress = viewModel.address ?? "";
    final currentBalance = viewModel.allBalances[network] ?? 0.0;
    logger.d("current balance is ${currentBalance}");
    // Calculate price in USD
    final price = amountValue * (viewModel.allPrices[network] ?? 0.0);

    // Get transaction fee (try to get it, or use 0 if not available)
    double fee = 0.0;
    try {
      if (receiverAddress.isNotEmpty && amountValue > 0) {
        await viewModel.web3Service.getTransactionFee(
          viewModel.cryptoService.privateKey!,
          network,
          EthereumAddress.fromHex(receiverAddress),
          amountValue,
        );
        fee = viewModel.transactionFee;
      }
    } catch (e) {
      logger.d("Error getting transaction fee: $e");
    }

    final feeInUsd = fee * (viewModel.allPrices[network] ?? 0.0);
    final totalPrice = price + feeInUsd;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => _TransactionConfirmDialog(
            viewModel: viewModel,
            price: price,
            amountValue: amountValue,
            tokenSymbol: tokenSymbol,
            selectedToken: selectedToken,
            receiverAddress: receiverAddress,
            fee: fee,
            feeInUsd: feeInUsd,
            currentBalance: currentBalance,
            totalPrice: totalPrice,
            senderAddress: senderAddress,
            network: network,
          ),
    );

    if (confirmed == true) {
      // Show result dialog (success)
      if (context.mounted) {
        _showResultDialog(context, true, viewModel);
      }
    } else if (confirmed == false) {
      // Show result dialog (failure)
      if (context.mounted) {
        _showResultDialog(context, false, viewModel);
      }
    }
  }

  void _showResultDialog(
    BuildContext context,
    bool? success,
    WalletSendProvider viewModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    success == true ? Icons.check_circle : Icons.error,
                    color: success == true ? Colors.green : Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    success == true ? "Success" : "Failed",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: success == true ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    success == true
                        ? "Token sent successfully!"
                        : viewModel.hasError
                        ? viewModel.modelError.toString()
                        : "Failed to send token",
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletSendProvider>.reactive(
      viewModelBuilder: () => WalletSendProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, "", "", "", 0),
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text('My Wallet'), centerTitle: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Token Selection Section ---
                  const Text(
                    "Select Token",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Builder(
                      builder: (context) {
                        // Filter out XP and Inso tokens
                        final filteredTokens =
                            kWalletTokenList.asMap().entries.where((entry) {
                              final token = entry.value;
                              final name =
                                  (token['name']?.toString() ?? '')
                                      .toLowerCase();
                              final shortName =
                                  (token['short_name']?.toString() ?? '')
                                      .toLowerCase();
                              final chain =
                                  (token['chain']?.toString() ?? '')
                                      .toLowerCase();
                              return !name.contains('xp') &&
                                  !shortName.contains('xp') &&
                                  !chain.contains('xp');
                            }).toList();
                        // Find the selected index in the filtered list
                        int? selectedFilteredIndex;
                        if (viewModel.selectedFromToken <
                            kWalletTokenList.length) {
                          final selectedToken =
                              kWalletTokenList[viewModel.selectedFromToken];
                          selectedFilteredIndex = filteredTokens.indexWhere(
                            (entry) => entry.value == selectedToken,
                          );
                          if (selectedFilteredIndex == -1) {
                            selectedFilteredIndex =
                                0; // Default to first if selected token is filtered out
                          }
                        } else {
                          selectedFilteredIndex = 0;
                        }

                        return DropdownButton<int>(
                          isExpanded: true,
                          value: selectedFilteredIndex,
                          dropdownColor: Colors.grey[900],
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          underline: Container(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          items:
                              filteredTokens.asMap().entries.map((
                                filteredEntry,
                              ) {
                                final filteredIndex = filteredEntry.key;
                                final originalEntry = filteredEntry.value;
                                final token = originalEntry.value;
                                return DropdownMenuItem<int>(
                                  value: filteredIndex,
                                  child: Row(
                                    children: [
                                      if (token['icon'] != null) ...[
                                        ClipOval(
                                          child: Container(
                                            color: Colors.grey.shade400,
                                            child: AIImage(
                                              token['icon'],
                                              width: 24.0,
                                              height: 24.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                      ],
                                      Text(
                                        token['short_name']
                                                ?.toString()
                                                .toUpperCase() ??
                                            token['name']?.toString() ??
                                            'Token',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                          onChanged: (int? filteredIndex) {
                            if (filteredIndex != null &&
                                filteredIndex < filteredTokens.length) {
                              final originalIndex =
                                  filteredTokens[filteredIndex].key;
                              viewModel.selectFromToken(originalIndex);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Selected Token Info ---
                  if (viewModel.selectedFromToken <
                      kWalletTokenList.length) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (kWalletTokenList[viewModel
                                      .selectedFromToken]['icon'] !=
                                  null)
                                ClipOval(
                                  child: Container(
                                    color: Colors.grey.shade400,
                                    child: AIImage(
                                      kWalletTokenList[viewModel
                                          .selectedFromToken]['icon'],
                                      width: 32.0,
                                      height: 32.0,
                                    ),
                                  ),
                                ),
                              if (kWalletTokenList[viewModel
                                      .selectedFromToken]['icon'] !=
                                  null)
                                const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kWalletTokenList[viewModel
                                                  .selectedFromToken]['short_name']
                                              ?.toString() ??
                                          'Token',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Balance: ${AIHelpers.formatDouble(viewModel.allBalances[kWalletTokenList[viewModel.selectedFromToken]["chain"]] ?? 0, 6)} ${kWalletTokenList[viewModel.selectedFromToken]['short_name']?.toString() ?? ''}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Address: ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Expanded(
                                child: SelectableText(
                                  viewModel.address ?? 'N/A',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // --- Receiver Address Input ---
                  const Text(
                    "Receiver Address",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: viewModel.receiverController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Enter receiver address",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Amount Display ---
                  const Text(
                    "Amount",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5A2EFF), Color(0xFF7D2DFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "$amount",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Number Pad ---
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate height based on available width with reduced size
                      final availableWidth =
                          constraints.maxWidth - 32; // account for padding
                      final buttonWidth =
                          (availableWidth - 12) /
                          3; // 3 columns with reduced spacing
                      final buttonHeight =
                          buttonWidth *
                          0.65; // Make buttons more compact (wider than tall)
                      // Calculate total height needed for 4 rows
                      // Formula: (buttonHeight * 4 rows) + (spacing * 3 gaps) + (vertical padding * 2)
                      final calculatedHeight =
                          (buttonHeight * 4) +
                          (6.0 * 3) +
                          (12.0 *
                              2); // 4 rows + 3 spacings + top/bottom padding
                      // Use a generous minimum height to ensure all buttons are visible
                      final totalHeight =
                          calculatedHeight < 220.0 ? 220.0 : calculatedHeight;

                      return SizedBox(
                        height: totalHeight,
                        child: GridView.builder(
                          shrinkWrap: false,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          itemCount: 12,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                                mainAxisExtent:
                                    buttonHeight, // Explicitly set button height
                              ),
                          itemBuilder: (context, index) {
                            final keys = [
                              "1",
                              "2",
                              "3",
                              "4",
                              "5",
                              "6",
                              "7",
                              "8",
                              "9",
                              ".",
                              "0",
                              "⌫",
                            ];
                            String key = keys[index];
                            return GestureDetector(
                              onTap: () => _onKeyTap(key),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Transfer Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final amountValue = double.tryParse(amount) ?? 0.0;
                        if (amountValue <= 0) {
                          AIHelpers.showToast(
                            msg: "Please enter a valid amount",
                          );
                          return;
                        }
                        if (viewModel.receiverController.text.isEmpty) {
                          AIHelpers.showToast(
                            msg: "Please enter receiver address",
                          );
                          return;
                        }
                        await _showTransactionConfirmDialog(
                          context,
                          viewModel,
                          amountValue,
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Transfer",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
