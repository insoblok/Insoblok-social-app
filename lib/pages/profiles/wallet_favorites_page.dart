import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';


class WalletFavoritesPage extends StatelessWidget {
  const WalletFavoritesPage({super.key});
  

  void _showSearchDialog(BuildContext ctx, AccountWalletProvider viewModel) {
  showGeneralDialog(
    context: ctx,
    barrierDismissible: true,
    barrierLabel: "Close",
    pageBuilder: (context, _, __) {
      return ViewModelBuilder<AccountWalletProvider>.reactive(
        viewModelBuilder: () => AccountWalletProvider(),
        disposeViewModel: true,
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AIColors.modalBackground,
            appBar: AppBar(
              title: const Text("Add / Remove Favorite tokens"),
              backgroundColor: AIColors.modalBackground,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
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
                    onChanged: viewModel.updateQuery,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = viewModel.filteredItems[index];
                        final isFavorite = viewModel.checkFavorite(item["chain"]);

                        return ListTile(
                          leading: ClipOval(
                            child: Container(
                              color: Colors.grey.shade400,
                              child: AIImage(
                                item["icon"].toString(),
                                width: 24.0,
                                height: 24.0,
                              ),
                            ),
                          ),
                          title: Text(
                            item["short_name"],
                            style: Theme.of(ctx).textTheme.bodyMedium,
                          ),
                          trailing: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: Colors.amberAccent,
                          ),
                          onTap: () => viewModel.toggleSelection(item),
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
}
@override
  Widget build(BuildContext context) {

    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () => AccountWalletProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        logger.d("viewmodel user is ${viewModel.user?.favoriteTokens?.toString()}");
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
                  SizedBox(height: 32.0),
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4.0,
                            children: [
                              for (var token in kWalletTokenList.where((one) => viewModel.user?.favoriteTokens?.contains(one["chain"]) == true).toList()) ... [
                                Row(
                                  spacing: 12.0,
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.grey.shade400,
                                        child: AIImage(
                                          token["icon"],
                                          width: 36.0,
                                          height: 36.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        token['short_name']!.toString(),
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      )
                                    ),
                                    Text(
                                      '${viewModel.allChanges![token["chain"]]! > 0 ? "+" : ""}${AIHelpers.formatDouble(viewModel.allChanges?[token["chain"]] ?? 0, 3)}%',
                                      style: TextStyle(
                                        color: viewModel.allChanges![token["chain"]]! >= 0 ? Colors.green : Colors.red,
                                        fontSize: 14,                                        
                                      )
                                    ),
                                    Text(
                                          '\$${AIHelpers.formatDouble(viewModel.allPrices?[token["chain"]] ?? 0, 10)}',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                  ],
                                ),
                              const SizedBox(height: 8.0),
                              ],
                            ],
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
