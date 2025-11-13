class Token {
  Token({
    required this.symbol,
    required this.name,
    required this.price,
    required this.lastUpdated,
    required this.image,
  });

  final String symbol;
  final String name;
  double price;
  DateTime lastUpdated;
  final String image;
}
