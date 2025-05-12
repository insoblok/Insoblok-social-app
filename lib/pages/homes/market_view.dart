import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MarketProvider>.reactive(
      viewModelBuilder: () => MarketProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Marketplace'),
            centerTitle: true,
            actions: [
              if (kDebugMode) ...{
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: viewModel.onTapAddProduct,
                ),
              },
            ],
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              for (var group in viewModel.vtoGroup) ...{
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  color: AppSettingHelper.transparentBackground,
                  child: Text(group.name ?? ''),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 296.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    children: [
                      for (var cell in (group.list ?? [])) ...{
                        VTOCellView(
                          cell: cell,
                          onTap: () {
                            viewModel.onTapVTOList(cell);
                          },
                        ),
                        const SizedBox(width: 8.0),
                      },
                    ],
                  ),
                ),
              },
            ],
          ),
        );
      },
    );
  }
}

const kImageCellSize = 180.0;

class VTOCellView extends StatelessWidget {
  final VTOCellModel cell;
  final void Function()? onTap;

  const VTOCellView({super.key, required this.cell, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: kImageCellSize,
          decoration: BoxDecoration(
            color: AppSettingHelper.transparentBackground,
            border: Border.all(
              width: 0.33,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AIImage(
                cell.image,
                width: kImageCellSize,
                height: kImageCellSize,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cell.title ?? '',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      cell.desc ?? '',
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
