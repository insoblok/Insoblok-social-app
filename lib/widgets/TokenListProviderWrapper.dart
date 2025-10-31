import 'package:flutter/material.dart';
import 'package:insoblok/providers/token_provider.dart';
import 'package:insoblok/widgets/token_list_widget.dart';
import 'package:provider/provider.dart';

class TokenListProviderWrapper extends StatelessWidget {
  const TokenListProviderWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // ✅ call initializeTokens() once on creation
      create: (_) => TokenProvider()..initializeTokens(),
      child: const Center(child: TokenListWidget()),
    );
  }
}
