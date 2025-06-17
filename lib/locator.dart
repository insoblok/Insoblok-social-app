import 'package:get_it/get_it.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerSingleton(FirebaseService());
  locator.registerSingleton(AuthService());
  locator.registerSingleton(AppSettingService());
  locator.registerSingleton(NetworkService());
  locator.registerSingleton(MediaPickerService());
  locator.registerSingleton(ReownService());

  locator.registerFactory(() => UploadMediaProvider());
}
