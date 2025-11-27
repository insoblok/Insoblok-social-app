import 'package:flutter/material.dart';
import 'package:insoblok/widgets/widgets.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/models/models.dart';

final socialConfigs = {
  "instagram": {
    "icon": AIImages.icInstagram2,
    "media": "instagram",
    "placeholder": "instagram.com/",
  },
  "telegram": {
    "icon": AIImages.icTelegram2,
    "media": "telegram",
    "placeholder": "t.me/",
  },
  "whatsapp": {
    "icon": AIImages.icWhatsapp2,
    "media": "whatsapp",
    "placeholder": "wa.me/",
  },
  "linkedin": {
    "icon": AIImages.icLinkedin2,
    "media": "linkedin",
    "placeholder": "linkedin.com/in/",
  },
  "twitter": {
    "icon": AIImages.icTwitter2,
    "media": "twitter",
    "placeholder": "x.com/",
  },
  "tiktok": {
    "icon": AIImages.icTiktok2,
    "media": "tiktok",
    "placeholder": "tiktok.com/@",
  },
  "snapchat": {
    "icon": AIImages.icSnapchat2,
    "media": "snapchat",
    "placeholder": "snapchat.com/add/",
  },
  "youtube": {
    "icon": AIImages.icYoutube2,
    "media": "youtube",
    "placeholder": "youtube.com/",
  },
  "reddit": {
    "icon": AIImages.icReddit2,
    "media": "reddit",
    "placeholder": "reddit.com/user/",
  },
  "spotify": {
    "icon": AIImages.icSpotify2,
    "media": "spotify",
    "placeholder": "spotify.com/user/",
  },
  "soundcloud": {
    "icon": AIImages.icSoundCloud2,
    "media": "soundcloud",
    "placeholder": "soundcloud.com/",
  },
  "facebook": {
    "icon": AIImages.icFacebook2,
    "media": "facebook",
    "placeholder": "facebook.com/",
  },
};

typedef UpdateAccount = void Function(String f, String v);

int MAX_SOCIALS_CNT = 6;

// ignore: must_be_immutable
class SocialMediaInputView extends StatefulWidget {
  final UpdateAccount updateSocials;
  final String? field;
  bool? edit = false;
  List<SocialMediaModel>? initialValue;
  final UserModel? account;
  SocialMediaInputView({
    super.key,
    required this.updateSocials,
    this.field,
    this.edit,
    this.initialValue,
    this.account,
  });

  @override
  SocialMediaInputViewState createState() => SocialMediaInputViewState();
}

class SocialMediaInputViewState extends State<SocialMediaInputView> {
  final MultipleInputController controller = MultipleInputController();
  List<String> socials = [];

  @override
  void initState() {
    super.initState();
    final items =
        (widget.initialValue ?? [])
            .map((one) => (socialConfigs[one.media] ?? {})["icon"].toString())
            .toList();
    controller.initializeItems(items, MAX_SOCIALS_CNT);
  }

  void updateSocials(String field, String value) {
    logger.d("This is updatesocials $socials");
    if (!socials.contains(field) && socials.length == MAX_SOCIALS_CNT) {
      AIHelpers.showToast(msg: "Please remove one.");
      return;
    }
    widget.updateSocials(field, value);
    if (socials.contains(field)) {
      controller.removeItem((socialConfigs[field] ?? {})["icon"] ?? "");
    } else {
      controller.addItem((socialConfigs[field] ?? {})["icon"] ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    socials =
        (widget.account?.socials ?? []).map((one) => one.media ?? "").toList();
    logger.d("THis is socials $socials");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          Row(
            children: [
              Text("Socials", style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          SizedBox(height: 18.0),
          Padding(
            padding: EdgeInsets.all(1.0),
            child: MultipleInputWidget(
              controller: controller,
              maxItems: MAX_SOCIALS_CNT,
            ),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Select 6 to Add",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: socialConfigs.length,
              itemBuilder: (context, index) {
                final key = socialConfigs.keys.elementAt(index);
                final config = socialConfigs[key];
                final filtered =
                    (widget.account?.socials ?? [])
                        .where((one) => one.media == key)
                        .toList();
                String initialAccount = "";
                if (filtered.isNotEmpty) {
                  initialAccount = filtered[0].account ?? "";
                }
                return SocialMediaIndividualInput(
                  icon: config?["icon"] ?? "",
                  updateAccount: updateSocials,
                  field: key,
                  placeholder: config?["placeholder"] ?? "",
                  added: socials.contains(key),
                  maxItems: MAX_SOCIALS_CNT,
                  initialAccount: initialAccount,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
