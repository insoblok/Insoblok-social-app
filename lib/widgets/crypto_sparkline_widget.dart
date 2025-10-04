import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';

class CryptoSparklineWidget extends StatefulWidget {
  final String symbol;
  final double? width;
  final double? height;
  final String? interval;
  final int? limit;
  final bool? showYLabel;
  final List<double>? data;
  final bool? increased;
  const CryptoSparklineWidget({
    super.key,
    required this.symbol,
    this.width = 100,
    this.height = 40,
    this.interval="1h",
    this.limit = 24,
    this.showYLabel = true,
    this.data,
    this.increased,
  });

  @override
  _CryptoSparklineState createState() => _CryptoSparklineState();
}

class _CryptoSparklineState extends State<CryptoSparklineWidget> {
  List<double> _priceData = [];
  bool _isLoading = true;
  double _changePercent = 0;

  @override
  void initState() {
    super.initState();
    _fetchSparklineData();
  }

  Future<void> _fetchSparklineData() async {
    try {
      List<double> prices = [];
      if (widget.data == null || (widget.data ?? []).isEmpty) {
        final response = await http.get(
          Uri.parse('https://testnet.binancefuture.com/fapi/v1/klines?symbol=${widget.symbol}&interval=${widget.interval}&limit=${widget.limit}'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          prices = data.map<double>((item) => double.parse(item[4].toString())).toList();
        }
      }
      else {
        prices = widget.data ?? [];
      }
        
        // Get current price and change
        
      setState(() {
        _priceData = prices;
        _isLoading = false;
      });
    } catch (e) {
      logger.d('Error fetching sparkline data: $e');
      setState(() => _isLoading = false);
    }
  }

  Color _getChartColor() {
    if (widget.increased ?? false) {
      return Colors.green;
    } else {
      return Colors.red;
    }
    // return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.symbol.isEmpty 
                ? Opacity(
                    opacity: 0
                  )
                : _isLoading
                  ? Container(
                      width: widget.width,
                      height: widget.height,
                      child: Center(child: Loader(size: 60)),
                    )
                  : SparkLineChart(
                      data: _priceData,
                      width: widget.width!,
                      height: widget.height!,
                      color: _getChartColor(),
                      showYLabel: widget.showYLabel!,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}