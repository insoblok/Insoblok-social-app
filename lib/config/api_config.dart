// class ApiConfig {
  // static const String tatumApiKey = 't-68fe5ff12b646d64aa69f200-bd6b9b417b6d4e5c9da4334c';// test net api key
  // static const String tatumApiKey = 't-68fe5ff12b646d64aa69f200-355086d8704d43d7964ef033';// main net api key
  // static const String tatumApiKey = 't-68fe5ff12b646d64aa69f200-3968bb6e2df74c7fa4d491f6';
//   static const String tatumWebSocketUrl = 'wss://ws.tatum.io';
//   static const String tatumBaseUrl = 'https://api.tatum.io';
// }


class ApiConfig {
  // Read from build-time vars for security. Provide via --dart-define
  static const String tatumApiKey =
      String.fromEnvironment('TATUM_API_KEY', defaultValue: 't-68fe5ff12b646d64aa69f200-355086d8704d43d7964ef033');

  static const String tatumBaseUrl =
      String.fromEnvironment('TATUM_BASE_URL', defaultValue: 'https://api.tatum.io');
}
