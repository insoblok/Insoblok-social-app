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
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            AISliverAppbar(
              context,
              pinned: true,
              floating: true,
              leading: AppLeadingView(),
              title: Text('Home'),
              extendWidget: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 8.0,
                  children: [
                    for (var i = 0; i < kDashbordPageTitles.length; i++) ...{
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          border:
                              viewModel.pageIndex == i
                                  ? Border(
                                    bottom: BorderSide(
                                      width: 2.0,
                                      color: AIColors.blue,
                                    ),
                                  )
                                  : null,
                        ),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () => viewModel.pageIndex = i,
                          child: Text(
                            kDashbordPageTitles[i],
                            style:
                                viewModel.pageIndex == i
                                    ? Theme.of(context).textTheme.bodySmall
                                    : Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                for (var news in viewModel.showns) ...{
                  NewsListCell(news: news),
                },
              ]),
            ),
          ],
        );
      },
    );
  }
}
