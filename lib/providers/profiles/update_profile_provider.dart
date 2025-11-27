import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/routers/routers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class UpdateProfileProvider extends InSoBlokViewModel {
  late BuildContext _context;
  BuildContext get context => _context;
  set context(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  late UserModel _account;
  UserModel get account => _account;
  set account(UserModel model) {
    _account = model;
    notifyListeners();
  }

  final places = FlutterGooglePlacesSdk(GOOGLE_API_KEY);
  final TextEditingController autoCompleteController = TextEditingController();
  TextEditingController? bioController;

  Future<void> init(BuildContext context) async {
    this.context = context;
    account = AuthHelper.user ?? UserModel();

    logger.d("Initial account is ${account.toJson()}");

    final prediction = await places.fetchPlace(
      account.placeId ?? "",
      fields: [
        PlaceField.Id,
        PlaceField.Address,
        PlaceField.AddressComponents,
        PlaceField.Location,
      ],
    );
    autoCompleteController.text = prediction.place?.address ?? "";
    logger.d('${account.placeId} ${prediction.place?.address}');
    notifyListeners();
  }

  Future<void> onUpdatedAvatar() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountAvatarPage(context, null, null);
        // var result = await Routers.goToAccountAvatarPage(context, "data/user/0/insoblok.social.app/cache/avatar.jpg", "data/user/0/insoblok.social.app/cache/video_1.mp4");

        if (result != null) {
          account = account.copyWith(avatar: result);
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onUpdatedDiscovery() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountPublicPage(context);
        if (result != null) {
          account = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onUpdatedPublic() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountPublicPage(context);
        if (result != null) {
          account = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onUpdatedPrivate() async {
    if (isBusy) return;
    clearErrors();

    await runBusyFuture(() async {
      try {
        var result = await Routers.goToAccountPrivatePage(context);
        if (result != null) {
          account = result;
        }
      } catch (e) {
        setError(e);
        logger.e(e);
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    }
  }

  Future<void> onClickUpdated() async {
    if (isBusy) return;
    clearErrors();

    // Validate that first name and last name are provided
    if (account.firstName == null || account.firstName!.trim().isEmpty) {
      AIHelpers.showToast(msg: 'First name must not be empty');
      return;
    }

    if (account.lastName == null || account.lastName!.trim().isEmpty) {
      AIHelpers.showToast(msg: 'Last name must not be empty');
      return;
    }

    // Sync bio from controller before saving
    if (bioController != null) {
      final bioText = bioController!.text.trim();
      _account = _account.copyWith(desc: bioText.isEmpty ? null : bioText);
    }

    logger.d("Updated account is ${account.toJson()}");
    await runBusyFuture(() async {
      try {
        // if (user?.email?.isEmpty ?? true) {
        //   await FirebaseHelper.convertAnonymousToPermanent(
        //     email: account.email ?? '',
        //     password: account.password ?? '',
        //   );
        // }
        // Save the updated account
        await AuthHelper.updateUser(account);

        // Refetch fresh user data from database to ensure we have latest data
        if (account.id != null) {
          try {
            final freshUser = await UserService().getUser(account.id!);
            if (freshUser != null) {
              // Update AuthHelper.user with fresh data (without writing to DB again)
              AuthHelper.service.user = freshUser;
              // Also update local account
              account = freshUser;
              logger.d(
                'Refetched user data after update. Socials: ${freshUser.socials?.length ?? 0}',
              );
            } else {
              logger.w('Failed to refetch user data after update');
            }
          } catch (e) {
            logger.e('Error refetching user data after update: $e');
            // Continue even if refetch fails - the update was successful
          }
        }

        Navigator.of(context).pop(true);
      } catch (e) {
        setError(e);
        logger.e("Exception raised while saving profile data $e");
      } finally {
        notifyListeners();
      }
    }());

    if (hasError) {
      AIHelpers.showToast(msg: modelError.toString());
    } else {
      AIHelpers.showToast(msg: "Saved profile data successfully.");
    }
  }

  void updateSocials(String field, String value) {
    var socials = List<SocialMediaModel>.from(account.socials ?? []);
    final filtered =
        socials.where((element) => element.media == field).toList();

    if (value.isEmpty) {
      // Remove the social if value is empty (cancel action)
      if (filtered.isNotEmpty) {
        socials.remove(filtered[0]);
      }
    } else {
      // Add or update the social
      if (filtered.isEmpty) {
        // Add new social
        socials.add(SocialMediaModel(media: field, account: value));
      } else {
        // Update existing social with new value
        final index = socials.indexOf(filtered[0]);
        socials[index] = SocialMediaModel(media: field, account: value);
      }
    }

    account = account.copyWith(socials: socials);
    logger.d("Updated socials: $socials, account.socials: ${account.socials}");
  }

  void updateBio(String bio) {
    // Update account without triggering notifyListeners to prevent rebuild interference
    _account = _account.copyWith(desc: bio);
    // Don't call notifyListeners() here - let it happen naturally or on save
  }

  void syncBioFromText(String bioText) {
    // Sync bio text to account before saving
    _account = _account.copyWith(desc: bioText.isEmpty ? null : bioText);
  }

  void updateFirstName(String fName) {
    account = account.copyWith(firstName: fName);
  }

  void updateLastName(String lName) {
    account = account.copyWith(lastName: lName);
  }

  void updateLocation(String placeId) {
    // Update account placeId when location is selected
    _account = _account.copyWith(placeId: placeId);
    logger.d('Updated placeId: $placeId');
  }

  void updateWebsite(String url) {
    account = account.copyWith(website: url);
  }

  /// Test function to verify Google Places API key is working
  Future<void> testGooglePlacesApiKey() async {
    try {
      logger.d(
        'Testing Google Places API key: ${GOOGLE_API_KEY.substring(0, 10)}...',
      );

      // Test autocomplete with a simple query
      final result = await places.findAutocompletePredictions('New York');

      if (result.predictions.isNotEmpty) {
        logger.d(
          '✅ API Key is WORKING! Found ${result.predictions.length} predictions',
        );
        final firstPred = result.predictions.first;
        logger.d(
          'First prediction: ${firstPred.placeId} - ${firstPred.fullText}',
        );
        AIHelpers.showToast(
          msg: '✅ API Key works! Found ${result.predictions.length} results',
        );
      } else {
        logger.w('⚠️ API Key works but returned no results');
        AIHelpers.showToast(msg: '⚠️ API Key works but no results found');
      }
    } catch (e) {
      logger.e('❌ API Key ERROR: $e');
      final errorMsg = e.toString();

      // Check for specific error types
      if (errorMsg.contains('9011') ||
          errorMsg.contains('not authorized') ||
          errorMsg.contains('API_ERROR_AUTOCOMPLETE')) {
        logger.e('❌ API Key is NOT AUTHPlaces API');
        logger.e('🔧 FIX: Enable Places API in GooConsole');
        logger.e('   1. Go to: https://console.cloud.google.com/apis/library');
        logger.e('   2. Search for "Places API"');
        logger.e('   4. Also check API key restrictie Places API');
        AIHelpers.showToast(
          msg:
              '❌ API Key not authorized! Enable Places API in Google Cloud Console',
        );
      } else if (errorMsg.contains('PERMISSION_DENIED') ||
          errorMsg.contains('403')) {
        logger.e('❌ API Key is INVALID or does not have Places API enabled');
        AIHelpers.showToast(
          msg: '❌ API Key Error: Invalid or missing Places API permission',
        );
      } else if (errorMsg.contains('REQUEST_DENIED')) {
        logger.e('❌ API Key is RESTRICTED or billing is not enabled');
        AIHelpers.showToast(
          msg: '❌ API Key Error: Request denied - check restrictions/billing',
        );
      } else {
        AIHelpers.showToast(msg: '❌ API Key Error: $errorMsg');
      }
    }
  }
}
