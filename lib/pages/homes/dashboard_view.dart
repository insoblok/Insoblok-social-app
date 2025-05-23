import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
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
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            AISliverAppbar(
              context,
              pinned: true,
              floating: true,
              leading: AppLeadingView(),
              title: Text('Home'),
            ),
            if (viewModel.isBusy) ...{
              SliverFillRemaining(child: Center(child: Loader())),
            },
            if (viewModel.showNewses.isEmpty) ...{
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipOval(
                        child: AIImage(
                          AIImages.placehold,
                          width: 150.0,
                          height: 150.0,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        'News data seems to be not exsited. After\nsome time, Please try again!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            } else ...{
              SliverList(
                delegate: SliverChildListDelegate([
                  for (var news in viewModel.showNewses) ...{
                    NewsListCell(news: news),
                  },
                ]),
              ),
            },
          ],
        );
      },
    );
  }
}
