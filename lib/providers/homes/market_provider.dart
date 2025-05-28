import 'package:flutter/material.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

  final List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  // ProductSubtypeModel itemCategory({int? i}) {
  //   int index = i ?? Random().nextInt(allSubtypes.length);
  //   return allSubtypes[index];
  // }

  // final List<ProductTribeCategoryModel> _tribeCategories = [];
  // List<ProductTribeCategoryModel> get tribeCategories => _tribeCategories;

  // List<ProductSubtypeModel> get allSubtypes {
  //   List<ProductSubtypeModel> result = [];
  //   for (var category in tribeCategories) {
  //     result.addAll(category.subtypes ?? []);
  //   }
  //   return result;
  // }

  final List<ProductModel> _filterProducts = [];
  List<ProductModel> get filterProducts => _filterProducts;

  final _productService = ProductService();
  ProductService get productService => _productService;

  bool _isClickFilter = false;
  bool get isClickFilter => _isClickFilter;
  set isClickFilter(bool f) {
    _isClickFilter = f;
    notifyListeners();
  }

  final List<bool> _selectedTags = [];
  List<bool> get selectedTags => _selectedTags;

  void updateTagSelect(int index) {
    var value = _selectedTags[index];
    _selectedTags[index] = !value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        // _tribeCategories.addAll(await productService.getProductTypes());

        for (var i = 0; i < kProductCategoryNames.length; i++) {
          _selectedTags.add(true);
        }

        var ps = await productService.getProducts();
        if (ps.isNotEmpty) {
          _products.clear();
          _filterProducts.clear();
          _products.addAll(ps);
          _filterProducts.addAll(ps);
        }
        logger.d(products.length);
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> filterData() async {
    if (isBusy) return;
    clearErrors();
    await runBusyFuture(() async {
      List<ProductModel> dataList = [];
      var tags = [];
      for (var i = 0; i < _selectedTags.length; i++) {
        if (_selectedTags[i]) tags.add(kProductCategoryNames[i]);
      }
      for (var i = 0; i < _products.length; i++) {
        if (tags.contains(_products[i].categoryName)) {
          dataList.add(_products[i]);
        }
      }

      _filterProducts.clear();
      _filterProducts.addAll(dataList);
      notifyListeners();
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onTapVTOList(ProductModel product) async {
    switch (product.category) {
      case 'Clothing':
      case 'Shoes':
      case 'Jewelry':
        Routers.goToVTOImagePage(context, product);
        break;
      default:
        AIHelpers.showToast(msg: 'No support this feature yet!');
        break;
    }
  }

  Future<void> onTapAddProduct() async {
    if (isBusy) return;
    clearErrors();

    await Routers.goToVTOAddProduct(context);
    fetchData();
  }

  void onTapFilter() {
    isClickFilter = !isClickFilter;
  }
}
