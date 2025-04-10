import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

abstract class InSoBlokViewModel extends ReactiveViewModel {
  final authService = AuthHelper.service;

  UserModel? get user => AuthHelper.user;

  @override
  List<ListenableServiceMixin> get listenableServices => [
        authService,
      ];
}
