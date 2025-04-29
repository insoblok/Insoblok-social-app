extension IntExt on int {
  String get socialValue {
    if (this < 10) return '$this';
    if (this < 20) return '10+';
    if (this < 50) return '20+';
    if (this < 100) return '50+';
    if (this < 200) return '100+';
    if (this < 500) return '200+';
    if (this < 1000) return '500+';
    if (this < 1000000) return '${(this / 1000).toStringAsFixed(1)}K+';
    return '${(this / 1000000).toStringAsFixed(1)}M+';
  }
}
