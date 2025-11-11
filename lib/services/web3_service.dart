import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reown_appkit/solana/solana_web3/solana_web3.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/crypto.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';
import 'package:solana/solana.dart';
import 'package:convert/convert.dart';
import 'package:decimal/decimal.dart';

import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/models/models.dart';


class Web3Service with ListenableServiceMixin {
  final api = ApiService(baseUrl: INSOBLOK_WALLET_URL);

  late web3.Web3Client _evmClient;
  late SolanaClient _solanaClient;

  final RxValue<Map<String, double>> _allBalances = RxValue<Map<String, double>>({});
  Map<String, double> get allBalances => _allBalances.value;

  final RxValue<Map<String, double>> _allPrices = RxValue<Map<String, double>>({});
  Map<String, double> get allPrices => _allPrices.value;

  final RxValue<Map<String, double>> _allChanges = RxValue<Map<String, double>>({});
  Map<String, double> get allChanges => _allChanges.value;


  final RxValue<List<Map<String, dynamic>>> _transactions = RxValue<List<Map<String, dynamic>>>([]);
  List<Map<String, dynamic>> get transactions => _transactions.value;

  final RxValue<String> _paymentTransactionHash = RxValue<String>("");
  String get paymentTransactionHash => _paymentTransactionHash.value;

  final RxValue<double> _transactionFee = RxValue<double>(0.0);
  double get transactionFee => _transactionFee.value;

  final ReactiveValue<String> _paymentNetwork = ReactiveValue<String>(kWalletTokenList[0]["chain"].toString());
  String get paymentNetwork =>  _paymentNetwork.value;
  set paymentNetwork(String s) {
    _paymentNetwork.value = s;
    notifyListeners();
  }

  Timer? _timer;

  String _paymentToAddress = '';
  String get paymentToAddress => _paymentToAddress;
  set paymentToAddress(String newAddress) {
    _paymentToAddress = newAddress;
    notifyListeners(); // Notify listeners about the change
  }

  double _paymentAmount = 0.0;
  double get paymentAmount => _paymentAmount;
  set paymentAmount(double amount) {
    _paymentAmount = amount;
    notifyListeners();
  }


  RoomModel chatRoom = RoomModel();
  UserModel chatUser = UserModel();
  /// Constructor: Initialize Web3Service with reactive value listeners and WebSocket connection
  /// Sets up listeners for balance, price, and transaction updates
  WebSocketChannel? channel;
  
  Web3Service() {
    listenToReactiveValues([_allBalances, _allPrices, _allChanges, _transactions, _paymentTransactionHash, _transactionFee]);
    // _initializeWebSocket();
  }

  /// Initialize WebSocket connection to Binance streams for real-time price and market data
  /// Connects to multiple token streams for price updates and 24h change percentages
  void _initializeWebSocket() {
    try {
      String path = kWalletTokenList.map((tk)=> tk["binance_id"].toString().isEmpty ? "" : "/${tk['binance_id'].toString()}@ticker/${tk['binance_id'].toString()}@markPrice" ).toList().join("");
      logger.d("started to connect ws");
      channel = IOWebSocketChannel.connect('wss://fstream.binance.us/stream?streams=$path');
      channel?.stream.listen(
        (data) {
          try {
            final jsonData = json.decode(data);
            // _processTickerData(jsonData);
            // logger.d("Json data is $jsonData");
            final splits = jsonData["stream"].toString().split('@');
            final binanceId = splits[0];
            final opType = splits[1];
            Map<String, dynamic> token = kWalletTokenList.firstWhere((tk) => tk["binance_id"].toString() == binanceId);
            if(opType == "markPrice") {
              Map<String, double> curPrices = { ... allPrices };
              curPrices[token["chain"]] = double.parse(jsonData["data"]["p"]);
              _allPrices.value = curPrices;
            }
            else if (opType == "ticker") {
              Map<String, double> curChanges = { ... allChanges };
              curChanges[token["chain"]] = double.parse(jsonData["data"]["p"]);
              _allChanges.value = curChanges;
            }
            notifyListeners();
          } catch (e) {
            logger.d('Error parsing WebSocket data: $e');
          }
        },
        onError: (error) => logger.d('WebSocket error: $error'),
      );
    } catch (e) {
      logger.d("An exception raised while initializing websocket ${e.toString()}");
    }
  }

