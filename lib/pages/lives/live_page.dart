import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/lives/live_list_provider.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:shimmer/shimmer.dart';

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveListProvider>.reactive(
      viewModelBuilder: () => LiveListProvider(),
      onViewModelReady: (vm) => vm.init(context),
      builder: (context, vm, _) {
        return Scaffold(
          body: AppBackgroundView(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('Live'),
                  pinned: true,
                  flexibleSpace: AppBackgroundView(),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Live now', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        vm.sessions.isEmpty
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 12,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemBuilder: (_, i) {
                                    return GestureDetector(
                                      onTap: () => vm.onTapPlaceholder(i + 1),
                                      child: _LivePlaceholderItem(index: i + 1),
                                    );
                                  },
                                )
                              : SizedBox(
                                  height: 110,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, i) {
                                    final s = vm.sessions[i];
                                    return GestureDetector(
                                      onTap: () => vm.onTapSession(s),
                                      child: Column(
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                width: 72,
                                                height: 72,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: const SweepGradient(
                                                    colors: [Color(0xFFF30C6C), Color(0xFFC739EB), Color(0xFFF30C6C)],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3),
                                                  child: CircleAvatar(
                                                    radius: 32,
                                                    backgroundImage: s.userAvatar != null ? NetworkImage(s.userAvatar!) : null,
                                                    backgroundColor: Colors.white12,
                                                    child: s.userAvatar == null ? const Icon(Icons.person, color: Colors.white70) : null,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: -2,
                                                bottom: -2,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            width: 72,
                                            child: Text(s.userName, maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.labelMedium),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                                    itemCount: vm.sessions.length,
                                  ),
                                ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: vm.onTapCreateLive,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _LivePlaceholderItem extends StatelessWidget {
  final int index;
  const _LivePlaceholderItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const SweepGradient(
                  colors: [Color(0xFF2D2D2D), Color(0xFF3C3C3C), Color(0xFF2D2D2D)],
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 6)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1F1F1F), Color(0xFF111111)],
                    ),
                  ),
                  child: Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.white24,
                      highlightColor: Colors.white60,
                      child: const Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFF30C6C), Color(0xFFC739EB)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Shimmer.fromColors(
            baseColor: Colors.white30,
            highlightColor: Colors.white70,
            child: Text(
              'Creator $index',
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}


