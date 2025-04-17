import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Center(
          child: Row(
            children: [
              const SizedBox(width: 32.0),
              Expanded(
                child: OutlineButton(
                  isBusy: viewModel.isBusy,
                  onTap: () => viewModel.onClickTestDemo(),
                  borderColor: AIColors.yellow,
                  child: Text(
                    'Buy 0.1\$ ETH by Metamask',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AIColors.yellow,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32.0),
            ],
          ),
        );
      },
    );
  }
}
