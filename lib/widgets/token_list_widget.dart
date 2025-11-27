import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/token_provider.dart';
import 'package:intl/intl.dart';
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
            Expanded(child: _buildTokenContent(tokenProvider)),
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
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Token ticker only (name and image removed)
          Expanded(
            child: Text(
              token.symbol.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),

          // Price - Horizontal layout
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Current Price
              Builder(
                builder: (context) {
                  final baseStyle = const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  );
                  final String sym = token.symbol.toUpperCase();
                  final int tick = provider.changeTicks[sym] ?? 0;
                  final int dir = provider.directions[sym] ?? 0;
                  final Color startColor = Colors.white;
                  final Color endColor =
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.white;
                  final double startScale =
                      dir > 0 ? 1.06 : (dir < 0 ? 0.94 : 1.0);
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
              const SizedBox(width: 12),
              // Price Difference in colored box
              Builder(
                builder: (context) {
                  final String sym = token.symbol.toUpperCase();
                  final int tick = provider.changeTicks[sym] ?? 0;
                  // Use the diff from provider which is already calculated correctly
                  final double? diff = provider.diffs[sym];

                  // Always show the price difference, even if it's 0 or null
                  final double displayDiff = diff ?? 0.0;
                  final bool isPriceUp = displayDiff > 0;
                  final bool isPriceDown = displayDiff < 0;

                  // Background color for price difference box
                  Color diffBackgroundColor = Colors.grey;
                  if (isPriceUp) {
                    diffBackgroundColor = Colors.green;
                  } else if (isPriceDown) {
                    diffBackgroundColor = Colors.red;
                  }

                  return KeyedSubtree(
                    key: ValueKey<String>('${sym}_diff_$tick'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: diffBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 600),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        child: Text(
                          '${displayDiff >= 0 ? "+" : ""}${_formatPriceDifference(displayDiff)}',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatWithGroupingKeepDecimals(num value) {
    final String s = value.toString();
    if (s == 'NaN' || s == 'Infinity' || s == '-Infinity') return s;
    final parts = s.split('.');
    final String intPart = parts[0];
    final String decPart = parts.length > 1 ? parts[1] : '';
    final bool negative = intPart.startsWith('-');
    final String absInt = negative ? intPart.substring(1) : intPart;
    final String grouped = NumberFormat.decimalPattern(
      'en_US',
    ).format(int.parse(absInt));
    final String withSign = negative ? '-$grouped' : grouped;
    return decPart.isNotEmpty ? '$withSign.$decPart' : withSign;
  }

  String _formatPriceDifference(num value) {
    // Format price difference to 2 decimal places
    if (value.isNaN || value.isInfinite) {
      return value.toString();
    }
    return NumberFormat('#,##0.00', 'en_US').format(value);
  }
}
