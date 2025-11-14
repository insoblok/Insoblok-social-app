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

  Future<void> _showSearchDialog(
    BuildContext ctx,
    WalletFavoritesProvider viewModel,
  ) async {
    Timer? _debounce;

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
                  ),
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
                        if (val == null || val.isEmpty) {
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
                        future:
                            vm.filteredItems, // async getter returns Future<List>
                        builder: (context, snapshot) {
                          // if (snapshot.connectionState == ConnectionState.waiting) {
                          //   return const Center(child: CircularProgressIndicator());
                          // }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
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
                      ),
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
          child:
              viewModel.isBusy
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Loader(color: Colors.pink, size: 60),
                        SizedBox(height: 18),
                        Text("", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Opacity(opacity: 0, child: Icon(Icons.search)),
                            if (viewModel.isSelectMode) ...{
                              Text(
                                "${viewModel.selectedTokens.length} tokens selected",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  viewModel.handleTapRemoveFavoriteTokens(
                                    context,
                                  );
                                },
                              ),
                            } else ...{
                              Text(
                                "My Favorite Tokens",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  _showSearchDialog(context, viewModel);
                                },
                              ),
                            },
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
                                child: FutureBuilder<
                                  List<Map<String, dynamic>>
                                >(
                                  future:
                                      viewModel
                                          .favoriteTokens, // your async getter
                                  builder: (context, snapshot) {
                                    // if (snapshot.connectionState == ConnectionState.waiting) {
                                    //   return const Center(child: CircularProgressIndicator());
                                    // }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height -
                                            300,
                                        child: Center(
                                          child: Text(
                                            "No favorite tokens",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.labelLarge,
                                          ),
                                        ),
                                      );
                                    }

                                    final tokens = snapshot.data!;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 4.0,
                                      children: [
                                        for (var token in tokens) ...[
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),

                                            decoration: BoxDecoration(
                                              color:
                                                  viewModel.isSelectMode &&
                                                          viewModel
                                                              .selectedTokens
                                                              .contains(
                                                                token["id"],
                                                              )
                                                      ? Colors.blue.shade900
                                                      : Colors.transparent,
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                      .withAlpha(32),
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      () => viewModel
                                                          .handleTapFavoriteToken(
                                                            token["id"],
                                                          ),
                                                  onLongPress:
                                                      () => viewModel
                                                          .handleLongPressFavoriteToken(
                                                            token["id"],
                                                          ),
                                                  child: Stack(
                                                    fit: StackFit.loose,
                                                    children: [
                                                      Row(
                                                        spacing: 8.0,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            flex: 35,
                                                            child: Row(
                                                              children: [
                                                                ClipOval(
                                                                  child: Container(
                                                                    color:
                                                                        Colors
                                                                            .transparent,
                                                                    child: Image.network(
                                                                      token["image"],
                                                                      width:
                                                                          36.0,
                                                                      height:
                                                                          36.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: FittedBox(
                                                                      fit:
                                                                          BoxFit
                                                                              .scaleDown,
                                                                      child: Text(
                                                                        token['symbol']
                                                                            .toString()
                                                                            .toUpperCase(),
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        // style: Theme.of(context).textTheme.bodyLarge,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // Current Price
                                                          Expanded(
                                                            flex: 30,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                              child: Text(
                                                                '\$${AIHelpers.formatDouble(token["current_price"].toDouble(), 2)}',
                                                                style: Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.copyWith(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          ),
                                                          // Price Difference
                                                          Expanded(
                                                            flex: 25,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .centerRight,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                      (token["price_change_24h"] ??
                                                                                  0) >=
                                                                              0
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        6.0,
                                                                      ),
                                                                ),
                                                                child: Text(
                                                                  '${(token["price_change_24h"] ?? 0) >= 0 ? "+" : ""}${AIHelpers.formatDouble((token["price_change_24h"] ?? 0).toDouble(), 2)}',
                                                                  style: Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodyMedium
                                                                      ?.copyWith(
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      if (viewModel
                                                          .selectedTokens
                                                          .contains(
                                                            token["id"],
                                                          ))
                                                        Container(
                                                          color: Colors.blue
                                                              .withAlpha(50),
                                                          child: InkWell(
                                                            onTap:
                                                                () => viewModel
                                                                    .handleTapFavoriteToken(
                                                                      token["id"],
                                                                    ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color:
                                                                    Colors.blue,
                                                                size: 40,
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
                                        ],
                                      ],
                                    );
                                  },
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
}