  /// Configure the appropriate blockchain client based on the specified chain
  /// Supports Ethereum, Sepolia, BSC, and Solana networks with their respective RPC endpoints
  void setNetwork({required String chain}) {
    switch (chain) {
      case "ethereum":
        _evmClient = web3.Web3Client(
          "$ETHEREUM_RPC_URL/$INFURA_PROJECT_ID",
          http.Client(),
        );
        break;

      case "sepolia":
      case "insoblok":
        _evmClient = web3.Web3Client(
          "$SEPOLIA_RPC_URL/$INFURA_PROJECT_ID",
          http.Client(),
        );
        break;

      case "bnb-mainnet":
        _evmClient = web3.Web3Client(
          "https://bsc-dataseed.binance.org/",
          http.Client(),
        );
        break;

      case "bnb-testnet":
        _evmClient = web3.Web3Client(
          "https://data-seed-prebsc-1-s1.binance.org:8545/",
          http.Client(),
        );
        break;

      case "solana-mainnet":
        _solanaClient = SolanaClient(
          rpcUrl: Uri.parse('https://api.mainnet-beta.solana.com'),
          websocketUrl: Uri.parse('wss://api.mainnet-beta.solana.com'),
        );
        break;

      case "solana-devnet":
        _solanaClient = SolanaClient(
          rpcUrl: Uri.parse('https://api.devnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
        );
        break;

      case "solana-testnet":
        _solanaClient = SolanaClient(
          rpcUrl: Uri.parse('https://api.testnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.testnet.solana.com'),
        );
        break;
    }
  }

  /// -------------------------------
  /// Ethereum-compatible (EVM) methods
  /// -------------------------------


  /// Fetch current token prices in USD from the configured price API endpoint
  /// Returns a dynamic response containing price data for supported tokens
  Future<dynamic> getPricesInUSD() async {
    try {
      final url = Uri.parse(TOKEN_PRICES_URL);
      final response = await http.get(url);
      logger.d("This is price response ${response.body}, $TOKEN_PRICES_URL");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        logger.d("Failed to get prices ${response.body.toString()}");
        return {};
      }
    } catch (e) {
      logger.d("Error fetching token prices: ${e.toString()}");
      return 0.0;
    }
  }


  /// Retrieve token balances for a given wallet address across all supported chains
  /// Updates the internal _allBalances state with the fetched balance data
  Future<void> getBalances(String address) async {
    try {
      final body = {
        "chain": "",
        "address": address
      };
      logger.d("address is $address");

      final balances = await api.postRequest("/evm/balance", body);
      Map<String, double> result = {};
      for (var balance in balances) {
        result[balance["chain"]] = balance["balance"];
      }
      _allBalances.value = result;
      notifyListeners();
    } catch (e) {
      logger.d("Error: $e");
      _allBalances.value = {};
      notifyListeners();
    }
  }

  /// Fetch and process current token prices and 24h price changes
  /// Updates _allPrices and _allChanges reactive values with market data
  Future<void> getPrices() async {
    try {
      final prices = await getPricesInUSD();
      Map<String, double> values = {};
      Map<String, double> changeValues = {};
      for (var tk in kWalletTokenList) {
          final price = prices.where((pr) => pr["symbol"].toString().toLowerCase() == tk["binance_id"].toString().toLowerCase()).toList();
          if (price.isEmpty) {
            values[tk["chain"].toString()] = 0;
            changeValues[tk["chain"].toString()] = 0;
          }
          else {
            values[tk["chain"].toString()] = double.parse((price[0]?["lastPrice"] ?? 0).toString());
            changeValues[tk["chain"].toString()] = double.parse((price[0]?["priceChangePercent"] ?? 0).toString());
          }
      }
      _allPrices.value = values;
      _allChanges.value = changeValues;

    } catch (e) {
      logger.d("Exception raised while getting prices ${e.toString()}");
      _allPrices.value = { "insoblok": 0, "usdt": 1, "xrp": 0, "ethereum": 0, "sepolia": 0};
      _allChanges.value = { "insoblok": 0, "usdt": 0, "xrp": 0, "ethereum": 0, "sepolia": 0};
    }
    notifyListeners();
  }

