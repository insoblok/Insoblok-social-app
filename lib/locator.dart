import 'package:get_it/get_it.dart';

import 'package:aiavatar/services/services.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton(DBService());
  locator.registerSingleton(MetaMaskService());
  locator.registerSingleton(AuthService());

  // locator.registerFactory(() => UploadedImagesVM());
}
