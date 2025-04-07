import 'package:insoblok/models/models.dart';
import 'package:flutter/material.dart';

import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 80.0,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: AIImage(
                AIImages.logo,
                width: 120.0,
                height: 120.0,
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 40.0,
            ),
            Text(
              'Welcome to InSoBlok!',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 80.0),
            InkWell(
              onTap: () async {
                try {
                  var metamask = MetaMaskService();
                  metamask.connect();
                } catch (e) {
                  logger.e(e);
                }

                await Future.delayed(const Duration(seconds: 5));

                var address = await AIHelpers.getDeviceIdentifier();
                logger.d(address);
                var user = AuthHelper.user ?? UserModel(walletAddress: address);
                await AuthHelper.setUser(user);
                if (user.firstName != null) {
                  Routers.goToMainPage(context);
                } else {
                  Routers.goToRegisterPage(context);
                }
              },
              child: Container(
                width: 320.0,
                height: 52.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    width: 2.0,
                    color: AIColors.yellow,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AIImage(
                      AIImages.imgMetamask,
                      width: 28.0,
                    ),
                    const SizedBox(width: 24.0),
                    Text(
                      'Login by MetaMask',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AIColors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
