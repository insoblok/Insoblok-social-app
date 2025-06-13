import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class RewardDetailProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    this.context = context;

    await getUserScore();
  }

  bool _isLoadingScore = false;
  bool get isLoadingScore => _isLoadingScore;
  set isLoadingScore(bool f) {
    _isLoadingScore = f;
    notifyListeners();
  }

  final List<TastescoreModel> _scores = [];

  List<TastescoreModel> get scores =>
      _scores..sort((b, a) {
        var firstTime = a.timestamp ?? DateTime.now();
        var lastTime = b.timestamp ?? DateTime.now();
        return firstTime.difference(lastTime).inSeconds;
      });

  Future<void> getUserScore() async {
    isLoadingScore = true;
    try {
      _scores.clear();
      var s = await tastScoreService.getScoresByUser(user!.uid!);
      _scores.addAll(s);
    } catch (e) {
      setError(e);
      logger.e(e);
    } finally {
      isLoadingScore = false;
    }
  }
}
