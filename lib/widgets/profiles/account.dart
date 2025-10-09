import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';

import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/pages/pages.dart';
import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/widgets/widgets.dart';

const kProfileDiscoverHeight = 60.0;

class AccountPresentHeaderView extends ViewModelWidget<AccountProvider> {
  const AccountPresentHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return SizedBox(
      height:
          kProfileDiscoverHeight +
          MediaQuery.of(context).padding.top +
          kAccountAvatarSize / 2.0,
      child: Stack(
        children: [
          AIImage(
            viewModel.accountUser?.discovery ?? AIImages.imgDiscover,
            fit: BoxFit.cover,
            width: double.infinity,
            height: kProfileDiscoverHeight + MediaQuery.of(context).padding.top,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: kAccountAvatarSize,
              height: kAccountAvatarSize,
              child: AuthHelper.user?.avatarStatusView(
                width: kAvatarSize * 1.5,
                height: kAvatarSize * 1.5,
                borderWidth: 2.0,
                textSize: kAvatarSize,
                showStatus: false,
              ),
            ),
          ),
          CustomCircleBackButton(),
          if (viewModel.isMe)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: viewModel.onClickMoreButton,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  margin: EdgeInsets.only(
                    right: 20.0,
                    top: MediaQuery.of(context).padding.top + 12.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppSettingHelper.transparentBackground,
                  ),
                  child: Icon(Icons.edit, size: 18.0),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AccountFloatingView extends ViewModelWidget<AccountProvider> {
  const AccountFloatingView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    const gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFF30C6C), // pink
        Color(0xFFC739EB), // purple
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4.0,
            children: [
              Text(
                '${viewModel.accountUser?.fullName ?? viewModel.accountUser?.nickId}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              // Text(
              //   '@${viewModel.accountUser?.nickId}',
              //   style: Theme.of(context).textTheme.labelMedium,
              // ),

              Wrap(
                spacing: 12.0,
                runSpacing: 8.0,
                children:
                    (viewModel.accountUser?.linkInfo ?? []).map((info) {
                      return InkWell(
                        onTap: () {
                          if (info['type'] == 'wallet') {
                            viewModel.onClickInfo(0);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AIImage(
                              info['icon'],
                              height: 18.0,
                              color: AIColors.greyTextColor,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              info['title']!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              // Text.rich(
              //   TextSpan(
              //     children: [
              //       TextSpan(
              //         text:
              //             (viewModel.accountUser?.likes?.length ?? 0)
              //                 .socialValue,
              //         style: Theme.of(context).textTheme.labelLarge,
              //       ),
              //       TextSpan(
              //         text: '  Likes  ',
              //         style: Theme.of(context).textTheme.labelLarge,
              //       ),
              //       TextSpan(
              //         text:
              //             '  ${(viewModel.accountUser?.follows?.length ?? 0).socialValue}',
              //         style: Theme.of(context).textTheme.labelLarge,
              //       ),
              //       TextSpan(
              //         text: '  Followers',
              //         style: Theme.of(context).textTheme.labelLarge,
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 60.0,
                    child: Column(
                      children: [
                        Text(
                          '${viewModel.userRank}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Rank',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,              // thickness
                    height: 42,            // height of the separator
                    color: Colors.grey,    // color
                  ),


                  
                  SizedBox(
                    width: 80.0,
                    child: Column(
                      children: [
                        Text(
                          '${viewModel.followingList.length}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Following',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,              // thickness
                    height: 42,            // height of the separator
                    color: Colors.grey,    // color
                  ),
                  SizedBox(
                    width: 80.0,
                    child: Column(
                      children: [
                        Text(
                          '${viewModel.accountUser?.follows?.length ?? 0}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Followers',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,              // thickness
                    height: 42,            // height of the separator
                    color: Colors.grey,    // color
                  ),
                  SizedBox(
                    width: 60.0,
                    child: Column(
                      children: [
                        Text(
                          '${viewModel.accountUser?.views?.length ?? 0}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          'Views',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!viewModel.isMe)
                Column(
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 36,
                          width: 124,
                          decoration: BoxDecoration(
                            gradient: viewModel.isFollowing ? gradient : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextFillButton(
                            onTap: viewModel.updateFollow,
                            height: 36,
                            width: 124,
                            isBusy: viewModel.isBusy,
                            color: viewModel.isFollowing
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.secondary.withAlpha(64),
                            text: viewModel.isFollowing ? 'Follow back' : 'Follow',
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        TextFillButton(
                          onTap: () {
                            viewModel.gotoNewChat();
                          },
                          height: 36,
                          width: 124,
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withAlpha(64),
                          text: 'Message',
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ],
                    ),
                  ],
                ),
              viewModel.accountUser?.desc != null
                  ? AIHelpers.htmlRender(viewModel.accountUser?.desc)
                  : Container(),
            ],
          ),
        ),
        const Divider(thickness: 0.5),
        AccountXPDashboardView(),
      ],
    );
  }
}

class AccountFloatingHeaderView extends ViewModelWidget<AccountProvider> {
  const AccountFloatingHeaderView({super.key});

  @override
  Widget build(BuildContext context, viewModel) {
    return Row(
      spacing: 12.0,
      children: [
        for (var i = 0; i < kAccountPageTitles.length; i++) ...{
          Expanded(
            child: TabCoverView(
              kAccountPageTitles[i],
              onTap: () => viewModel.pageIndex = i,
              selected: viewModel.pageIndex == i,
            ),
          ),
        },
      ],
    );
  }
}

// ignore: must_be_immutable
class AccountPublicInfoView extends ViewModelWidget<UpdateProfileProvider> {
  AccountPublicInfoView({super.key});

  TextEditingController bioController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  

  @override
  Widget build(BuildContext context, viewModel) {
    final _displayFullName = viewModel.account.fullName;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90.0,
                height: 90.0,
                child: Stack(
                  children: [
                    AuthHelper.user?.avatarStatusView(
                      width: kAvatarSize * 1.5,
                      height: kAvatarSize * 1.5,
                      borderWidth: 2.0,
                      textSize: kAvatarSize,
                      showStatus: false,
                    ) ?? Text(""),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: viewModel.onUpdatedAvatar,
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Icon(Icons.camera_alt, size: 20.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _displayFullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Text(
                      '#${viewModel.account.nickId}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.0),
          AITextArea(
            hintText: "Enter your Bio here",
            controller: bioController,
            initialText: viewModel.account.desc ?? "",
          ),
        ],
      ),
    );
  }


}

class AccountPrivateInfoView extends ViewModelWidget<UpdateProfileProvider> {
  final void Function(String value)? updateFirstName;
  final void Function(String value)? updateLastName;
  final void Function(String value)? updateLocation;
  final void Function(String value)? updateWebsite;
  AccountPrivateInfoView({ super.key, this.updateFirstName, this.updateLastName, this.updateLocation, this.updateWebsite });
  
  
  

  @override
  Widget build(BuildContext context, viewModel) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Private Information')),
              // InkWell(
              //   onTap: viewModel.onUpdatedPrivate,
              //   child: Container(
              //     width: 32.0,
              //     height: 32.0,
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColor,
              //       shape: BoxShape.circle,
              //     ),
              //     child: Center(child: Icon(Icons.edit, size: 18.0)),
              //   ),
              // ),
            ],
          ),

          SizedBox(height: 12.0),
          AccountPrivateInfoCover(
            leading: Icons.account_box,
            title: viewModel.account.firstName ?? "",
            onChanged: updateFirstName,
            hintText: "First Name",
          ),
          SizedBox(height: 12.0),
          AccountPrivateInfoCover(
            leading: Icons.account_box,
            title: viewModel.account.lastName ?? "",
            onChanged: updateLastName,
            hintText: "Last Name",
          ),
          SizedBox(height: 12.0),
          PlaceSearchField(
            /// The line `// controller: autoCompleteController,` is a commented-out line of
            /// code in the `PlaceSearchField` widget initialization.
            controller: viewModel.autoCompleteController,
            apiKey: GOOGLE_API_KEY,
            isLatLongRequired: true,        // Fetch lat/long with place details
            webCorsProxyUrl: "https://cors-anywhere.herokuapp.com",  // Optional for web
            onPlaceSelected: (placeId, latLng) {
              logger.d('Place ID: ${placeId.place_id}');
              logger.d('Latitude and Longitude: $latLng');
            },
            decorationBuilder: (context, child) {
              return Material(
                type: MaterialType.card,
                elevation: 4,
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                child: child,
              );
            },
            builder: (context, controller, focusNode) {
              return TextField(
                controller: viewModel.autoCompleteController,
                focusNode: focusNode,
                // autofocus: true,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  prefixIcon: Icon(
                    size: 20.0,
                    
                    Icons.location_city, // 👈 any Material icon
                    color: Theme.of(context).primaryColor,   // icon color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // corner radius
                    borderSide: BorderSide(
                      color: Colors.grey, // border color when not focused
                      width: 1,         // border width
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blueAccent, // border color when focused
                      width: 1,
                    ),
                  ),
                  )
                );
              },
              itemBuilder: (context, prediction) => ListTile(
                tileColor: Colors.black87,

                selectedColor: Colors.black45,
                textColor: Colors.black12,
                leading: const Icon(Icons.location_on, color: Colors.white),
                title: Text(
                  prediction.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)
                ),
              ),
          ),
          SizedBox(height: 12.0),
          AccountPrivateInfoCover(
            leading: Icons.web_asset,
            title: viewModel.account.website ?? 'Https://insoblok.io',
            hintText: "Your Website",
            onChanged: updateWebsite
          ),
          Container(
            height: 180.0,
            margin: const EdgeInsets.only(top: 24.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child:
                (viewModel.account.discovery == null)
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AIImage(AIImages.icImage, height: 32.0),
                          const SizedBox(height: 12.0),
                          Text(
                            'Discovery image',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(24.0),
                      child: AIImage(
                        viewModel.account.discovery,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

class AccountPrivateInfoCover extends StatelessWidget {
  final dynamic leading;
  final String title;
  final String? hintText;
  final void Function(String s)? onChanged;

  const AccountPrivateInfoCover({
    super.key,
    required this.leading,
    required this.title,
    this.hintText = "",
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AITextField(
        initialValue: title,
        prefixIcon: SizedBox(
          width: 18,
          height: 18,
          child: Icon(
            leading,
            color: Theme.of(context).primaryColor,
            // width: 12.0,
            // height: 12.0,
          ),
        ),
        fillColor: Colors.grey.shade900,
        onChanged: (val) {
          onChanged!(val);
        },
        hintText: hintText,
      ),
    );
  }
}
