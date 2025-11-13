import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

/// Service for monitoring and checking incoming transactions
class ReceivingService {
  final ApiService _apiService;

  ReceivingService() : _apiService = ApiService(baseUrl: INSOBLOK_WALLET_URL);

  /// Add an address to monitor for incoming transactions
  ///
  /// [address] - The wallet address to monitor
  /// [chain] - Optional chain name (e.g., "ethereum", "usdt", "xrp")
  /// Returns a map with message, address, and chain
  Future<Map<String, dynamic>> addMonitoredAddress({
    required String address,
    String? chain,
  }) async {
    try {
      final response = await _apiService.postRequest('/receiving/monitor', {
        'address': address,
        if (chain != null) 'chain': chain,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error adding monitored address: $e');
      rethrow;
    }
  }

  /// Get list of addresses currently being monitored
  ///
  /// Returns a map with monitored_addresses list and count
  Future<Map<String, dynamic>> getMonitoredAddresses() async {
    try {
      final response = await _apiService.getRequest('/receiving/monitor');
      return response as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error getting monitored addresses: $e');
      rethrow;
    }
  }

  /// Manually check an address for incoming transactions
  ///
  /// [address] - The wallet address to check
  /// [chain] - Chain name (e.g., "ethereum", "usdt", "xrp")
  /// [fromBlock] - Optional block number to start checking from
  /// Returns a map with address, chain, detected_count, and transactions list
  Future<Map<String, dynamic>> checkIncomingTransactions({
    required String address,
    required String chain,
    int? fromBlock,
  }) async {
    try {
      final response = await _apiService.postRequest('/receiving/check', {
        'address': address,
        'chain': chain,
        if (fromBlock != null) 'from_block': fromBlock,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error checking incoming transactions: $e');
      rethrow;
    }
  }

  /// Get all incoming transactions for a specific address
  ///
  /// [address] - The wallet address to get transactions for
  /// [chain] - Optional chain name to filter by
  /// Returns a map with address, chain, count, and transactions list
  Future<Map<String, dynamic>> getIncomingTransactions({
    required String address,
    String? chain,
  }) async {
    try {
      String endpoint = '/receiving/incoming/$address';
      if (chain != null) {
        endpoint += '?chain=$chain';
      }
      final response = await _apiService.getRequest(endpoint);
      return response as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error getting incoming transactions: $e');
      rethrow;
    }
  }

  /// Get incoming transactions as a list of TransactionModel objects
  ///
  /// [address] - The wallet address to get transactions for
  /// [chain] - Optional chain name to filter by
  /// Returns a list of TransactionModel objects
  Future<List<TransactionModel>> getIncomingTransactionsAsModels({
    required String address,
    String? chain,
  }) async {
    try {
      final response = await getIncomingTransactions(
        address: address,
        chain: chain,
      );

      final transactions = response['transactions'] as List<dynamic>? ?? [];

      return transactions.map((tx) {
        // Convert API response to TransactionModel
        // API returns 'created_at' but model expects 'timestamp'
        final txMap = Map<String, dynamic>.from(tx as Map);
        if (txMap.containsKey('created_at') && txMap['created_at'] != null) {
          txMap['timestamp'] = txMap['created_at'];
        }
        return TransactionModel.fromJson(txMap);
      }).toList();
    } catch (e) {
      logger.e('Error getting incoming transactions as models: $e');
      rethrow;
    }
  }
}
