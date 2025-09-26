import 'package:flutter/material.dart';

class SparkLineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final bool showArea;
  final double strokeWidth;
  final double width;
  final double height;
  final bool showYLabel;

  const SparkLineChart({
    super.key,
    required this.data,
    required this.color,
    this.showArea = true,
    this.strokeWidth = 1.5,
    this.width = 300,
    this.height = 200,
    this.showYLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          data: data,
          color: color,
          showArea: showArea,
          strokeWidth: strokeWidth,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          showYLabel: showYLabel
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final bool showArea;
  final double strokeWidth;
  final TextStyle textStyle;
  final bool showYLabel;

  _SparklinePainter({
    required this.data,
    required this.color,
    this.showArea = true,
    this.strokeWidth = 1.5,
    required this.textStyle,
    this.showYLabel = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) {
      _drawEmptyState(canvas, size);
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final areaPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    final areaPath = Path();

    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final valueRange = maxValue - minValue;

    // Handle flat data
    final effectiveRange = valueRange == 0 ? 1 : valueRange;
    final pointWidth = size.width / (data.length - 1);

    // Start paths
    final firstY = size.height - ((data[0] - minValue) / effectiveRange * size.height);
    path.moveTo(0, firstY);
    areaPath.moveTo(0, firstY);

    // Draw sparkline
    for (int i = 1; i < data.length; i++) {
      final x = i * pointWidth;
      final y = size.height - ((data[i] - minValue) / effectiveRange * size.height);

      path.lineTo(x, y);
      areaPath.lineTo(x, y);
    }

    // Close fill area
    if (showArea) {
      areaPath.lineTo(size.width, size.height);
      areaPath.lineTo(0, size.height);
      areaPath.close();
      canvas.drawPath(areaPath, areaPaint);
    }

    // Draw the line
    canvas.drawPath(path, paint);
    if(!showYLabel) return;
    // --- Draw Y-axis labels ---
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    const steps = 4; // 4 intervals → 5 labels
    for (int i = 0; i <= steps; i++) {
      final value = maxValue - (valueRange / steps) * i;
      final y = (size.height / steps) * i;


      final textSpan = TextSpan(
        text: value.toStringAsFixed(2), // format numbers
        style: textStyle,
      );
      textPainter.text = textSpan;
      textPainter.layout();
      
      // Draw labels on the right edge
      textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width, y - textPainter.height / 2),
      );
    }
  }

  void _drawEmptyState(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.showArea != showArea ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
