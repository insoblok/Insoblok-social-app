import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';

class VTODetailPage extends StatelessWidget {
  const VTODetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<VTOImageProvider>();
    logger.d(provider.product.toMap());
    return Scaffold(appBar: AppBar(title: Text('Moments'), centerTitle: true));
  }
}
