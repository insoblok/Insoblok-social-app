import 'package:flutter/material.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kCustomAppbarHeight = 45.0;
const kExtendAppbarHeight = 45.0;

class AISliverAppbar extends SliverAppBar {
  AISliverAppbar(
    BuildContext context, {
    double? extendHeight,
    Widget? extendWidget,
    super.key,
    super.pinned,
    super.floating,
    super.leading,
    super.title,
    super.actions,
  }) : super(
         expandedHeight:
             extendWidget != null
                 ? kCustomAppbarHeight +
                     (extendHeight ?? kExtendAppbarHeight) +
                     10.0
                 : null,
         elevation: 1.0,
         centerTitle: true,
         flexibleSpace:
             extendWidget != null
                 ? FlexibleSpaceBar(
                     collapseMode: CollapseMode.none,
                     background: Container(
                       margin: EdgeInsets.only(
                         top:
                             (kExtendAppbarHeight) +
                             MediaQuery.of(context).padding.top +
                             10.0,
                       ),
                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                       height: (extendHeight ?? kExtendAppbarHeight),
                       child: extendWidget,
                     ),
                   )
                 : AppBackgroundView(),
       );
}

class AIPersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxSize;
  final double minSize;
  final dynamic dynamicValue;

  AIPersistentHeader({
    required this.child,
    required this.maxSize,
    required this.minSize,
    this.dynamicValue,
  });

  @override
  double get maxExtent => maxSize;

  @override
  double get minExtent => minSize;

  @override
  Widget build(BuildContext context, shrinkOffset, overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(AIPersistentHeader oldDelegate) {
    if (oldDelegate.maxSize == 0) return false;
    if (oldDelegate.maxExtent != maxSize) return true;
    if (oldDelegate.dynamicValue != dynamicValue) return true;
    return false;
  }
}

class AITabBarView extends StatefulWidget {
  final void Function(int)? onTap;

  const AITabBarView({super.key, this.onTap});

  @override
  State<AITabBarView> createState() => _AITabBarViewState();
}

class _AITabBarViewState extends State<AITabBarView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            height: kToolbarHeight - 8.0,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AIColors.pink,
              ),
              padding: const EdgeInsets.all(4),
              labelStyle: Theme.of(context).textTheme.titleMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.titleMedium!,
              tabs: const [Tab(text: "Monthly"), Tab(text: "Daily")],
              onTap: widget.onTap,
            ),
          ),
        ],
      ),
    );
  }
}
