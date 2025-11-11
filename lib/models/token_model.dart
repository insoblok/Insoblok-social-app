class Token {
  Token({
    required this.symbol,
    required this.name,
    required this.price,
    required this.lastUpdated,
    required this.image,
    this.previousPrice,
    this.direction = 0,
    this.changeTick = 0,
  });

  final String symbol;
  final String name;
  double price;
  DateTime lastUpdated;
  final String image;

  // previous tick's price to compute delta
  double? previousPrice;
  // -1: down, 0: flat/unknown, 1: up
  int direction;
  // increments per price change to restart animations
  int changeTick;
}
