import 'package:flutter/material.dart';
import 'package:qr_flutter_wc/qr_flutter_wc.dart';

class WalletQrDisplay extends StatelessWidget {
  final String data;          // usually wallet address
  final double size;          // QR size
  final String? title;        // optional title text
  final String? subtitle;     // optional subtitle (e.g. wallet address)
  final Color backgroundColor;

  const WalletQrDisplay({
    Key? key,
    required this.data,
    this.size = 220,
    this.title,
    this.subtitle,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: size,
            gapless: false,
            errorStateBuilder: (context, err) =>
                const Center(child: Text("Error generating QR")),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          SelectableText(
            subtitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
