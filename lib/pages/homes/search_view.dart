import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:flutter/services.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final TextEditingController searchTextController = TextEditingController();

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
                  color: AIColors.transparent,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                alignment: Alignment.center,
                child: Text("Search")
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
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 36.0,
                    bottom: 84.0,
                  ),
                  child: Column(
                    children: [
                      AITextField(
                        controller: searchTextController,
                        hintText: "Enter Search Text...",
                        borderColor: Colors.grey,
                      )
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
