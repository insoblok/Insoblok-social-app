import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:insoblok/models/models.dart';
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

  final _productService = ProductService();
  ProductService get productService => _productService;

  Future<void> fetchData() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var ps = await productService.getProducts();
        if (ps.isNotEmpty) {
          _products.clear();
          _products.addAll(ps);
        }
        logger.d(products.length);
      } catch (e) {
        setError(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      Fluttertoast.showToast(msg: modelError.toString());
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
        Fluttertoast.showToast(msg: 'No support this feature yet!');
        break;
    }
  }

  Future<void> onTapAddProduct() async {
    if (isBusy) return;
    clearErrors();

    await Routers.goToVTOAddProduct(context);
    fetchData();
  }
}
