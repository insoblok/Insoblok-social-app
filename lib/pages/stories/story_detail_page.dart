import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class StoryDetailPage extends StatelessWidget {
  final StoryModel story;

  const StoryDetailPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoryDetailProvider>.reactive(
      viewModelBuilder: () => StoryDetailProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                StoryHeaderView(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'My Story Title!!',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '2025-4-22 20:15',
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Find & Download Free Graphic Resources for Text Story Template Vectors, Stock Photos & PSD files. ✓ Free for commercial use ✓ High Quality Images.. ✓ Free for commercial use ✓ High Quality Images.',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Favorites (32 Users)',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'View All >',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AIColors.yellow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 2.0,
                        ),
                        child: Row(
                          children: [
                            AddActionCardView(onAdd: () {}),
                            for (var i = 0; i < 10; i++) ...{UserCardView()},
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Follow (47 Users)',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'View All >',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AIColors.yellow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 2.0,
                        ),
                        child: Row(
                          children: [
                            AddActionCardView(onAdd: () {}),
                            for (var i = 0; i < 10; i++) ...{UserCardView()},
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Comment (19 Users)',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'View All >',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AIColors.yellow,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      for (var i = 0; i < 3; i++) ...{
                        const SizedBox(height: 16.0),
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          width: double.infinity,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: AIColors.appScaffoldBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.black26,
                                offset: Offset(2, 2),
                              ),
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.white24,
                                offset: Offset(-2, -2),
                              ),
                            ],
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StoryHeaderView extends ViewModelWidget<StoryDetailProvider> {
  const StoryHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return SizedBox(
      height: 300.0,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: viewModel.images.length,
            options: CarouselOptions(
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              aspectRatio: 3 / 2,
              height: 300.0,
              onPageChanged: (index, reason) {
                viewModel.currentIndex = index;
              },
            ),
            itemBuilder: (context, index, realIdx) {
              return Container(
                width: double.infinity,
                height: 300.0,
                decoration: BoxDecoration(
                  color: AIColors.yellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: AIImage(
                  viewModel.images[index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24.0,
                left: 24.0,
              ),
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: AIImage(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 24.0,
                right: 24.0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${viewModel.currentIndex + 1} / ${viewModel.images.length}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 60.0,
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(
                        Icons.favorite,
                        color: Colors.white,
                        width: 18.0,
                        height: 18.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text('32', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(width: 24.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(
                        Icons.hearing,
                        color: Colors.white,
                        width: 18.0,
                        height: 18.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text('47', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(width: 24.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AIImage(
                        Icons.comment,
                        color: Colors.white,
                        width: 18.0,
                        height: 18.0,
                      ),
                      const SizedBox(width: 4.0),
                      Text('19', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const Spacer(),
                  AIImage(
                    Icons.share,
                    color: Colors.white,
                    width: 18.0,
                    height: 18.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
