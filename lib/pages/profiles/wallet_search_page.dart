import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/pages/profiles/wallet_import_confirm_page.dart';

class WalletSearchPage extends StatefulWidget {
  const WalletSearchPage({super.key});

  @override
  State<WalletSearchPage> createState() => _WalletSearchPageState();
}

class _WalletSearchPageState extends State<WalletSearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletSearchProvider>.reactive(
      viewModelBuilder: () => WalletSearchProvider(),
      onViewModelReady: (viewModel) {
        viewModel.init(context);
      },
      builder: (context, viewModel, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Import tokens'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: AppBackgroundView(),
          ),
          body: AppBackgroundView(
            child: Column(
              children: [
                // Tab Navigation
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      viewModel.selectedTabIndex = index;
                    },
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 2.0,
                    labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                    unselectedLabelColor:
                        Theme.of(context).textTheme.bodyMedium?.color,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Search'),
                      Tab(text: 'Custom token'),
                    ],
                  ),
                ),

                const SizedBox(height: 16.0),

                // Network Selection Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () => _showNetworkSelector(context, viewModel),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 14.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withAlpha(16),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(51),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC739EB),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: AIImage(
                              viewModel.selectedNetwork["icon"],
                              width: 20.0,
                              height: 20.0,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              viewModel.selectedNetwork["displayName"]
                                      ?.toString() ??
                                  viewModel.selectedNetwork["short_name"]
                                      ?.toString() ??
                                  'Select Network',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                // Token Search Bar (only show in Search tab)
                if (viewModel.selectedTabIndex == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: viewModel.searchController,
                      builder: (context, value, _) {
                        return AITextField(
                          controller: viewModel.searchController,
                          hintText: 'Search tokens',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          suffixIcon:
                              value.text.isNotEmpty
                                  ? IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    onPressed: () {
                                      viewModel.searchController.clear();
                                      viewModel.onSearchChanged('');
                                    },
                                  )
                                  : null,
                          onChanged: (val) {
                            viewModel.onSearchChanged(val);
                          },
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(16),
                          borderColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(51),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 16.0),

                // Token List or Custom Token Form
                Expanded(
                  child:
                      viewModel.selectedTabIndex == 0
                          ? _buildTokenList(context, viewModel)
                          : _buildCustomTokenForm(context, viewModel),
                ),

                // Bottom Next Button
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
                  child: GradientPillButton(
                    text: 'Next',
                    onPressed:
                        viewModel.canProceed
                            ? () async {
                              // Navigate to import confirmation page
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => WalletImportConfirmPage(
                                        selectedTokens:
                                            viewModel.tokensToImport,
                                      ),
                                ),
                              );

                              // If import was successful, pop this page and refresh
                              if (result == true && context.mounted) {
                                Navigator.of(context).pop(true);
                                // Refresh the wallet home page to show imported tokens
                                // This will be handled by the parent page's refresh logic
                              }
                            }
                            : null,
                    loading: viewModel.isBusy,
                    height: 48.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenList(BuildContext context, WalletSearchProvider viewModel) {
    if (viewModel.filteredTokens.isEmpty) {
      return Center(
        child: Text(
          viewModel.searchController.text.isEmpty
              ? 'No tokens found'
              : 'No tokens match your search',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: viewModel.filteredTokens.length,
      itemBuilder: (context, index) {
        final token = viewModel.filteredTokens[index];
        final isSelected = viewModel.isTokenSelected(token);

        return InkWell(
          onTap: () => viewModel.toggleTokenSelection(token),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    viewModel.toggleTokenSelection(token);
                  },
                  activeColor: const Color(0xFFC739EB),
                ),
                const SizedBox(width: 12.0),
                // Token Icon with Network Badge
                Stack(
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: ClipOval(
                        child: AIImage(
                          token["icon"],
                          width: 40.0,
                          height: 40.0,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC739EB),
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: AIImage(
                          viewModel.selectedNetwork["icon"],
                          width: 12.0,
                          height: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        token['name']?.toString() ??
                            token['displayName']?.toString() ??
                            '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (token['short_name']?.toString().isNotEmpty == true &&
                          token['short_name']?.toString() !=
                              token['name']?.toString())
                        Text(
                          token['short_name']?.toString() ?? '',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
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

  Widget _buildCustomTokenForm(
    BuildContext context,
    WalletSearchProvider viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Token Contract Address',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8.0),
          AITextField(
            controller: viewModel.customTokenAddressController,
            hintText: '0x...',
            fillColor: Theme.of(context).colorScheme.secondary.withAlpha(16),
            borderColor: Theme.of(context).colorScheme.onSurface.withAlpha(51),
            onChanged: (value) {
              viewModel.notifyListeners();
            },
          ),
          const SizedBox(height: 16.0),
          Text(
            'Token Symbol',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8.0),
          AITextField(
            controller: viewModel.customTokenSymbolController,
            hintText: 'e.g. USDT',
            fillColor: Theme.of(context).colorScheme.secondary.withAlpha(16),
            borderColor: Theme.of(context).colorScheme.onSurface.withAlpha(51),
            onChanged: (value) {
              viewModel.notifyListeners();
            },
          ),
          const SizedBox(height: 16.0),
          Text(
            'Token Decimal',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8.0),
          AITextField(
            controller: viewModel.customTokenDecimalController,
            hintText: '18',
            fillColor: Theme.of(context).colorScheme.secondary.withAlpha(16),
            borderColor: Theme.of(context).colorScheme.onSurface.withAlpha(51),
            onChanged: (value) {
              viewModel.notifyListeners();
            },
          ),
          const SizedBox(height: 24.0),
          Text(
            'Custom tokens are stored locally on your device and can be imported on any device.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showNetworkSelector(
    BuildContext context,
    WalletSearchProvider viewModel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Network',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                ...kWalletTokenList
                    .where(
                      (token) =>
                          token["chain"] == 'ethereum' ||
                          token["chain"] == 'sepolia',
                    )
                    .map((network) {
                      final isSelected =
                          viewModel.selectedNetwork["chain"] ==
                          network["chain"];
                      return InkWell(
                        onTap: () {
                          viewModel.selectedNetwork = network;
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              Container(
                                width: 24.0,
                                height: 24.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC739EB),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: AIImage(
                                  network["icon"],
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  network["displayName"]?.toString() ??
                                      network["short_name"]?.toString() ??
                                      '',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check,
                                  color: Color(0xFFC739EB),
                                ),
                            ],
                          ),
                        ),
                      );
                    })
                    .toList(),
              ],
            ),
          ),
    );
  }
}
