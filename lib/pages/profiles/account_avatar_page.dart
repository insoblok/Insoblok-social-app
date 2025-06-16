import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class AccountAvatarPage extends StatelessWidget {
  const AccountAvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Avatar'), centerTitle: true),
      body: ViewModelBuilder<AvatarProvider>.reactive(
        viewModelBuilder: () => AvatarProvider(),
        onViewModelReady: (viewModel) => viewModel.init(context),
        builder: (context, viewModel, _) {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                children: [
                  Text(
                    'Just Imagine It, We Can Create It. That will take a few progress step. Please follow one by one',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16.0),
                  AvatarRatioView(),
                  const SizedBox(height: 16.0),
                  AvatarPromptView(),
                  const SizedBox(height: 16.0),
                  AvatarOriginView(),
                  if (viewModel.hasResult) ...{
                    const SizedBox(height: 40.0),
                    AvatarResultView(),
                  },
                  const SizedBox(height: 24.0),
                  TextFillButton(
                    onTap:
                        (viewModel.resultFirebaseUrl?.isNotEmpty ?? false)
                            ? viewModel.postLookbook
                            : viewModel.onConvert,
                    isBusy: viewModel.pageStatus?.isNotEmpty ?? false,
                    color: Theme.of(context).primaryColor,
                    text:
                        viewModel.hasResult
                            ? 'Save to LOOKBOOK'
                            : 'Convert to AI Image',
                  ),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ],
              ),
              if (viewModel.pageStatus?.isNotEmpty ?? false)
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.0),
                    height: 220.0,
                    width: double.infinity,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSecondary.withAlpha(128),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 24.0,
                      children: [
                        Loader(size: 64.0),
                        Text(
                          viewModel.pageStatus!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class AvatarRatioView extends ViewModelWidget<AvatarProvider> {
  const AvatarRatioView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '1. Choose aspect ratio of image.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (viewModel.ratioIndex != null)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
        Text(
          'Image size ratio, must be one of the supported formats Possible values: [1:1, 3:2, 2:3].',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < kAvatarAspectRatio.length; i++) ...{
              InkWell(
                onTap: () => viewModel.ratioIndex = i,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        viewModel.ratioIndex == i
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(64)
                            : Theme.of(
                              context,
                            ).colorScheme.secondary.withAlpha(16),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(kAvatarAspectRatio[i]['title']! as String),
                ),
              ),
            },
          ],
        ),
      ],
    );
  }
}

class AvatarPromptView extends ViewModelWidget<AvatarProvider> {
  const AvatarPromptView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '2. Input prompt description. (Optional)',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
        Text(
          'What you want the 4o image to generate?',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: AIColors.greyTextColor, width: 0.5),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Type something',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: null,
            onChanged: (value) => viewModel.prompt = value,
          ),
        ),
      ],
    );
  }
}

class AvatarOriginView extends ViewModelWidget<AvatarProvider> {
  const AvatarOriginView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '3. Choose origin image.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (viewModel.originPath != null)
              Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
          ],
        ),
        Text(
          'Formats: *.jpeg, *.jpg, *.png.',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AIColors.greyTextColor, width: 0.5),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child:
                        viewModel.originFile == null
                            ? InkWell(
                              onTap: viewModel.onImagePicker,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 20.0,
                                  children: [
                                    AIImage(AIImages.icShare),
                                    Text('Click to upload image'),
                                  ],
                                ),
                              ),
                            )
                            : AIImage(
                              viewModel.originFile,
                              fit: BoxFit.contain,
                            ),
                  ),
                  if (viewModel.originFile != null &&
                      viewModel.resultFirebaseUrl == null)
                    Positioned(
                      right: 20.0,
                      top: 12.0,
                      child: InkWell(
                        onTap: () => viewModel.originPath = null,
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withAlpha(16),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AvatarResultView extends ViewModelWidget<AvatarProvider> {
  const AvatarResultView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Result of AI Avatar',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AIColors.greyTextColor, width: 0.5),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: AIImage(viewModel.resultFirebaseUrl, fit: BoxFit.contain),
            ),
          ),
        ),
      ],
    );
  }
}
