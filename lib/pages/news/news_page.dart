import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewsProvider>.reactive(
      viewModelBuilder: () => NewsProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: AppBackgroundView(
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: Text('News'),
                  centerTitle: true,
                  flexibleSpace: AppBackgroundView(),
                  pinned: true,
                ),
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(child: Center(child: Loader(size: 60))),
                },
                SliverList(
                  delegate: SliverChildListDelegate([
                    for (var news in viewModel.showNewses) ...{
                      NewsListCell(news: news),
                    },
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
