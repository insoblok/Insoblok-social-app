import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class PageableView extends StatelessWidget {
  const PageableView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return AppBackgroundView(
          child: Stack(
            children: [
              viewModel.isBusy
                  ? Center(child: Loader(size: 60))
                  : PageView.builder(
                    scrollDirection: Axis.vertical,
                    controller: viewModel.pageController,
                    padEnds: false,
                    itemCount: viewModel.stories.length,
                    itemBuilder: (_, index) {
                      return StoryPageableCell(story: viewModel.stories[index]);
                    },
                  ),
              Positioned(
                left: 20.0,
                top: MediaQuery.of(context).padding.top,
                child: AppLeadingView(),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 20.0,
                child: IconButton(
                  onPressed: viewModel.goToAddPost,
                  icon: AIImage(
                    AIImages.icAddLogo,
                    width: 28.0,
                    height: 28.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
