import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/widgets/widgets.dart';

class PageableView extends StatelessWidget {
  const PageableView({super.key});

  // Gradient used for the underline
  static const LinearGradient _pinkPurple = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF30C6C), Color(0xFFC739EB)],
  );

  static const double _kTopRowHeight = 40.0;
  static const double _kTabsHeight   = 40.0;
  static const double _kGap          = 5.0;
  @override
  Widget build(BuildContext context) {
    final menuTitles = [
      'Following',   
      'LookBook',
      'Leaderboard',
      'Marketplace',
    ];
    final ScrollController _tabScrollController = ScrollController();

    return ViewModelBuilder<DashboardProvider>.reactive(
      viewModelBuilder: () => DashboardProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        final safeTop = MediaQuery.of(context).padding.top;

        return AppBackgroundView(
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
                        return StoryListCell(
                          story: viewModel.stories[index],
                          enableDetail: true,
                          enableReaction: true,
                          marginBottom:
                              56 + MediaQuery.of(context).padding.bottom,
                        );
                      },
                    ),

              // ==== TOP BAR (transparent) ====
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: safeTop, left: 12, right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- Logo + Search row ---
                      SizedBox(
                        height: _kTopRowHeight,
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
                            SizedBox(
  height: _kTabsHeight,
  child: DefaultTabController(
    length: menuTitles.length,
    initialIndex: viewModel.tabIndex.clamp(0, menuTitles.length - 1),
    child: Scrollbar(
      controller: _tabScrollController,
      thumbVisibility: true, // Make scrollbar visible
      child: SingleChildScrollView(
        controller: _tabScrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // Better scrolling feel
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 80, // You need to calculate this
          child: TabBar(
            onTap: (i) {
              viewModel.tabIndex = i;
              viewModel.onClickMenuItem(i);
            },
            isScrollable: true, // Disable TabBar's built-in scrolling
            tabAlignment: TabAlignment.center,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: RoundedUnderlineTabIndicator(
              thickness: 6,
              radius: 6,
              insets: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
              gradient: _pinkPurple,
            ),
            dividerColor: Colors.transparent,
            dividerHeight: 0,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            labelStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            tabs: [
              for (final t in menuTitles) Tab(text: t),
            ],
          ),
        ),
      ),
    ),
  ),
),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: viewModel.showSearch
                                    ? Container(
                                        key: const ValueKey('search-on'),
                                        height: _kTopRowHeight,
                                        padding: const EdgeInsets.symmetric(horizontal: 0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(16),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: TextField(
                                          controller: viewModel.searchController,
                                          focusNode: viewModel.searchFocusNode,
                                          autofocus: true,
                                          onChanged: viewModel.onSearchChanged,
                                          onSubmitted: viewModel.onSearchSubmitted,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AIColors.white,
                                          ),
                                          cursorColor: Theme.of(context).colorScheme.secondary,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Search for people and groups',
                                            hintStyle:  TextStyle(
                                              fontSize: 14,
                                              color: AIColors.white,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: AIImage(
                                                AIImages.icBottomSearch,
                                                width: 14, height: 14,
                                              ),
                                            ),
                                            suffixIcon: viewModel.searchController.text.isNotEmpty
                                                ? IconButton(
                                                    tooltip: 'Clear',
                                                    splashRadius: 18,
                                                    icon: Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color: Theme.of(context).colorScheme.secondary,
                                                    ),
                                                    onPressed: () {
                                                      viewModel.clearSearch();
                                                      viewModel.searchFocusNode.requestFocus();
                                                    },
                                                  )
                                                : null,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(
                                        key: ValueKey('search-off'),
                                        height: _kTopRowHeight,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 2),

                            InkWell(
                              onTap: () => viewModel.showSearch = !viewModel.showSearch,
                              borderRadius: BorderRadius.circular(12),
                              child: AIImage(
                                AIImages.icBottomSearch,
                                width: 18,
                                height: 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
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
        );
      },
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

    final RRect rrect = RRect.fromRectAndRadius(indicator, Radius.circular(radius));
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
    return SizedBox.expand( // <-- fill the available width & fixed height from parent
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