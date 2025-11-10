import 'package:flutter/material.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/widgets/widgets.dart';

import 'package:stacked/stacked.dart';

import 'package:insoblok/providers/providers.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:google_places_api_flutter/google_places_api_flutter.dart';

class RegisterSecondPage extends StatelessWidget {
  final UserModel user;

  RegisterSecondPage({super.key, required this.user});
  
  final TextEditingController autoCompleteController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterSecondProvider>.reactive(
      viewModelBuilder: () => RegisterSecondProvider(),
      onViewModelReady: (viewModel) => viewModel.init(context, userModel: user),
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(title: Text('Register'), centerTitle: true),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 24.0,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter 75XP points by providing your country and city name',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  
                  PlaceSearchField(
                    /// The line `// controller: autoCompleteController,` is a commented-out line of
                    /// code in the `PlaceSearchField` widget initialization.
                    controller: autoCompleteController,
                    apiKey: GOOGLE_API_KEY,
                    isLatLongRequired: true,        // Fetch lat/long with place details
                    webCorsProxyUrl: "https://cors-anywhere.herokuapp.com",  // Optional for web
                    onPlaceSelected: (placeId, latLng) {
                      logger.d('Place ID: $placeId');
                      viewModel.updatePlace(placeId.place_id);
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
                        controller: autoCompleteController,
                        focusNode: focusNode,
                        // autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city, // 👈 any Material icon
                            color: Colors.white,   // icon color
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
                  const Spacer(),
                  GradientPillButton(
                    text: "Register",
                    onPressed: viewModel.onClickRegister,
                    loading: viewModel.isBusy,
                  ),
                  SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
