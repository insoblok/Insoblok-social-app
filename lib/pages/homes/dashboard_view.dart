import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AIColors.appBar.withAlpha(64),
                  automaticallyImplyLeading: false,
                  title: Text('Stories'),
                  pinned: true,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 54.0,
                height: 54.0,
                padding: const EdgeInsets.all(12.0),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 96.0,
                  right: 24.0,
                ),
                decoration: BoxDecoration(
                  color: AIColors.blue,
                  borderRadius: BorderRadius.circular(28.0),
                ),
                child: AIImage(
                  Icons.add,
                  color: Colors.white,
                  width: 28.0,
                  height: 28.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