  /// Send EVM-compatible tokens (native ETH or ERC-20 tokens) to a specified address
  /// Handles both native token transfers and ERC-20 token contract interactions
  /// Returns transaction details including hash and status
  Future<Map<String, dynamic>> sendEvmToken(
    String to, 
    double amount, 
    Map<String, dynamic> network, 
    EthPrivateKey? privateKey, 
  ) async {
    if (privateKey == null) {
      logger.d("Invalid private key.");
      return {};
    }  
    final decimals = 18;
    try {
      final senderAddress = AuthHelper.user!.walletAddress!;
      final tokenAddress = network["token_address"];
      setNetwork(chain: network["chain"]);

      // Determine if this is a native token or ERC-20 transfer
      final bool isNativeToken = tokenAddress.isEmpty;
      
      EthereumAddress from = await privateKey.extractAddress();
      EthereumAddress toAddress = EthereumAddress.fromHex(to);
      
      // Convert amount to appropriate units
      final amountWei = (BigInt.from(amount * pow(10, decimals).toInt()));
      
      // DIFFERENT APPROACH FOR NATIVE VS ERC-20 TOKENS
      BigInt maxFeeWei;
      BigInt maxPriorityFeeWei;
      int nonce;
      if (isNativeToken) {
        // For native ETH: Get gas parameters directly from node
        final gasPrice = await _evmClient.getGasPrice();
        maxFeeWei = gasPrice.getInWei;
        maxPriorityFeeWei = gasPrice.getInWei;
        nonce = await _evmClient.getTransactionCount(from);
      } else {
        // For ERC-20 tokens: Fetch quote from service
        final unsignedTx = await fetchQuote(
          from: from.hex, 
          to: to, 
          amount: amount, 
          chain: network["chain"],
        );
        maxFeeWei = (Decimal.parse(unsignedTx["maxFeePerGas"].toString())).toBigInt();
        maxPriorityFeeWei = (Decimal.parse(unsignedTx["maxPriorityFeePerGas"].toString())).toBigInt();
        nonce = unsignedTx["nonce"];
      }
      
      // Prepare transaction data
      Uint8List? transactionData;
      EthereumAddress? transactionTo;
      web3.EtherAmount? transactionValue;
      
      if (isNativeToken) {
        // Native ETH transfer
        transactionTo = toAddress;
        transactionValue = web3.EtherAmount.fromBigInt(web3.EtherUnit.wei, amountWei);
        transactionData = Uint8List(0);
      } else {
        // ERC-20 token transfer
        transactionTo = EthereumAddress.fromHex(tokenAddress);
        transactionValue = web3.EtherAmount.zero();
        transactionData = _encodeERC20Transfer(toAddress, amountWei);
      }
      
      // Sign the transaction
      final signedTx = await _evmClient.signTransaction(
        privateKey, 
        web3.Transaction(
          from: from,
          to: transactionTo,
          nonce: nonce,
          value: transactionValue,
          gasPrice: await _evmClient.getGasPrice(),
          // maxGas: 21000,
          // maxFeePerGas: EtherAmount.fromBigInt(EtherUnit.wei, maxFeeWei),
          // maxPriorityFeePerGas: EtherAmount.fromBigInt(EtherUnit.wei, maxPriorityFeeWei),
          maxGas: isNativeToken ? 21000 : 65000,
          data: transactionData,
        ), 
        chainId: network["chainId"],
      );

      // final signedTx = await _evmClient.signTransaction(
      //   privateKey, 
      //   Transaction(
      //     from: await privateKey.extractAddress(),
      //     to: EthereumAddress.fromHex(to),
      //     value: EtherAmount.fromBigInt(EtherUnit.wei, BigInt.from(amount * 1e18)),
      //     gasPrice: await _evmClient.getGasPrice(),
      //     // Use the correct parameter name for gas limit
      //     maxGas: 21000, // or calculate estimated gas if needed
      //   ), 
      //   chainId: network["chainId"],
      // );
      
      final body = {
        "chain": network["chain"],
        "chainId": network["chainId"],
        "signed_raw_tx": hex.encode(signedTx),
        "from_address": senderAddress,
        "to_address": to,
        "token_address": tokenAddress,
        "token_symbol": isNativeToken ? "ETH" : "",
        "amount": amount.toString(),
        "decimals": decimals.toString(),
        "is_native_token": isNativeToken.toString(),
      };
      
      final response = await api.postRequest("/evm/send", body);
      _paymentTransactionHash.value = response["tx_hash"];
      notifyListeners();
      return response;
      
    } catch (e) {
      logger.d("Caught an Exception like $e");
      notifyListeners();
      return {};
    }
}

