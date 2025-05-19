import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insoblok/services/image_service.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kProductCategoryNames = ['Brand New', 'Dress', 'Shirts', 'Trousers'];

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddProductProvider>.reactive(
      viewModelBuilder: () => AddProductProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Add Product'), centerTitle: true),
          body: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Name of Product'),
              ),
              Container(
                decoration: kNoBorderDecoration,
                child: AINoBorderTextField(
                  hintText: 'Input product name',
                  initialValue: viewModel.product.name,
                  onChanged: viewModel.updateName,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Description of Product'),
                    InkWell(
                      onTap: viewModel.updateDescription,
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: Icon(Icons.edit, size: 18.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 160.0,
                padding: const EdgeInsets.all(16.0),
                decoration: kCardDecoration,
                child:
                    viewModel.product.description != null
                        ? AIHelpers.htmlRender(viewModel.product.description)
                        : Column(children: []),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, bottom: 16.0),
                child: Text('Tags of Product'),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: kNoBorderDecoration,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value:
                            viewModel.selectedTag.isNotEmpty
                                ? viewModel.selectedTag
                                : null,
                        dropdownColor:
                            Theme.of(context).colorScheme.onSecondary,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        underline: Container(),
                        items:
                            kProductCategoryNames.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            }).toList(),
                        onChanged:
                            (value) => viewModel.selectedTag = (value ?? ''),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: viewModel.addTag,
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    (viewModel.product.tags ?? [])
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(width: 4.0),
                                InkWell(
                                  onTap:
                                      () => viewModel.removeTag(
                                        (viewModel.product.tags ?? []).indexOf(
                                          tag,
                                        ),
                                      ),
                                  child: Icon(Icons.close, size: 20.0),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Product'),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            width: 0.33,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: SizedBox(
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 0.7,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  viewModel.avatarImage == null
                                      ? Container()
                                      : AIImage(
                                        File(viewModel.avatarImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        viewModel.selectProductImage(
                                          isImage: true,
                                        );
                                      },
                                      icon: Icon(
                                        size: 80.0,
                                        Icons.add_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Model'),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            width: 0.33,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: SizedBox(
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 0.7,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  viewModel.modelImage == null
                                      ? Container()
                                      : AIImage(
                                        File(viewModel.modelImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        viewModel.selectModelImage(
                                          isImage: true,
                                        );
                                      },
                                      icon: Icon(
                                        size: 80.0,
                                        Icons.add_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
