import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';

class PageableView extends StatefulWidget {
  const PageableView({super.key});

  @override
  State<PageableView> createState() => _PageableViewState();
}

class _PageableViewState extends State<PageableView>
    with TickerProviderStateMixin {
  static const double _kTopRowHeight = 40.0;
  static const double _kTabsHeight = 26.0;
  static const double _kGap = 5.0;

  late TabController _tabController;
  final ScrollController _tabScrollController = ScrollController();

  // Long press circle animation state
  Timer? _longPressTimer;
  Timer? _vibrationTimer;
  bool _isLongPressing = false;
  bool _canVibrate = false;
  AnimationController? _circleAnimationController;
  Animation<double>? _circleScaleAnimation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    final menuTitles = ['LookBook', 'Marketplace'];
    // Start with index 0 but we'll handle visual state based on viewModel.tabIndex
    _tabController = TabController(
      length: menuTitles.length,
      vsync: this,
      initialIndex: 0,
    );

    // Initialize circle animation controller
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _circleScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _circleAnimationController!,
        curve: Curves.easeOut,
      ),
    );
  }

  void _startLongPress(
    TapDownDetails details,
    DashboardProvider viewModel,
  ) async {
    if (_isLongPressing) return;

    // Check if tap is in bottom 30% of screen
    final screenSize = MediaQuery.of(context).size;
    final tapPosition = details.globalPosition;
    final bottom30PercentStart = screenSize.height * 0.6;

    if (tapPosition.dy < bottom30PercentStart) {
      debugPrint(
        '🚫 RRC trigger blocked: tap at ${tapPosition.dy}px is not in bottom 30% (${bottom30PercentStart}px+)',
      );
      return;
    }

    debugPrint(
      '✅ RRC trigger allowed: tap at ${tapPosition.dy}px is in bottom 30%',
    );

    // Check if current story allows RRC (not user's own story)
    final currentPage = viewModel.pageController.page?.round() ?? 0;
    if (currentPage >= 0 && currentPage < viewModel.stories.length) {
      final currentStory = viewModel.stories[currentPage];
      final user = AuthHelper.user;
      if (currentStory.userId == user?.id) {
        // Can't react to own story
        return;
      }
    }

    _isLongPressing = true;
    _tapPosition = details.globalPosition;

    if (mounted) {
      setState(() {});
    }

    debugPrint('🎯 Long press started at position: $_tapPosition');

    // Check if device is capable of haptic feedback
    _canVibrate = await Haptics.canVibrate();
    debugPrint('📳 Vibration check: canVibrate = $_canVibrate');

    if (_canVibrate) {
      debugPrint('✅ Starting continuous vibration for 2 seconds...');
      _vibrationTimer?.cancel();
      int vibrationCount = 0;
      _vibrationTimer = Timer.periodic(const Duration(milliseconds: 100), (
        timer,
      ) async {
        if (mounted && _isLongPressing && _canVibrate) {
          vibrationCount++;
          try {
            await Haptics.vibrate(HapticsType.light);
            if (vibrationCount % 10 == 0) {
              debugPrint('📳 Vibration pulse #$vibrationCount');
            }
          } catch (e) {
            debugPrint('❌ Vibration error: $e');
          }
        } else {
          timer.cancel();
        }
      });
    }

    // Start circle animation
    _circleAnimationController?.forward(from: 0.0);

    _longPressTimer?.cancel();
    _longPressTimer = Timer(const Duration(seconds: 2), () async {
      if (mounted && _isLongPressing) {
        _vibrationTimer?.cancel();
        debugPrint('📳 Stopped continuous vibration');

        if (_canVibrate) {
          try {
            debugPrint('📳 Final heavy vibration');
            await Haptics.vibrate(HapticsType.heavy);
          } catch (e) {
            debugPrint('❌ Final vibration error: $e');
          }
        }

        // Trigger RRC for current story
        final currentPage = viewModel.pageController.page?.round() ?? 0;
        if (currentPage >= 0 && currentPage < viewModel.stories.length) {
          final currentStory = viewModel.stories[currentPage];
          final sortedMedias = _getSortedMedias(currentStory.medias ?? []);
          if (sortedMedias.isNotEmpty) {
            Routers.goToRRCAvatarGeneration(
              context,
              origin: "dashboard",
              storyID: currentStory.id,
              url: sortedMedias[0].link,
            );
          }
        }

        _isLongPressing = false;
        _circleAnimationController?.reset();
        _tapPosition = null;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void _cancelLongPress() {
    _isLongPressing = false;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _vibrationTimer?.cancel();
    _vibrationTimer = null;
    _circleAnimationController?.reset();
    _tapPosition = null;
    debugPrint('📳 Long press cancelled - vibration stopped');
    if (mounted) {
      setState(() {});
    }
  }

  void _cleanupLongPress() {
    _isLongPressing = false;
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _vibrationTimer?.cancel();
    _vibrationTimer = null;
    _circleAnimationController?.reset();
    _tapPosition = null;
  }

  List<MediaStoryModel> _getSortedMedias(List<MediaStoryModel> medias) {
    final List<MediaStoryModel> videos = [];
    final List<MediaStoryModel> images = [];

    for (var media in medias) {
      if (media.type == 'video') {
        videos.add(media);
      } else {
        images.add(media);
      }
    }

    return [...videos, ...images];
  }

  @override
  void dispose() {
    _cleanupLongPress();
    _circleAnimationController?.dispose();
    _tabController.dispose();
    _tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuTitles = [
      // 'Following',
      'LookBook',
      // 'Leaderboard',
      'Marketplace',
    ];

    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return AppBackgroundView(
          child: GestureDetector(
            onTapDown: (details) => _startLongPress(details, viewModel),
            onTapUp: (_) => _cancelLongPress(),
            onTapCancel: () => _cancelLongPress(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ==== CONTENT ====
                viewModel.isBusy
                    ? const Center(child: Loader(size: 60))
                    : PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: viewModel.pageController,
                      padEnds: false,
                      itemCount: viewModel.stories.length,
                      itemBuilder: (_, index) {
                        viewModel.handleChangeStory(index);
                        return _StoryWithHorizontalSwipe(
                          story: viewModel.stories[index],
                          enableDetail: true,
                          enableReaction: true,
                          marginBottom:
                              56 + MediaQuery.of(context).padding.bottom,
                        );
                      },
                    ),

                // ==== GROWING CIRCLE OVERLAY ====
                if (_isLongPressing && _tapPosition != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: RepaintBoundary(
                        child: AnimatedBuilder(
                          animation:
                              _circleScaleAnimation ??
                              const AlwaysStoppedAnimation(0.0),
                          builder: (context, child) {
                            // Get device pixel ratio for accurate cm to pixel conversion
                            final devicePixelRatio =
                                MediaQuery.of(context).devicePixelRatio;
                            // 1 cm ≈ 37.8 logical pixels at 160 dpi
                            final cmToPixels = 37.8 * (devicePixelRatio / 2.0);

                            // Convert cm to pixels
                            // Minimum diameter: 0.2 cm, Maximum diameter: 1.0 cm (smaller)
                            final minRadiusCm = 0.1; // 0.2 cm diameter / 2
                            final maxRadiusCm = 0.7; // 1.0 cm diameter / 2
                            final minRadiusPixels = minRadiusCm * cmToPixels;
                            final maxRadiusPixels = maxRadiusCm * cmToPixels;
                            final currentRadius =
                                minRadiusPixels +
                                (maxRadiusPixels - minRadiusPixels) *
                                    (_circleScaleAnimation?.value ?? 0.0);

                            // Convert global position to local position
                            final RenderBox? renderBox =
                                context.findRenderObject() as RenderBox?;
                            final localPosition =
                                renderBox != null
                                    ? renderBox.globalToLocal(_tapPosition!)
                                    : _tapPosition!;

                            debugPrint(
                              '🎯 Rendering circle: radius=$currentRadius, position=$localPosition, progress=${_circleScaleAnimation?.value ?? 0.0}',
                            );

                            return Stack(
                              children: [
                                // Position the circle centered at the tap point
                                Positioned(
                                  left: localPosition.dx - currentRadius,
                                  top: localPosition.dy - currentRadius,
                                  child: Container(
                                    width: currentRadius * 2,
                                    height: currentRadius * 2,
                                    decoration: BoxDecoration(
                                      // Use grey color with opacity for subtle appearance
                                      color: Colors.grey.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                      // Add very blurry shadow for soft appearance
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          blurRadius: 40,
                                          spreadRadius: 15,
                                        ),
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 60,
                                          spreadRadius: 20,
                                        ),
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 80,
                                          spreadRadius: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                // ==== TOP BAR (transparent) ====
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- Logo + Search row ---
                        SafeArea(
                          child: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: AIImage(
                                    AIImages.icCoinInso,
                                    width: 28,
                                    height: 28,
                                  ),
                                ),
                                const SizedBox(width: 0),
                                Expanded(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    child:
                                        viewModel.showSearch
                                            ? Container(
                                              key: const ValueKey('search-on'),
                                              height: _kTopRowHeight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 0,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withAlpha(16),
                                                border: BoxBorder.all(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              alignment: Alignment.centerLeft,
                                              child: TextField(
                                                controller:
                                                    viewModel.searchController,
                                                focusNode:
                                                    viewModel.searchFocusNode,
                                                autofocus: true,
                                                onChanged:
                                                    viewModel.onSearchChanged,
                                                onSubmitted:
                                                    viewModel.onSearchSubmitted,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AIColors.white,
                                                ),
                                                cursorColor:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  hintText:
                                                      'Search for people and groups',
                                                  hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: AIColors.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                      ),
                                                  prefixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          12,
                                                        ),
                                                    child: AIImage(
                                                      AIImages.icBottomSearch,
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                  ),
                                                  suffixIcon:
                                                      viewModel
                                                              .searchController
                                                              .text
                                                              .isNotEmpty
                                                          ? IconButton(
                                                            tooltip: 'Clear',
                                                            splashRadius: 18,
                                                            icon: Icon(
                                                              Icons.close,
                                                              size: 18,
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .secondary,
                                                            ),
                                                            onPressed: () {
                                                              viewModel
                                                                  .clearSearch();
                                                              viewModel
                                                                  .searchFocusNode
                                                                  .requestFocus();
                                                            },
                                                          )
                                                          : null,
                                                ),
                                              ),
                                            )
                                            : SizedBox(
                                              height: _kTabsHeight,
                                              child: Scrollbar(
                                                controller:
                                                    _tabScrollController,
                                                thumbVisibility:
                                                    true, // Make scrollbar visible
                                                child: SingleChildScrollView(
                                                  controller:
                                                      _tabScrollController,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const BouncingScrollPhysics(), // Better scrolling feel
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width -
                                                        80,
                                                    child: Builder(
                                                      builder: (context) {
                                                        // Sync TabController with viewModel.tabIndex
                                                        if (viewModel
                                                                    .tabIndex >=
                                                                0 &&
                                                            _tabController
                                                                    .index !=
                                                                viewModel
                                                                    .tabIndex) {
                                                          WidgetsBinding
                                                              .instance
                                                              .addPostFrameCallback((
                                                                _,
                                                              ) {
                                                                if (mounted &&
                                                                    viewModel
                                                                            .tabIndex >=
                                                                        0) {
                                                                  _tabController
                                                                      .animateTo(
                                                                        viewModel
                                                                            .tabIndex,
                                                                      );
                                                                }
                                                              });
                                                        }

                                                        return TabBar(
                                                          controller:
                                                              _tabController,
                                                          onTap: (i) {
                                                            viewModel.tabIndex =
                                                                i;
                                                            viewModel
                                                                .onClickMenuItem(
                                                                  i,
                                                                );
                                                          },
                                                          isScrollable: true,
                                                          tabAlignment:
                                                              TabAlignment
                                                                  .center,
                                                          indicatorSize:
                                                              TabBarIndicatorSize
                                                                  .label,
                                                          indicatorColor:
                                                              Colors
                                                                  .transparent,
                                                          indicator:
                                                              viewModel.tabIndex >=
                                                                      0
                                                                  ? BoxDecoration(
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                          180,
                                                                        ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          12,
                                                                        ),
                                                                  )
                                                                  : null, // No indicator when no tab selected
                                                          dividerColor:
                                                              Colors
                                                                  .transparent,
                                                          dividerHeight: 0,
                                                          labelPadding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 4,
                                                                vertical: 0,
                                                              ),
                                                          overlayColor:
                                                              MaterialStateProperty.all(
                                                                Colors
                                                                    .transparent,
                                                              ),
                                                          labelColor:
                                                              viewModel.tabIndex >=
                                                                      0
                                                                  ? Colors.white
                                                                  : Colors.white
                                                                      .withOpacity(
                                                                        0.7,
                                                                      ),
                                                          unselectedLabelColor:
                                                              Colors.white
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                          labelStyle: Theme.of(
                                                                context,
                                                              )
                                                              .textTheme
                                                              .headlineMedium
                                                              ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                              ),
                                                          tabs: [
                                                            for (
                                                              int i = 0;
                                                              i <
                                                                  menuTitles
                                                                      .length;
                                                              i++
                                                            )
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12.0,
                                                                      ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          1.0,
                                                                    ),
                                                                child: Tab(
                                                                  text:
                                                                      menuTitles[i],
                                                                ),
                                                              ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Live button removed per request
                                InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: AIImage(
                                    AIImages.icSetting,
                                    width: 18,
                                    height: 18,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: _kGap),

                        // --- Text tabs with rounded underline ---
                      ],
                    ),
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

/// Wrapper widget that adds horizontal swipe gesture for media navigation
class _StoryWithHorizontalSwipe extends StatefulWidget {
  final StoryModel story;
  final bool? enableDetail;
  final bool? enableReaction;
  final double? marginBottom;

  const _StoryWithHorizontalSwipe({
    required this.story,
    this.enableDetail,
    this.enableReaction,
    this.marginBottom,
  });

  @override
  State<_StoryWithHorizontalSwipe> createState() =>
      _StoryWithHorizontalSwipeState();
}

class _StoryWithHorizontalSwipeState extends State<_StoryWithHorizontalSwipe> {
  late PageController _mediaPageController;
  int _currentMediaIndex = 0;

  @override
  void initState() {
    super.initState();
    _mediaPageController = PageController();
  }

  List<MediaStoryModel> _getSortedMedias(List<MediaStoryModel> medias) {
    final List<MediaStoryModel> videos = [];
    final List<MediaStoryModel> images = [];

    for (var media in medias) {
      if (media.type == 'video') {
        videos.add(media);
      } else {
        images.add(media);
      }
    }

    return [...videos, ...images];
  }

  void _navigateToPreviousMedia() {
    if (_mediaPageController.hasClients && _currentMediaIndex > 0) {
      _mediaPageController.animateToPage(
        _currentMediaIndex - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToNextMedia() {
    final sortedMedias = _getSortedMedias(widget.story.medias ?? []);
    if (_mediaPageController.hasClients &&
        _currentMediaIndex < sortedMedias.length - 1) {
      _mediaPageController.animateToPage(
        _currentMediaIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedMedias = _getSortedMedias(widget.story.medias ?? []);

    // If story has only one media, no need for swipe navigation
    if (sortedMedias.length <= 1) {
      return StoryListCell(
        story: widget.story,
        enableDetail: widget.enableDetail,
        enableReaction: widget.enableReaction,
        marginBottom: widget.marginBottom,
      );
    }

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Detect swipe direction
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0) {
            // Swipe right - go to previous media
            _navigateToPreviousMedia();
          } else if (details.primaryVelocity! < 0) {
            // Swipe left - go to next media
            _navigateToNextMedia();
          }
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // Listen to page changes to update current index
          if (notification is ScrollUpdateNotification &&
              _mediaPageController.hasClients) {
            final page = _mediaPageController.page?.round();
            if (page != null && page != _currentMediaIndex) {
              setState(() {
                _currentMediaIndex = page;
              });
            }
          }
          return false;
        },
        child: StoryListCell(
          story: widget.story,
          enableDetail: widget.enableDetail,
          enableReaction: widget.enableReaction,
          marginBottom: widget.marginBottom,
          externalMediaPageController: _mediaPageController,
        ),
      ),
    );
  }
}

/// Rounded underline indicator for TabBar (like your screenshot)
class RoundedUnderlineTabIndicator extends Decoration {
  final double thickness;
  final double radius;
  final EdgeInsetsGeometry insets;
  final Gradient? gradient;
  final Color color;

  const RoundedUnderlineTabIndicator({
    this.thickness = 4,
    this.radius = 4,
    this.insets = EdgeInsets.zero,
    this.gradient,
    this.color = const Color(0xFFF30C6C),
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedUnderlinePainter(
      thickness: thickness,
      radius: radius,
      insets: insets,
      gradient: gradient,
      color: color,
    );
  }
}

class _RoundedUnderlinePainter extends BoxPainter {
  final double thickness;
  final double radius;
  final EdgeInsetsGeometry insets;
  final Gradient? gradient;
  final Color color;

  _RoundedUnderlinePainter({
    required this.thickness,
    required this.radius,
    required this.insets,
    required this.gradient,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (cfg.size == null) return;

    final Rect rect = offset & cfg.size!;
    final EdgeInsets resolved = insets.resolve(cfg.textDirection);
    final Rect indicator = Rect.fromLTWH(
      rect.left + resolved.left,
      rect.bottom - thickness - resolved.bottom,
      rect.width - resolved.horizontal,
      thickness,
    );

    final RRect rrect = RRect.fromRectAndRadius(
      indicator,
      Radius.circular(radius),
    );
    final Paint paint = Paint()..style = PaintingStyle.fill;

    if (gradient != null) {
      paint.shader = gradient!.createShader(indicator);
    } else {
      paint.color = color;
    }
    canvas.drawRRect(rrect, paint);
  }
}

class TopSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      // <-- fill the available width & fixed height from parent
      child: Container(
        // optional left/right padding to match page gutters
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(16),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            AIImage(AIImages.icBottomSearch, width: 14, height: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search for people and groups',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: AIColors.greyTextColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
