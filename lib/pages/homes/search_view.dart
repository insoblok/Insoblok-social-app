import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchProvider>.reactive(
      viewModelBuilder: () => SearchProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: AppLeadingView(),
              title: Container(
                height: 32.0,
                decoration: BoxDecoration(
                  color: AIColors.darkGreyBackground,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AIImage(AIImages.icBottomSearch),
                    const SizedBox(width: 6.0),
                    Text(
                      'Search InSoBlok',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: AIImage(
                    AIImages.icSetting,
                    width: 24.0,
                    height: 24.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  width: double.infinity,
                  height: 48.0,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AIColors.speraterColor,
                        width: 0.33,
                      ),
                      bottom: BorderSide(
                        color: AIColors.speraterColor,
                        width: 0.33,
                      ),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Trends for you',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 36.0,
                    bottom: 84.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'No new trends for you',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'It seems like there’s not a lot to show you right now, but you can see trends for other areas',
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
      },
    );
  }
}
