import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class VTOImagePage extends StatefulWidget {
  final ProductModel product;

  const VTOImagePage({super.key, required this.product});

  @override
  State<VTOImagePage> createState() => _VTOImagePageState();
}

class _VTOImagePageState extends State<VTOImagePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  bool _showLoadingVideo = false; // Show loading video while generating

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String _getTitleText(VTOImageProvider viewModel) {
    // After video is generated
    if (viewModel.generatedVideoUrl != null &&
        viewModel.generatedVideoUrl!.isNotEmpty) {
      return 'VTO GIF READY';
    }

    // After conversion (result image ready)
    if (viewModel.serverUrl != null) {
      return 'VTO GIF GENERATING';
    }

    // After photo selected but before conversion
    if (viewModel.selectedFile != null && viewModel.serverUrl == null) {
      if (viewModel.isConverting) {
        return 'APPLYING MODEL';
      }
      return 'READY TO APPLY\nMODEL';
    }

    // Before selecting photo
    return 'SELECT YOUR PHOTO\nTO TRY ON';
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VTOImageProvider>.reactive(
      viewModelBuilder: () => VTOImageProvider(),
      onViewModelReady:
          (viewModel) => viewModel.init(context, p: widget.product),
      builder: (context, viewModel, _) {
        // Show loading video when converting starts
        if (viewModel.isConverting && !_showLoadingVideo) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _showLoadingVideo = true;
              });
            }
          });
        }

        // Hide loading video when video is ready
        if (viewModel.generatedVideoUrl != null &&
            viewModel.generatedVideoUrl!.isNotEmpty &&
            _showLoadingVideo) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _showLoadingVideo = false;
              });
            }
          });
        }

        final Color bgTop = const Color(0xFF0B0C1E);
        final Color bgBottom = const Color(0xFF05060F);
        final List<Color> glow = [
          const Color(0xFF00C2FF),
          const Color(0xFF7A00F8),
          const Color(0xFFFF2DAE),
        ];

        return Scaffold(
          backgroundColor: bgBottom,
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bgTop, bgBottom],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    _getTitleText(viewModel),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Glowing bubble with content
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer rotating glow ring
                        RotationTransition(
                          turns: _rotationController,
                          child: Container(
                            width: 340,
                            height: 340,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: SweepGradient(
                                colors: glow,
                                stops: const [0.0, 0.55, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: glow[0].withOpacity(0.25),
                                  blurRadius: 48,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Inner content: result image, selected photo, or product image
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child:
                              // Show video if available (highest priority)
                              viewModel.generatedVideoUrl != null &&
                                      viewModel.generatedVideoUrl!.isNotEmpty
                                  ? VideoPlayerWidget(
                                    key: ValueKey(viewModel.generatedVideoUrl),
                                    path: viewModel.generatedVideoUrl!,
                                    border: Colors.transparent,
                                    circular: true,
                                    radius: 280,
                                  )
                                  // Show loading video while converting
                                  : (viewModel.isConverting ||
                                          _showLoadingVideo) &&
                                      (viewModel.generatedVideoUrl == null ||
                                          viewModel.generatedVideoUrl!.isEmpty)
                                  ? ClipOval(
                                    clipBehavior: Clip.antiAlias,
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: VideoPlayerWidget(
                                        key: const ValueKey('loading_video'),
                                        path: 'assets/videos/loading1.mp4',
                                        border: Colors.transparent,
                                        circular: true,
                                        radius: 280,
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                  )
                                  // Show result image if available
                                  : viewModel.serverUrl != null
                                  ? AIImage(
                                    viewModel.serverUrl!,
                                    width: 280,
                                    height: 280,
                                    fit: BoxFit.cover,
                                  )
                                  // Show selected marketplace model
                                  : viewModel.selectedMarketplaceProduct != null
                                  ? AIImage(
                                    viewModel
                                        .selectedMarketplaceProduct!
                                        .modelImage,
                                    width: 280,
                                    height: 280,
                                    fit: BoxFit.cover,
                                  )
                                  // Show default product model
                                  : AIImage(
                                    viewModel.product.modelImage,
                                    width: 280,
                                    height: 280,
                                    fit: BoxFit.cover,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Add Photo section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      height: 86,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white12, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // Photo selection area
                          GestureDetector(
                            onTap: viewModel.onClickAddPhoto,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      viewModel.selectedFile != null
                                          ? Colors.white
                                          : Colors.white38,
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child:
                                    viewModel.selectedFile != null &&
                                            File(
                                              viewModel.selectedFile!.path,
                                            ).existsSync()
                                        ? Image.file(
                                          File(viewModel.selectedFile!.path),
                                          key: ValueKey(
                                            viewModel.selectedFile!.path,
                                          ),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return IconButton(
                                              icon: const Icon(
                                                Icons.add_a_photo,
                                                color: Colors.white70,
                                              ),
                                              onPressed:
                                                  viewModel.onClickAddPhoto,
                                            );
                                          },
                                        )
                                        : IconButton(
                                          icon: const Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white70,
                                          ),
                                          onPressed: viewModel.onClickAddPhoto,
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Marketplace models horizontal scrollable list
                          Expanded(
                            child:
                                viewModel.marketplaceProducts.isEmpty
                                    ? Center(
                                      child: Text(
                                        'Loading models...',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                    : ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          viewModel.marketplaceProducts.length,
                                      separatorBuilder:
                                          (_, __) => const SizedBox(width: 15),
                                      itemBuilder: (context, index) {
                                        final marketplaceProduct =
                                            viewModel
                                                .marketplaceProducts[index];
                                        final isSelected =
                                            viewModel
                                                .selectedMarketplaceModelIndex ==
                                            index;
                                        final modelImage =
                                            marketplaceProduct.modelImage;
                                        // Color cycle: yellow, blue, purple for unselected items
                                        final List<Color> unselectedColors = [
                                          Colors.yellow,
                                          Colors.blue,
                                          Colors.purple,
                                        ];
                                        final Color borderColor =
                                            isSelected
                                                ? Colors.white
                                                : unselectedColors[index %
                                                    unselectedColors.length];
                                        return GestureDetector(
                                          onTap:
                                              () =>
                                                  viewModel
                                                          .selectedMarketplaceModelIndex =
                                                      index,
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white10,
                                              border: Border.all(
                                                color: borderColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child:
                                                  modelImage != null &&
                                                          modelImage.isNotEmpty
                                                      ? AIImage(
                                                        modelImage,
                                                        width: 48,
                                                        height: 48,
                                                        fit: BoxFit.cover,
                                                      )
                                                      : Container(
                                                        color: Colors.grey,
                                                        child: Icon(
                                                          Icons.image,
                                                          color: Colors.white70,
                                                          size: 24,
                                                        ),
                                                      ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                          ),
                          IconButton(
                            icon: AIImage(
                              AIImages.icMarketplace,
                              width: 24,
                              height: 24,
                              color: Colors.white70,
                            ),
                            onPressed:
                                () => Routers.goToMarketPlacePage(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Apply button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Builder(
                      builder: (context) {
                        final bool hasVideo =
                            viewModel.generatedVideoUrl != null &&
                            viewModel.generatedVideoUrl!.isNotEmpty;
                        final bool canApply =
                            viewModel.selectedFile != null &&
                            !viewModel.isConverting;

                        final String buttonText = 'Apply Model';

                        if (hasVideo) {
                          // Show Post to Lookbook button when video is ready
                          return GradientPillButton(
                            text: buttonText,
                            onPressed:
                                viewModel.isBusy
                                    ? null
                                    : () => viewModel.postVideoToLookbook(),
                            height: 48,
                            radius: 12,
                            loading: viewModel.isBusy,
                            loadingText: buttonText,
                          );
                        } else if (canApply) {
                          return GradientPillButton(
                            text: buttonText,
                            onPressed:
                                viewModel.isBusy
                                    ? null
                                    : () => viewModel.onClickConvert(),
                            height: 48,
                            radius: 12,
                            loading: viewModel.isConverting,
                            loadingText: buttonText,
                          );
                        } else {
                          return TextFillButton(
                            onTap: () => viewModel.onClickConvert(),
                            isBusy: viewModel.isConverting,
                            height: 48,
                            color: Colors.grey,
                            text: buttonText,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VTOInformationView extends ViewModelWidget<VTOImageProvider> {
  const VTOInformationView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Text(viewModel.product.categoryName ?? ''),
            ),
            const Spacer(),
            Text(
              viewModel.product.timestamp?.timeago ?? '',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        if ((viewModel.product.tags ?? []).isNotEmpty) ...{
          const SizedBox(height: 12.0),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: [
              for (var tag in viewModel.product.tags ?? []) ...{
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 0.66,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              },
            ],
          ),
        },
        // const SizedBox(height: 12.0),
        // AIHelpers.htmlRender(viewModel.product.description),
      ],
    );
  }
}
