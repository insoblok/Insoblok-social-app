import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insoblok/utils/utils.dart';

class WalletAddressWidget extends StatelessWidget {
  final String address;

  const WalletAddressWidget({Key? key, required this.address}) : super(key: key);

  /// Shorten wallet address like 0x33e5F...75574
  String shortenAddress(String addr) {
    if (addr.length <= 10) return addr;
    return "${addr.substring(0, 6)}...${addr.substring(addr.length - 5)}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shortenAddress(address),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 1),
          IconButton(
            icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: address));
              AIHelpers.showToast(msg: "Address copied to clipboard.");
            },
          ),
        ],
      ),
    );
  }
}
