import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';

class MessageSettingPage extends StatelessWidget {
  const MessageSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageSettingProvider>.reactive(
      viewModelBuilder: () => MessageSettingProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Messages Settings'),
            centerTitle: true,
            actions: [IconButton(onPressed: () {}, icon: Text('Done'))],
          ),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 48.0,
                padding: const EdgeInsets.only(left: 20.0),
                color: AIColors.darkGreyBackground,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Privacy',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AIColors.greyTextColor,
                  ),
                ),
              ),
              for (var i = 0; i < kMessageSetting.length; i++) ...{
                Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 12.0,
                    right: 20.0,
                  ),
                  decoration: BoxDecoration(
                    border:
                        i == 2
                            ? null
                            : Border(
                              bottom: BorderSide(
                                color: AIColors.speraterColor,
                                width: 0.66,
                              ),
                            ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            kMessageSetting[i]['title'] ?? '',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          CupertinoSwitch(value: true, onChanged: (value) {}),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: kMessageSetting[i]['desc'] ?? '',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            TextSpan(
                              text: 'Learn more',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: AIColors.pink),
                            ),
                          ],
                        ),
                      ),
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
