import 'package:flutter/material.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UserAvatarView extends StatelessWidget {
  final void Function(int?)? onUpdateAvatar;
  const UserAvatarView({super.key, this.onUpdateAvatar});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.0,
      height: 120.0,
      child: Stack(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0, color: AIColors.blue),
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: AIImage(
                width: double.infinity,
                height: double.infinity,
                AuthHelper.user?.avatar,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                var result = await showModalBottomSheet<int>(
                  context: context,
                  builder: (context) {
                    return SafeArea(
                      child: Container(
                        width: double.infinity,
                        color: AIColors.appScaffoldBackground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(0),
                              child: Row(
                                children: [
                                  AIImage(Icons.air, color: AIColors.blue),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'Create to AI Avatar',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AIColors.blue,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AIColors.blue,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Text(
                                      'Premium',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24.0),
                            InkWell(
                              onTap: () => Navigator.of(context).pop(1),
                              child: Row(
                                children: [
                                  AIImage(Icons.camera, color: AIColors.blue),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    'From Image Gallery',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: AIColors.blue,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Free',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
                if (onUpdateAvatar != null) {
                  onUpdateAvatar!(result);
                }
              },
              child: Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AIColors.blue,
                  shape: BoxShape.circle,
                ),
                child: AIImage(Icons.camera, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final dynamic src;
  final String text;
  final void Function()? onTap;

  const UserInfoWidget({super.key, this.src, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AIColors.borderColor)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            if (src != null) ...{
              AIImage(src, color: Colors.white),
              const SizedBox(width: 24.0),
            },
            Text(text, style: TextStyle(color: Colors.white)),
            const Spacer(),
            AIImage(Icons.arrow_forward_ios, height: 14.0, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
