import 'package:flutter/material.dart';

class Token {
  final String symbol;
  final String name;
  final String logoUrl;

  Token({required this.symbol, required this.name, required this.logoUrl});
}

class TokenSearch extends StatelessWidget {
  final List<Token> tokens;

  const TokenSearch({super.key, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Token>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Token>.empty();
        }
        return tokens.where((Token token) =>
            token.symbol.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
            token.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      displayStringForOption: (Token token) => "${token.symbol} - ${token.name}",
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Token option = options.elementAt(index);
                  return ListTile(
                    leading: Image.network(option.logoUrl, width: 24, height: 24),
                    title: Text(option.symbol.toUpperCase()),
                    subtitle: Text(option.name),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (Token token) {
        debugPrint('Selected token: ${token.symbol}');
      },
    );
  }
}
