import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/lives/live_list_provider.dart';
import 'package:insoblok/widgets/widgets.dart';
 

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
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    'No one is live',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white60),
                                  ),
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

