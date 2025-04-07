import 'package:stacked/stacked.dart';

abstract class InSoBlokViewModel extends ReactiveViewModel {
  // final authService = AuthHelper.service;

  @override
  List<ListenableServiceMixin> get listenableServices => [
        // authService,
      ];
}
