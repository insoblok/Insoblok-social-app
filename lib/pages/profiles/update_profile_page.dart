import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateProfileProvider>.reactive(
      viewModelBuilder: () => UpdateProfileProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Update Profile'),
            centerTitle: true,
            flexibleSpace: AppBackgroundView(),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(viewModel.account),
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: AppBackgroundView(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                AccountPublicInfoView(),
                Divider(
                  height: 1,
                  color: AIColors.greyTextColor,
                  thickness: 0.2,
                ),
                AccountPrivateInfoView(),
                // Padding(
                //   padding: const EdgeInsets.all(24.0),
                //   child: TextFillButton(
                //     onTap: viewModel.onClickUpdated,
                //     isBusy: viewModel.isBusy,
                //     text: 'Update Profile',
                //     color: Theme.of(context).primaryColor,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
