import 'dart:async';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';

class WalletFavoritesPage extends StatelessWidget {
  const WalletFavoritesPage({super.key});
  

  Future<void> _showSearchDialog(BuildContext ctx, WalletFavoritesProvider viewModel) async {
    Timer? _debounce;
    // The most recent options received from the API.
    late Iterable<String> _lastOptions = <String>[];

    final result = await showGeneralDialog<UserModel?>(
      context: ctx,
      barrierDismissible: true,
      barrierLabel: "Close",
      pageBuilder: (context, _, __) {
        return ViewModelBuilder<WalletFavoritesProvider>.reactive(
          viewModelBuilder: () => WalletFavoritesProvider(),
          onViewModelReady: (viewModel) => viewModel.init(context),
          disposeViewModel: true,
          builder: (context, vm, _) {
            return Scaffold(
              backgroundColor: AIColors.modalBackground,
              appBar: AppBar(
                title: const Text("Add / Remove Favorite tokens"),
                backgroundColor: AIColors.modalBackground,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx, AuthHelper.user),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    AITextField(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (String? val) {
                        if(val == null || val.isEmpty) {
                          return;
                        }
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                          // Start a new timer
                          _debounce = Timer(const Duration(seconds: 1), () async {
                          vm.handleUpdateQuery(val);

                        });

                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                      future: vm.filteredItems, // async getter returns Future<List>
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }
                        final items = snapshot.data ?? [];
                        if (items.isEmpty) {
                          return const Center(child: Text("No tokens found"));
                        }
                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isFavorite = vm.checkFavorite(item["id"]);
                            return ListTile(
                              leading: ClipOval(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Image.network(
                                    item["thumb"].toString(),
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                ),
                              ),
                              title: Text(
                                item["symbol"],
                                style: Theme.of(ctx).textTheme.bodyMedium,
                              ),
                              trailing: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: Colors.amberAccent,
                              ),
                              onTap: () => vm.toggleFavorite(item["id"]),
                            );
                          },
                        );
      
                      },
                      )
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (result != null) {
      viewModel.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletFavoritesProvider>.reactive(
      viewModelBuilder: () => WalletFavoritesProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Container(
          child: viewModel.isBusy ? 
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loader(
                  color: Colors.pink,
                  size: 60
                ),
                SizedBox(height: 18),
                Text(
                  "",
                  style: TextStyle(
                    fontSize: 20
                  )
                ),
              ],
            ) 
          ) :
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: 0,
                      child: Icon(Icons.search)
                    ),
                    Text(
                      "My Favorite Tokens",
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _showSearchDialog(context, viewModel);
                      } 
                    )                    
                  ],
            
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(16),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        alignment: Alignment.centerLeft,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: viewModel.favoriteTokens, // your async getter
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text("No favorite tokens"));
                            }

                            final tokens = snapshot.data!;
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4.0,
                                children: [
                                  for (var token in tokens) ... [
                                    
                                    Row(
                                      spacing: 12.0,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 25,
                                          child: GestureDetector(
                                            onTap: () {
                                              // viewModel.handleClickFavoriteToken(context, token);
                                            },
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Image.network(
                                                      token["image"],
                                                      width: 36.0,
                                                      height: 36.0,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      token['symbol'].toString().toUpperCase(),
                                                      // style: Theme.of(context).textTheme.bodyLarge,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        
                                        Expanded(
                                          flex: 40,
                                          child: Builder(
                                            builder: (context) {
                                              final List<double> prices = (token["sparkline_in_7d"]["price"] as List)
                                                .map((e) => (e as num).toDouble())
                                                .toList();

                                              final List<double> last24 = prices.length > 24
                                                ? prices.sublist(prices.length - 24)
                                                : prices;
                                              
                                              return CryptoSparklineWidget(
                                                symbol: token["symbol"].toString().toUpperCase(),
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                showYLabel: false,
                                                data: last24,
                                                increased: token["price_change_24h"] > 0
                                              );
                                            }
                                          )
                                        ),
                                        Expanded(
                                          flex: 25,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showModalBottomSheet<int>(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext modalContext, StateSetter setModalState) {
                                                      return Container(
                                                        padding: const EdgeInsets.all(8.0),
                                                        height: MediaQuery.of(context).size.height * 0.25,
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).scaffoldBackgroundColor,
                                                          borderRadius: const BorderRadius.vertical(
                                                            top: Radius.circular(20.0),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            // Drag handle
                                                            Center(
                                                              child: Container(
                                                                width: 40,
                                                                height: 4,
                                                                margin: const EdgeInsets.only(bottom: 16),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey.shade400,
                                                                  borderRadius: BorderRadius.circular(2),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              'Display Data',
                                                              style: Theme.of(context).textTheme.headlineLarge,
                                                            ),
                                                            const SizedBox(height: 16),
                                                            // Option 1
                                                            ListTile(
                                                              contentPadding: EdgeInsets.zero,
                                                              title: Text(
                                                                'Last Price',
                                                                style: Theme.of(context).textTheme.bodyMedium
                                                              ),
                                                              trailing: Radio<int>(
                                                                value: 1,
                                                                groupValue: viewModel.viewType, // Read from parent ViewModel
                                                                onChanged: (int? value) {
                                                                  if (value != null) {
                                                                    viewModel.viewType = value; // Update parent ViewModel
                                                                    setModalState(() {}); // Update bottom sheet UI
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () {
                                                                viewModel.viewType = 1;
                                                                setModalState(() {});
                                                              },
                                                            ),
                                                            // Option 2
                                                            ListTile(
                                                              contentPadding: EdgeInsets.zero,
                                                              title: Text(
                                                                'Percent Change',
                                                                style: Theme.of(context).textTheme.bodyMedium
                                                              ),
                                                              trailing: Radio<int>(
                                                                value: 2,
                                                                groupValue: viewModel.viewType,
                                                                onChanged: (int? value) {
                                                                  if (value != null) {
                                                                    viewModel.viewType = value;
                                                                    setModalState(() {});
                                                                  }
                                                                },
                                                              ),
                                                              onTap: () {
                                                                viewModel.viewType = 2;
                                                                setModalState(() {});
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: token["price_change_percentage_24h"] >= 0 ? Colors.green : Colors.red, // The background color
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6.0), // Adjust the value as needed
                                              ),
                                            ),
                                            child: 
                                              viewModel.viewType == 2 ? FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '${token["price_change_percentage_24h"] > 0 ? "+" : ""}${AIHelpers.formatDouble(token["price_change_percentage_24h"].toDouble(), 3)}%',
                                                  style: Theme.of(context).textTheme.bodyMedium
                                                ),
                                              ) : FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  '\$${AIHelpers.formatDouble(token["current_price"].toDouble(), 10)}',
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }
                        )
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
}
