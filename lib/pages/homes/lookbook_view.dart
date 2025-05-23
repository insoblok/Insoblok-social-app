import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class LookbookView extends StatelessWidget {
  const LookbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LookbookProvider>.reactive(
      viewModelBuilder: () => LookbookProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  leading: AppLeadingView(),
                  title: Text('LookBook'),
                  centerTitle: true,
                  pinned: true,
                  actions: [
                    IconButton(
                      onPressed: viewModel.onClickSettingButton,
                      icon: AIImage(
                        AIImages.icSetting,
                        width: 24.0,
                        height: 24.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                if (viewModel.isBusy) ...{
                  SliverFillRemaining(
                    child: Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballSpinFadeLoader,
                          colors: [Theme.of(context).primaryColor],
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                },
                SliverList(
                  delegate: SliverChildListDelegate([
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 20.0,
                    //     vertical: 8.0,
                    //   ),
                    //   child: SizedBox(
                    //     height: 160.0,
                    //     child: Row(
                    //       children: [
                    //         AspectRatio(
                    //           aspectRatio: 0.6,
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(8.0),
                    //             child: Container(
                    //               color: Theme.of(context).primaryColor,
                    //               child: Stack(
                    //                 fit: StackFit.expand,
                    //                 children: [
                    //                   AIAvatarImage(
                    //                     viewModel.user?.avatar,
                    //                     textSize: 36.0,
                    //                     fullname:
                    //                         viewModel.user?.nickId ?? 'Test',
                    //                   ),
                    //                   Align(
                    //                     alignment: Alignment.bottomCenter,
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.only(
                    //                         bottom: 12.0,
                    //                       ),
                    //                       child: Text(
                    //                         'Create Story',
                    //                         style: TextStyle(
                    //                           fontSize: 11.0,
                    //                           color: AIColors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         const SizedBox(width: 8.0),
                    //         Expanded(
                    //           child: SingleChildScrollView(
                    //             scrollDirection: Axis.horizontal,
                    //             child: Row(
                    //               spacing: 8.0,
                    //               children: [
                    //                 for (var i = 0; i < 10; i++) ...{
                    //                   AspectRatio(
                    //                     aspectRatio: 0.6,
                    //                     child: ClipRRect(
                    //                       borderRadius: BorderRadius.circular(
                    //                         8.0,
                    //                       ),
                    //                       child: Container(color: Colors.red),
                    //                     ),
                    //                   ),
                    //                 },
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    ...viewModel.stories.reversed.map((story) {
                      return StoryListCell(story: story);
                    }),
                    const SizedBox(height: 20),
                  ]),
                ),
              ],
            ),
            if (viewModel.isUpdated)
              Padding(
                padding: EdgeInsets.only(
                  top:
                      MediaQuery.of(context).viewInsets.top +
                      40.0 +
                      kToolbarHeight,
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: viewModel.fetchData,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: AIColors.pink,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'New Posts',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomFloatingButton(
                onTap: () => Routers.goToAddStoryPage(context),
                src: AIImages.icAddLogo,
              ),
            ),
            // if (viewModel.isBusy) ...{
            //   SafeArea(
            //     child: Center(
            //       child: SizedBox(
            //         width: 60,
            //         height: 60,
            //         child: LoadingIndicator(
            //           indicatorType: Indicator.ballSpinFadeLoader,
            //           colors: [AIColors.pink],
            //           strokeWidth: 2,
            //         ),
            //       ),
            //     ),
            //   ),
            // },
          ],
        );
      },
    );
  }
}
