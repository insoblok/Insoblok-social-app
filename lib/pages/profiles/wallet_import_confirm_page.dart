import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class WalletImportConfirmPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedTokens;

  const WalletImportConfirmPage({super.key, required this.selectedTokens});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletImportConfirmProvider>.reactive(
      viewModelBuilder: () => WalletImportConfirmProvider(),
      onViewModelReady: (viewModel) => viewModel.init(selectedTokens),
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Import tokens'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: Column(
              children: [
                const SizedBox(height: 24.0),

                // Question text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    selectedTokens.length == 1
                        ? 'Would you like to import this token?'
                        : 'Would you like to import these tokens?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24.0),

                // Token list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: selectedTokens.length,
                    itemBuilder: (context, index) {
                      final token = selectedTokens[index];
                      return _buildTokenItem(context, token);
                    },
                  ),
                ),

                // Bottom buttons
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(51),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16.0),

                      // Import button
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              viewModel.isBusy
                                  ? null
                                  : () => viewModel.handleImport(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child:
                              viewModel.isBusy
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
                                  : Text(
                                    'Import',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenItem(BuildContext context, Map<String, dynamic> token) {
    // Get network icon for the badge
    final network = kWalletTokenList.firstWhere(
      (t) => t["chain"] == token["chain"],
      orElse: () => kWalletTokenList.firstWhere((t) => t["test"] == false),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(16),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(51),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Token icon with network badge
          Stack(
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: ClipOval(
                  child: AIImage(token["icon"], width: 48.0, height: 48.0),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC739EB),
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: AIImage(network["icon"], width: 16.0, height: 16.0),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16.0),

          // Token name and symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token["displayName"]?.toString() ??
                      token["name"]?.toString() ??
                      token["short_name"]?.toString() ??
                      '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  token["short_name"]?.toString() ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
