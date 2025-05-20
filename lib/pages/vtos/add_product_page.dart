import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

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
                child: Text('Category of Product'),
              ),
              Row(
                spacing: 12.0,
                children: [
                  Expanded(
                    child: Container(
                      decoration: kNoBorderDecoration,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value:
                            viewModel.selectedCategory.isNotEmpty
                                ? viewModel.selectedCategory
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
                            (value) =>
                                viewModel.selectedCategory = (value ?? ''),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48.0,
                      alignment: Alignment.center,
                      decoration: kNoBorderDecoration,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(viewModel.product.category ?? ''),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48.0,
                      alignment: Alignment.center,
                      decoration: kNoBorderDecoration,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(viewModel.product.type ?? ''),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                spacing: 24.0,
                children: [
                  ProductImageView(
                    title: 'Product',
                    imagePath: viewModel.avatarImage?.path,
                    onTap: () => viewModel.selectProductImage(isImage: true),
                  ),
                  ProductImageView(
                    title: 'Model',
                    imagePath: viewModel.modelImage?.path,
                    onTap: () => viewModel.selectModelImage(isImage: true),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              TextFillButton(
                text: viewModel.isBusy ? 'Uploading...' : 'Add Product',
                color: viewModel.isBusy ? AIColors.grey : AIColors.pink,
                onTap: viewModel.onClickAddProduct,
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        );
      },
    );
  }
}
