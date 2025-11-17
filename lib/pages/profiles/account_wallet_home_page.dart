import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/locator.dart';
import 'package:intl/intl.dart';

class AccountWalletHomePage extends StatefulWidget {
  const AccountWalletHomePage({super.key});

  @override
  State<AccountWalletHomePage> createState() => AccountWalletHomePageState();
}

class AccountWalletHomePageState extends State<AccountWalletHomePage> {
  final CryptoService cryptoService = locator<CryptoService>();
  String? selectedTopItem;

  _handleQRResult(String address) {}

  // Removed unused _getTokenBalance helper

  // Removed old _buildTokenPrice in favor of inline, screenshot-matching UI

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountWalletProvider>.reactive(
      viewModelBuilder: () {
        // Use singleton instance if available and not disposed, otherwise create new one
        final existingInstance = AccountWalletProvider.instance;
        if (existingInstance != null) {
          return existingInstance;
        }
        return AccountWalletProvider();
      },
      onViewModelReady: (viewModel) {
        // Defer init to avoid calling during build phase
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Check if we need to initialize or just refresh
          try {
            // If context is not set or different, initialize
            if (viewModel.context != context) {
              await viewModel.init(context);
            } else {
              // If already initialized, just refresh imported tokens
              await viewModel.refreshImportedTokens();
            }
          } catch (e) {
            // If there's an error, try to initialize
            await viewModel.init(context);
          }
        });
      },
      builder: (context, viewModel, _) {
        return Container(
          child:
              viewModel.isBusy
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Loader(size: 60.0, color: Colors.pink),
                        Text("", style: TextStyle(fontSize: 24)),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      // Header section
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () async {
                                      // Open the modal and wait for the result

                                      final result = await showModalBottomSheet<
                                        Map<String, dynamic>
                                      >(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return NetworkSelectionModal(
                                            // Pass initial state to the modal
                                            initialSelected:
                                                viewModel.enabledNetworks,
                                          );
                                        },
                                      );
                                      if (result != null) {
                                        viewModel.enabledNetworks =
                                            result["enabledNetworks"];
                                        viewModel.setEnabledNetworks(
                                          result["enabledNetworks"],
                                        );
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        viewModel.enabledNetworks.length == 1
                                            ? AIImage(
                                              viewModel
                                                  .enabledNetworks[0]["icon"],
                                              width: 24,
                                              height: 24,
                                            )
                                            : Text(viewModel.networkString),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    AccountWalletIconCover(
                                      child: AIImage(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        viewModel.onClickActions(3);
                                      },
                                    ),
                                    SizedBox(width: 12.0),
                                    AccountWalletIconCover(
                                      child: AIImage(
                                        AIImages.icRefresh,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        viewModel.init(context);
                                      },
                                    ),
                                    SizedBox(width: 12.0),
                                    AccountWalletIconCover(
                                      child: AIImage(
                                        AIImages.icCamera,
                                        color: Colors.white,
                                        width: 23,
                                        height: 23,
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (ctx) => QRScanner(
                                                onQRScanned: (result) {
                                                  logger.d(
                                                    'QR Code Scanned: $result',
                                                  );
                                                  _handleQRResult(result);
                                                },
                                              ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 12.0),
                                    AccountWalletIconCover(
                                      child: AIImage(
                                        AIImages.icMenuQrCode,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              backgroundColor:
                                                  AIColors.darkBackground,
                                              // title: Center(
                                              //   child: Text(
                                              //     'My Wallet Address',
                                              //     style: Theme.of(context).textTheme.bodyLarge
                                              //   )
                                              // ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // This will push both text and button to create centered effect
                                                        Expanded(
                                                          child: Container(
                                                            // This container helps with proper text alignment
                                                            child: Stack(
                                                              children: [
                                                                // Centered Text
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                    ),
                                                                    child: Text(
                                                                      "Scan this address",
                                                                      style:
                                                                          Theme.of(
                                                                            context,
                                                                          ).textTheme.bodyLarge,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Close button on right
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .close,
                                                                    ),
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                        context,
                                                                      ).pop();
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    WalletQrDisplay(
                                                      data:
                                                          cryptoService
                                                              .privateKey!
                                                              .address
                                                              .hex,
                                                      title: "",
                                                      subtitle: "",
                                                      size:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.5,
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                    SizedBox(height: 12.0),
                                                    Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 32.0,
                                                            ),
                                                        child: Text(
                                                          "${cryptoService.privateKey!.address.hex}",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 24.0),
                                                    Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.copy,
                                                            ),
                                                            onPressed: () {
                                                              Clipboard.setData(
                                                                ClipboardData(
                                                                  text:
                                                                      cryptoService
                                                                          .privateKey!
                                                                          .address
                                                                          .hex,
                                                                ),
                                                              );
                                                              AIHelpers.showToast(
                                                                msg:
                                                                    "Copied address to Clipboard",
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(width: 12.0),
                                                          Text(
                                                            "Copy Address",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors
                                                                      .blueAccent,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // actionsAlignment: MainAxisAlignment.center,
                                              // actions: [
                                              //   TextButton(
                                              //     onPressed: () => Navigator.of(context).pop(),
                                              //     child: Text('OK'),
                                              //   ),
                                              // ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 24.0),
                            SizedBox(
                              height: 80,
                              width: double.infinity,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade700,
                                      Colors.red.shade700,
                                      Colors.blue.shade700,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [Text("Your balance")],
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '\$${viewModel.totalBalance.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      viewModel.onClickActions(0);
                                    },
                                    icon: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(
                                        6,
                                      ), // space inside the circle
                                      child: const Icon(
                                        Icons.call_made, // ↗ similar icon
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    label: Text(
                                      "Send",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.only(
                                        left: 4,
                                        right: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ), // pill shape
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      viewModel.onClickActions(1);
                                    },
                                    icon: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(
                                        6,
                                      ), // space inside the circle
                                      child: const Icon(
                                        Icons.call_received, // ↗ similar icon
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    label: Text(
                                      "Receive",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.only(
                                        left: 4,
                                        right: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ), // pill shape
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.0),
                                Container(
                                  padding: EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    border: BoxBorder.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      viewModel.onClickActions(2);
                                    },
                                    icon: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(
                                        6,
                                      ), // space inside the circle
                                      child: const Icon(
                                        Icons.swap_horiz, // ↗ similar icon
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    label: Text(
                                      "Swap",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.only(
                                        left: 4,
                                        right: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ), // pill shape
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 4.0,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 0.0),
                              for (var token in viewModel.enabledNetworks) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  decoration: BoxDecoration(
                                    // color: Colors.grey.withAlpha(30),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (token["chain"] == 'xp')
                                        _showXpConvertSheet(context, viewModel);
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                color: Colors.blueAccent,
                                                child: AIImage(
                                                  token["icon"],
                                                  width: 42.0,
                                                  height: 42.0,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12.0),
                                            Expanded(
                                              // This Expanded is a direct child of Row
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    (token["displayName"] ??
                                                            token["name"] ??
                                                            token["short_name"])
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge!
                                                        .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    token["short_name"]
                                                            ?.toString()
                                                            .toUpperCase() ??
                                                        '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                          color: Colors.white70,
                                                        ),
                                                  ),

                                                  // Show ETH price and value specifically for Ethereum
                                                ],
                                              ),
                                            ),

                                            // Right-aligned price and meta (matches screenshot)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                // Price as plain text
                                                Builder(
                                                  builder: (context) {
                                                    final chain = token["chain"]?.toString() ?? '';
                                                    final price = viewModel.allPrices?[chain] ?? 0.0;
                                                    final bool big = price >= 1.0;
                                                    final priceFmt = big
                                                        ? NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                                                        : NumberFormat.currency(symbol: '\$', decimalDigits: 5);
                                                    return Text(
                                                      priceFmt.format(price),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(height: 2),
                                                // Change meta line
                                                Builder(
                                                  builder: (context) {
                                                    final chain = token["chain"]?.toString() ?? '';
                                                    final price = viewModel.allPrices?[chain] ?? 0.0;
                                                    final pct = viewModel.allChanges?[chain] ?? 0.0; // percent
                                                    final absChange = price * (pct / 100.0);
                                                    final isUp = absChange >= 0.0;
                                                    final changeFmt = NumberFormat('#,##0.00');
                                                    final text = '→ ${isUp ? '+' : '-'}${changeFmt.format(absChange.abs())}';
                                                    return Text(
                                                      text,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall!
                                                          .copyWith(
                                                            color: Colors.grey.shade400,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                    );
                                                  },
                                                ),
                                                // Timestamp
                                                Text(
                                                  'Just now',
                                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                        color: Colors.grey.shade400,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            // IconButton(
                                            //   onPressed: () {
                                            //     viewModel.toggleFavorite(token["chain"]);
                                            //   },
                                            //   icon: Icon(viewModel.checkFavorite(token["chain"]) == true ? Icons.star : Icons.star_border),
                                            //   color: Colors.amberAccent
                                            // )
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 3.0,
                                          ),
                                          child: Divider(
                                            color: Colors.grey.shade800,
                                            thickness: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Activities Tab
                      ),
                    ],
                  ),
        );
      },
    );
  }
}

// void _showXpConvertSheet(BuildContext context, AccountWalletProvider vm) {
//   showModalBottomSheet(
//     context: context,
//     useSafeArea: true,
//     isScrollControlled: false,
//     backgroundColor: Colors.transparent,
//     builder: (_) => RewardTransferView(),
//   );
// }

void _showXpConvertSheet(BuildContext context, AccountWalletProvider parentVm) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: false,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ViewModelBuilder<AccountRewardProvider>.reactive(
        viewModelBuilder: () => AccountRewardProvider(),
        onViewModelReady: (vm) async {
          // If you have a real XP value on parentVm, pass that instead.
          vm.init(context, null);
        },
        builder: (context, vm, __) {
          return RewardTransferView(viewModel: vm);
        },
      );
    },
  );
}

class RewardTransferView extends StatelessWidget {
  const RewardTransferView({super.key, required this.viewModel});
  final AccountRewardProvider viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.secondary.withAlpha(1),
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child:
          viewModel.isBusy
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Loader(size: 60, color: Colors.pink),
                    Text("... Loading Data"),
                  ],
                ),
              )
              : Column(
                children: [
                  Text(
                    'Available : ${viewModel.availableXP} XP',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4.0,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    children: [
                      for (XpInSoModel inSoModel
                          in (AppSettingHelper.appSettingModel?.xpInso ??
                              [])) ...{
                        InkWell(
                          onTap: () {
                            viewModel.selectInSo(inSoModel);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  viewModel.selectXpInSo == inSoModel
                                      ? AIColors.pink
                                      : Theme.of(
                                        context,
                                      ).colorScheme.secondary.withAlpha(16),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: '${inSoModel.max}\n'),
                                  TextSpan(
                                    text:
                                        '(${inSoModel.max! * inSoModel.rate! / 100})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ), // smaller second line
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    viewModel.selectXpInSo == inSoModel
                                        ? AIColors.white
                                        : Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  controller: viewModel.textController,
                                  onChanged: (value) {
                                    viewModel.setXpValue(value);
                                  },
                                ),
                              ),
                              Text('  XP', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          Text('to', style: TextStyle(fontSize: 16)),
                          Row(
                            children: [
                              Text(
                                '${viewModel.convertedInSo()}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('  INSO', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                      TextFillButton(
                        onTap: () {
                          viewModel.convertXPtoINSO();
                        },
                        height: 36,
                        isBusy: viewModel.isBusy,
                        color:
                            viewModel.isPossibleConvert
                                ? Theme.of(context).primaryColor
                                : Theme.of(
                                  context,
                                ).colorScheme.secondary.withAlpha(64),
                        text: 'Convert XP to INSO',
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
