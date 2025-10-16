import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/pages/pages.dart';


class RRCAvatarGenerationView extends StatefulWidget {
  final String url;
  final File face;
  const RRCAvatarGenerationView({super.key, required this.face, required this.url});

  @override
  State<RRCAvatarGenerationView> createState() => _RRCAvatarGenerationViewState();
}

class _RRCAvatarGenerationViewState extends State<RRCAvatarGenerationView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("This is url and face ${widget.url}, ${widget.face}");
    return ViewModelBuilder<RRCAvatarGenerationProvider>.reactive(
      viewModelBuilder: () => RRCAvatarGenerationProvider(),
      onViewModelReady: (viewModel) => viewModel.init(widget.url, widget.face),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Avatar Generation'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: viewModel.isBusy ?
                  Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                  decoration: BoxDecoration(
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          AIImage(
                            widget.face, // supports File or String in your project
                            fit: BoxFit.cover,
                                        
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
                          ),
                          if (viewModel.isSelected)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Applying selected avatar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      if (viewModel.isSelected && viewModel.isRunning)
                                      Text(
                                        "${viewModel.TIMER_LENGTH - viewModel.count}", 
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontSize: 36,
                                        )
                                      ),
                                      if (viewModel.result != null) 
                                        CircleAvatar(
                                          radius: MediaQuery.of(context).size.height * 0.15,
                                          backgroundImage: FileImage(viewModel.result!),
                                        ),
                                      // AIImage(
                                      //   viewModel.result!, // supports File or String in your project
                                      //   fit: BoxFit.cover,
                                        
                                      //   width: 300,
                                      //   height: 300,
                                      // )
                                    ],
                                  ),
                              ),
                            )
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          controller: _pageController,
                          itemCount: viewModel.avatarTemplates.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                viewModel.handleTapImage(index - 1);
                              },
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: viewModel.tappedImage == index - 1 ? (viewModel.isSelected ? Colors.green : Colors.red) : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      curve: Curves.easeInOutCubic,
                                      child: index == 0 ? 
                                      Container(
                                        width: MediaQuery.of(context).size.height * 0.1,
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: CircleAvatar(
                                          foregroundImage: AssetImage(AIImages.icCheck2),
                                          backgroundColor: Colors.grey,
                                        ),
                                      ) :
                                      CircleAvatar(
                                        radius: MediaQuery.of(context).size.height * 0.05,
                                        backgroundImage: AssetImage(viewModel.avatarTemplates[index - 1]),
                                      )

                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        )
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: viewModel.togglePost,
                                  child: Row(
                                    children: [
                                      Text("POST"),
                                      SizedBox(width: 4.0),
                                      Icon(viewModel.isPosting ? Icons.arrow_drop_up : Icons.arrow_drop_down)
                                    ],
                                  )
                                )
                              ]
                            ),
                          ),
                          SizedBox(height: 4.0),
                          if(viewModel.isPosting)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.blue.shade500,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text("Add emotions")
                                  )
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.blue.shade500,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text("Post")
                                  )
                                ),

                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.blue.shade500,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text("Save to gallery")
                                  )
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Colors.blue.shade500,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text("Cancel")
                                  )
                                ),
                              ]
                            )
                        ],
                      ),
                      SizedBox(height: 12.0),
                    ],
                  ),
                ),
              )
    );
  }
}