  /// Get SOL balance for a Solana wallet address
  /// Converts lamports to SOL and returns the balance as a double
  Future<double> getSolBalance(String publicKeyBase58, String chain) async {
    setNetwork(chain: chain);
    final balanceResult = await _solanaClient.rpcClient.getBalance(publicKeyBase58);
    final lamports = balanceResult.value;
    
    // For better precision, you might want to use:
    return lamports / LAMPORTS_PER_SOL.toDouble();
  }
  
  
  /*
  Future<String> sendSol({
    required String senderPrivateKeyBase58,
    required String recipient,
    required double amountSol,
  }) async {
    final wallet = await Ed25519HDKeyPair.fromPrivateKeyBytes(
      privateKey: base58decode(senderPrivateKeyBase58),
    );

    final signature = await _solanaClient.rpcClient.requestAirdrop(
      wallet.address,
      (amountSol * lamportsPerSol).toInt(),
    );

    return signature;
  }
  */

  /// Fetch transaction history for a given wallet address
  /// Enriches transaction data with network information and display properties
  Future<void> getTransactions(String address) async {
    try {
      final dynamic response = await api.getRequest("/common/transactions/$address");
      final List<Map<String, dynamic>> txs = List<Map<String, dynamic>>.from(response);
      List<Map<String, dynamic>> results = txs.map((tx) {
        if(tx["chain"] != null) {
          final network = kWalletTokenList.firstWhere((element) => element["chain"] == tx["chain"]);
          tx["displayName"] = network["displayName"];
          tx["icon"] = network["icon"];
          tx["short_name"] = network["short_name"];
          tx["scanUrl"] = network["scanUrl"];
        }
        else {
          final from_network = kWalletTokenList.firstWhere((element) => element["chain"] == tx["from_token_network"]);
          final to_network = kWalletTokenList.firstWhere((element) => element["chain"] == tx["to_token_network"]);
          tx["from_network"] = from_network["chain"];
          tx["to_network"] = to_network["chain"];
          tx["from_network_display_name"] = from_network["displayName"];
          tx["to_network_display_name"] = to_network["displayName"];
          tx["from_network_icon"] = from_network["icon"];
          tx["to_network_icon"] = to_network["icon"];
          tx["from_network_short_name"] = from_network["short_name"];
          tx["to_network_short_name"] = to_network["short_name"];
          tx["from_network_scanUrl"] = from_network["scanUrl"];
          tx["to_network_scanUrl"] = to_network["scanUrl"];
        }
        return tx;
      }).toList();

      _transactions.value = results;
      notifyListeners();
    }
    catch (e) {
      logger.d(e);
    }
  }

  /// Add a new transaction to the local transaction list
  /// Enriches transaction with network metadata and maintains chronological order
  void addTransaction(Map<String, dynamic> tx) {
    final current = _transactions.value ?? [];
    final network = kWalletTokenList.firstWhere((tk) => tk["chain"] == tx["chain"]);
    tx["displayName"] = network["displayName"];
    tx["icon"] = network["icon"];
    tx["short_name"] = network["short_name"];
    tx["scanUrl"] = network["scanUrl"];
    final newTransactions = [...current, tx];
    newTransactions.sort((a, b) => b["timestamp"]!.compareTo(a["timestamp"]!));
    _transactions.value = newTransactions;
    notifyListeners();
  }

