import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/token_provider.dart';
import 'package:intl/intl.dart';
import '../models/token_model.dart';

// Keep last seen price per symbol locally to compute simple diffs for the ticker
final Map<String, double> _lastSeenPrices = {};

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
        return _buildTokenItem(token, tokenProvider);
      },
    );
  }

  Widget _buildTokenItem(Token token, TokenProvider provider) {
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
              Builder(
                builder: (context) {
                  final baseStyle = const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  );
                  final String sym = token.symbol.toUpperCase();
                  final int tick = provider.changeTicks[sym] ?? 0;
                  final int dir = provider.directions[sym] ?? 0;
                  final Color startColor = dir > 0
                      ? Colors.greenAccent
                      : (dir < 0 ? Colors.redAccent : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white));
                  final Color endColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;
                  final double startScale = dir > 0 ? 1.06 : (dir < 0 ? 0.94 : 1.0);
                  return KeyedSubtree(
                    key: ValueKey<String>('${sym}_$tick'),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: startScale, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          alignment: Alignment.centerRight,
                          child: TweenAnimationBuilder<Color?>(
                            tween: ColorTween(begin: startColor, end: endColor),
                            duration: const Duration(milliseconds: 900),
                            builder: (context, color, _) {
                              return Text(
                                '\$${_formatWithGroupingKeepDecimals(token.price)}',
                                style: baseStyle.copyWith(color: color),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 2),
              Builder(
                builder: (context) {
                  final String sym = token.symbol.toUpperCase();
                  final int tick = provider.changeTicks[sym] ?? 0;
                  final int dir = provider.directions[sym] ?? 0;
                  final double? diff = _computeAndStoreDiff(sym, token.price);
                  if (diff == null) return const SizedBox.shrink();
                  final bool up = dir > 0;
                  final Color color = up ? Colors.greenAccent : (dir < 0 ? Colors.redAccent : Colors.grey);
                  final String arrow = up ? '▲' : (dir < 0 ? '▼' : '→');
                  final String text = '$arrow ${diff >= 0 ? '+' : ''}${_formatWithGroupingKeepDecimals(diff)}';
                  return KeyedSubtree(
                    key: ValueKey<String>('${sym}_diff_$tick'),
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 600),
                      style: TextStyle(
                        color: color.withOpacity(0.9),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      child: Text(text),
                    ),
                  );
                },
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

  String _formatWithGroupingKeepDecimals(num value) {
    final String s = value.toString();
    if (s == 'NaN' || s == 'Infinity' || s == '-Infinity') return s;
    final parts = s.split('.');
    final String intPart = parts[0];
    final String decPart = parts.length > 1 ? parts[1] : '';
    final bool negative = intPart.startsWith('-');
    final String absInt = negative ? intPart.substring(1) : intPart;
    final String grouped = NumberFormat.decimalPattern('en_US').format(int.parse(absInt));
    final String withSign = negative ? '-$grouped' : grouped;
    return decPart.isNotEmpty ? '$withSign.$decPart' : withSign;
  }

  double? _computeAndStoreDiff(String symbol, double price) {
    final prev = _lastSeenPrices[symbol];
    _lastSeenPrices[symbol] = price;
    if (prev == null) return null;
    return price - prev;
  }
}