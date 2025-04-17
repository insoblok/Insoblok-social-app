import 'package:get_it/get_it.dart';

import 'package:insoblok/services/services.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton(AuthService());
  locator.registerSingleton(FirebaseService());
  locator.registerSingleton(EthereumService());

  // locator.registerFactory(() => UploadedImagesVM());
}