  /// Monitor transaction status using periodic polling until confirmation
  /// Updates transaction status in local state and refreshes balances when confirmed
  Future<void> getTransactionStatus(String hash, String chain, String address) async {
    try {
      logger.d("Start timer.");
      _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        logger.d("We are about to get transaction status.");
        final response = await api.getRequest("/evm/transaction/$chain/$hash");
        if (response["status"] != "pending") {
          logger.d("Cancelling the timer");
          final current = _transactions.value ?? [];
          final updated = current.map((tx) {
            if (tx["tx_hash"] == response["tx_hash"]) {
              logger.d("Found matching transaction.");
              return { ...tx, "status": response["status"] };
            }
            else {
              return tx;
            }
          }).toList();
          _transactions.value = updated;
          _timer!.cancel();
          AIHelpers.showToast(msg: "Transaction confirmed.");
          await getBalances(address);
        }
          
        });
    } catch (e) {
      logger.d("An error occurred while getting transaction status: $e");
    }
  }      

  /// Fetch transaction quote including gas estimates and fees
  /// Used for ERC-20 token transfers to get accurate gas parameters
  Future<Map<String, dynamic>> fetchQuote({
    required String from,
    required String to,
    required double amount,
    required String chain
  }) async {
      final response = await api.postRequest('/evm/transaction/get-quote', {
        'from_address': from,
        'to': to,
        'amount': amount,
        'chain': chain
      });
      return response;
  }

  /// Encode ERC-20 transfer function call data for smart contract interaction
  /// Creates the proper ABI-encoded data for transfer(address,uint256) function
  Uint8List _encodeERC20Transfer(EthereumAddress toAddress, BigInt amountWei) {
    // ERC-20 transfer function signature: transfer(address,uint256)
    final transferFunctionSignature = 'transfer(address,uint256)';
    final functionSelector = keccak256(utf8.encode(transferFunctionSignature)).sublist(0, 4);
    
    // Encode parameters
    final encodedAddress = _encodeAddress(toAddress);
    final encodedAmount = _encodeUint256(amountWei);
    
    // Combine everything
    return Uint8List.fromList([
      ...functionSelector,
      ...encodedAddress,
      ...encodedAmount,
    ]);
  }

  /// Encode Ethereum address to 32-byte padded format for ABI compliance
  /// Adds 12 bytes of zero padding before the 20-byte address
  Uint8List _encodeAddress(EthereumAddress address) {
    final addressBytes = address.addressBytes;
    return Uint8List.fromList([
      ...List.filled(12, 0), // 12 bytes of padding
      ...addressBytes, // 20 bytes address
    ]);
  }

  /// Encode BigInt value to 32-byte uint256 format for ABI compliance
  /// Pads the value with leading zeros to reach 32 bytes
  Uint8List _encodeUint256(BigInt value) {
    final bytes = _bigIntToBytes(value);
    return Uint8List.fromList([
      ...List.filled(32 - bytes.length, 0), // Padding
      ...bytes,
    ]);
  }

  /// Convert BigInt to byte array representation
  /// Ensures even-length hex string and converts to bytes
  Uint8List _bigIntToBytes(BigInt number) {
    var hex = number.toRadixString(16);
    if (hex.length % 2 != 0) {
      hex = '0$hex';
    }
    return hexToBytes(hex);
  }

  /// Estimate transaction fee for an EVM transaction
  /// Calculates gas cost and converts to ETH equivalent for fee display
  Future<double> getTransactionFee(Credentials creds, String chain, EthereumAddress to, double amount) async {
    double gasEstimate = 0;
    try {
      setNetwork(chain: chain);
      final from = await creds.extractAddress();
      // Example: estimating a simple ETH transfer
      final result = await _evmClient.estimateGas(
        sender: from,
        to: to,
        value: web3.EtherAmount.fromUnitAndValue(web3.EtherUnit.ether, amount.toBigInt())
      );

      gasEstimate = result.toDouble() / pow(10, 18).toDouble();
    } catch(e) {
      logger.d("An error occurred while estimating transaction fee, $e");
    }
    _transactionFee.value = gasEstimate;
    notifyListeners();
    logger.d("transaction fee is ${gasEstimate}");
    return gasEstimate;
    
  }

  /// Execute a simple token transfer via API endpoint
  /// Returns the transaction hash of the submitted transfer
  Future<String> transfer(String chain, EthereumAddress to, double amount) async {
    try {
      final response = await api.postRequest("/evm/transaction/transfer", {
        "recipient": to.hex.toString(),
        "amount": amount,
        "chain": chain
      });
      return response["tx_hash"] ?? "";
    } catch (e) {
      logger.d("Exception raised while transferring $e");
    }
    return "";
  }

  /// Convert XP (experience points) to INSO tokens through swap API
  /// Handles the exchange rate calculation and transaction preparation
  Future<Map<String, dynamic>> getINSOByXP(double xpAmount, double insoAmount, String toAddress) async {
    try {
      final response = await api.postRequest('/swap/get-inso-from-xp', {
        "from_amount": xpAmount,
        "to_amount": insoAmount,
        "to_address": toAddress,
      });
      logger.d("Result is $response");
      Map<String, dynamic> result = response as Map<String, dynamic>;
      return result;
    } catch (e) {
      logger.d("Exception raised while converting XP to INSO ${e.toString()}");
    }
    return {};
  }

  /// Fetch detailed token information from CoinGecko API
  /// Returns comprehensive token data including price, market cap, and metadata
  Future<Map<String, dynamic>> getTokenDetails(String coingecko_id) async {
  if (coingecko_id.isEmpty) {
    logger.w("Empty coingecko_id provided");
    return {};
  }

  try {
    final String url = "$TOKEN_DETAILS_COINGECKO_URL/$coingecko_id";
    final dynamic response = await api.getRequestWithFullUrl(url);
    
    if (response is Map<String, dynamic>) {
      return response;
    } else {
      logger.w("Invalid response format from API for $coingecko_id");
      return {};
    }
  } catch (e, stackTrace) {
    logger.e(
      "Exception raised while getting token details for $coingecko_id",
      error: e,
      stackTrace: stackTrace
    );
    return {};
  }
}

  /// Get list of available token IDs that are supported on configured networks
  /// Filters CoinGecko token list to only include tokens on supported platforms
  Future<List<String>> getAvailableTokenIds() async {
    try {
      final listResponse = await api.getRequestWithFullUrl(TOKEN_LIST_COINGECKO_URL);
      List<Map<String, dynamic>> lists = (listResponse as List).cast<Map<String, dynamic>>();
      List<String> availableTokenIds = lists.where((one) {
        Map<String, dynamic> platforms = one["platforms"] as Map<String, dynamic>;
        return platforms.keys.any((elem) => kAvailableNetworks.contains(elem));
      })
      .map((one) => one["id"].toString())
      .toList();
      return availableTokenIds;
    } catch (e) {
      logger.d("Exception raised while getting token list. $e");
    }
    return [];
  }

  /// Search for tokens by symbol/name within the available token list
  /// Returns filtered results that match the query and are available on supported networks
  Future<List<Map<String, dynamic>>> searchTokensBySymbol(String query, List<String> availableIds) async {
    try {
      final listResponse = await api.getRequestWithFullUrl("$TOKEN_SEARCH_COINGECKO_URL$query");
      List<Map<String, dynamic>> lists = (listResponse["coins"] as List).cast<Map<String, dynamic>>();
      final response = lists.where((one) => availableIds.contains(one["id"].toString())).toList();
      return response;
    } catch (e) {
      logger.d("Exception raised while getting token list. $e");
    }
    return [];
  }

  /// Fetch market data for user's favorite tokens by their CoinGecko IDs
  /// Returns current market information including prices and market metrics
  Future<List<Map<String, dynamic>>> getFavoriteTokensByIds(List<String> ids) async {
    try {
      logger.d("Favorite tokens are $ids");
      final response = await api.getRequestWithFullUrl("$TOKEN_MARKETS_COINGECKO_URL${ids.join(',')}");
      logger.d("Response is $response");
      List<Map<String, dynamic>> lists = (response as List).cast<Map<String, dynamic>>();
      return lists;
    } catch (e) {
      logger.d("Exception raised while getting favorite token information. $e");
    }
    return [];
  }
  
  /// Remove tokens from user's favorites list in Firestore database
  /// Updates the user document by removing specified token IDs from favorite_tokens array
  Future<bool> removeFavoriteTokens(String userId, List<String> tokenIds) async {
    final _fireStore = FirebaseFirestore.instance;
    try {
      final userCollectionRef = _fireStore.collection("users2");
      final userDoc = await userCollectionRef.doc(userId);
      await userDoc.update({
        "favorite_tokens": FieldValue.arrayRemove(tokenIds)
      });
      return true;
    } catch (e) {
      logger.d("Exception raised while removing favorite tokens. $e");
      return false;
    }
  } 

}