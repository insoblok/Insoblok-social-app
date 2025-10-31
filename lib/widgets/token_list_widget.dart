import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/token_provider.dart';
import '../models/token_model.dart';

class TokenListWidget extends StatelessWidget {
  const TokenListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TokenProvider>(
      builder: (context, tokenProvider, child) {
        return Column(
          children: [
            // Status bar
            _buildStatusBar(tokenProvider),
            // Token list
            Expanded(
              child: _buildTokenContent(tokenProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBar(TokenProvider tokenProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Data source
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: tokenProvider.usingTatumApi ? Colors.green : Colors.blue,
              ),
              SizedBox(width: 8),
              Text(
                tokenProvider.dataSource,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          // Refresh button
          // IconButton(
          //   icon: tokenProvider.isLoading 
          //       ? SizedBox(
          //           width: 16,
          //           height: 16,
          //           child: CircularProgressIndicator(strokeWidth: 2),
          //         )
          //       : Icon(Icons.refresh, size: 20),
          //   onPressed: tokenProvider.manualRefresh,
          // ),
        ],
      ),
    );
  }

  Widget _buildTokenContent(TokenProvider tokenProvider) {
    if (tokenProvider.isLoading && tokenProvider.tokens.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (tokenProvider.tokens.isEmpty) {
      return Center(child: Text('No tokens available'));
    }

    return ListView.builder(
      itemCount: tokenProvider.tokens.length,
      itemBuilder: (context, index) {
        final token = tokenProvider.tokens[index];
        return _buildTokenItem(token);
      },
    );
  }

  Widget _buildTokenItem(Token token) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Token icon
          ClipOval(
            child: Container(
              color: Colors.transparent,
              child: Image.network(
                token.image,
                width: 36.0,
                height: 36.0,
              ),
            ),
          ),
          SizedBox(width: 16),
          
          // Token info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  token.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  token.symbol,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${token.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green[700],
                ),
              ),
              Text(
                _formatTimeAgo(token.lastUpdated),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _formatTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}