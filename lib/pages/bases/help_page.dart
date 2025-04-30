import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/widgets/widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpProvider>.reactive(
      viewModelBuilder: () => HelpProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Help Center'), centerTitle: true),
          body: ListView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 48.0,
            ),
            children: [
              Text(
                'Enter your information below. We are here to help!',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Name'),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.33,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: AINoBorderTextField(
                  hintText: 'Emter your name',
                  onChanged: (value) => viewModel.name = value,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Emaill Address *'),
              ),
              const SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.33,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: AINoBorderTextField(
                  hintText: 'Enter your email',
                  onChanged: (value) => viewModel.email = value,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Message *'),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 144.0,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.33,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: AINoBorderTextField(
                  minLines: 5,
                  maxLines: 5,
                  hintText: 'Emter your message',
                  onChanged: (value) => viewModel.message = value,
                ),
              ),
              const SizedBox(height: 40.0),
              TextFillButton(
                text: 'Send Message',
                onTap: viewModel.onSendMessage,
                isBusy: viewModel.isBusy,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
