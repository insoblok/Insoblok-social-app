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
                  backgroundColor: AIColors.appBar,
                  automaticallyImplyLeading: false,
                  title: Text('Stories'),
                  pinned: true,
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_alt_rounded),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    for (var i = 0; i < 10; i++) ...{
                      Container(
                        margin: const EdgeInsets.only(
                          top: 24.0,
                          right: 24.0,
                          left: 24.0,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AIColors.appScaffoldBackground,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 240.0,
                                child: Stack(
                                  children: [
                                    AIImage(
                                      AIImages.imgBackProfile,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      height: 54.0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 12.0,
                                      ),
                                      color: Colors.black38,
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                            child: AIImage(
                                              AIImages.placehold,
                                              width: 32.0,
                                              height: 32.0,
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name of Owner',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                                          const Spacer(),
                                          Text(
                                            '1 / 4',
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 2.0,
                                              vertical: 8.0,
                                            ),
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          for (var i = 0; i < 3; i++) ...{
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 2.0,
                                                    vertical: 8.0,
                                                  ),
                                              width: 8.0,
                                              height: 8.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          },
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'My Story Title!!',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Find & Download Free Graphic Resources for Text Story Template Vectors, Stock Photos & PSD files. ✓ Free for commercial use ✓ High Quality Images.. ✓ Free for commercial use ✓ High Quality Images.',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12.0),
                                    Row(
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
                                            Text(
                                              '32',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
                                            Text(
                                              '47',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
                                            Text(
                                              '19',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          'More Detail >',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: AIColors.yellow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    },
                    const SizedBox(height: 96.0),
                  ]),
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
