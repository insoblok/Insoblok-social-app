import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

var kAICategoryMapData = {
  'VTO': [
    {
      'title': 'VTO Clothing',
      'image': AIImages.imgVTOClothing,
      'desc':
          'A mix and match virtual try-on method that takes as input multiple garment images',
    },
    {
      'title': 'VTO Jewelry',
      'image': AIImages.imgVTOJewelry,
      'desc':
          'This repository contains the dataset used in the following papers',
    },
  ],
};

class MarketProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void init(BuildContext context) async {
    this.context = context;

    fetchData();
  }

  final List<VTOGroupModel> vtoGroup = [];

  Future<void> fetchData() async {
    vtoGroup.clear();

    for (var key in kAICategoryMapData.keys) {
      var data = kAICategoryMapData[key];
      List<VTOCellModel> models = [];
      for (var item in data ?? []) {
        var vtoCell = VTOCellModel.fromJson(item);
        models.add(vtoCell);
      }
      var group = VTOGroupModel(name: key, list: models);
      vtoGroup.add(group);
    }

    logger.d(vtoGroup.length);
  }

  Future<void> onTapVTOList(VTOCellModel model) async {
    switch (model.title) {
      case 'VTO Clothing':
        Routers.goToVTOClothingPage(context);
        break;
    }
  }
}
