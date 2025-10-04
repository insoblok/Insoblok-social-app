import 'package:flutter/material.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

class ScoreItemView extends StatelessWidget {
  final TastescoreModel score;

  const ScoreItemView({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor, width: 0.66),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: Text(
              kScoreDescription[score.type] ?? score.type ?? '---',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+${score.bonus} XP'),
              Text(
                '${score.timestamp?.timeago}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScoreItemExtView extends StatelessWidget {
  final TastescoreModel score;

  const ScoreItemExtView({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        spacing: 12.0,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Text(
                  kScoreDescription[score.type] ?? score.type ?? '---',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    for (var str in (score.type ?? '').split('_')) ...{
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 2.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(32),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(str.toTitleCase),
                      ),
                    },
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+${score.bonus} XP'),
              Text(
                '${score.timestamp?.timeago}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
