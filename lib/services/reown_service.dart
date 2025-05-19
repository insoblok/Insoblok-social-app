import 'package:flutter/material.dart';

import 'package:reown_appkit/reown_appkit.dart';

import 'package:insoblok/utils/utils.dart';

class ReownService {
  late ReownAppKitModal _appKitModel;
  ReownAppKitModal get appKitModel => _appKitModel;

  ReownService(BuildContext context) {
    _appKitModel = ReownAppKitModal(
      context: context,
      projectId: kReownProjectID,
      metadata: const PairingMetadata(
        name: 'AIAvatar',
        description: 'insoblokai.io',
        url: 'https://www.insoblokai.io/',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media',
        ],
        redirect: Redirect(
          native: 'insoblokai://',
          universal: 'https://www.insoblokai.io/insoblokai',
          linkMode: false,
        ),
      ),
    );
  }

  Future<void> init() async {
    await _appKitModel.init();
  }
}
