import 'dart:async';

import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/language_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends ConsumerStatefulWidget {
  MapWidget({
    super.key,
    required this.markers,
    required this.userLocation,
    required this.isSelecting,
    this.onSelectNewLocation,
    this.onTapMap,
  });

  Set<Marker> markers;
  LatLng userLocation;
  final bool isSelecting;
  final void Function(String address, LatLng location)? onSelectNewLocation;
  final void Function(String? id, bool show)? onTapMap;

  @override
  ConsumerState<MapWidget> createState() {
    return _MapWidgetState();
  }
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  late GoogleMapController mapController;
  final searchBarController = TextEditingController();
  var isFetchingLocation = false;
  var currentAddress = "";

  @override
  void dispose() {
    searchBarController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isSelecting) {
      setTextOnSearchBar(widget.userLocation);
    }
    super.initState();
  }

  // Functions
  void setMarkers(LatLng location) {
    setState(() {
      widget.markers = {
        Marker(
          markerId: const MarkerId("m1"),
          position: location,
        ),
      };
    });
  }

  void setTextOnSearchBar(LatLng location) async {
    currentAddress = await DependencyInjection.locationUseCase.getAddressByLatLng(location.latitude, location.longitude);
    setState(() {
      searchBarController.text = currentAddress;
    });
  }

  void toggleFetchingLocation() => isFetchingLocation = !isFetchingLocation;

  Future<void> onTapSuggestion(String addressSuggestion, SearchController controller) async {
    final location = await DependencyInjection.locationUseCase.getLatLngByAddress(addressSuggestion);

    setMarkers(location);

    widget.onSelectNewLocation!(addressSuggestion, location);

    mapController.animateCamera(CameraUpdate.newLatLng(location));

    setState(() {
      controller.closeView(addressSuggestion);
      searchBarController.text = addressSuggestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mapWidget(),
        if (widget.isSelecting) searchBar(),
      ],
    );
  }

  // Components
  Positioned searchBar() {
    return Positioned(
      top: 4,
      left: 4,
      right: 4,
      child: SearchAnchor(
          isFullScreen: false,
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16)),
              controller: searchBarController,
              onTap: controller.openView,
              onChanged: (_) => controller.openView,
              leading: const Icon(Icons.search),
            );
          },
          suggestionsBuilder: setSuggestionsBuilder),
    );
  }

  FutureOr<Iterable<Widget>> setSuggestionsBuilder(BuildContext context, SearchController controller) async {
    if (controller.text.isEmpty) {
      return const Iterable.empty();
    }

    final placeSuggestions = await DependencyInjection.locationUseCase.getPlaceSuggestions(
      controller.text,
      widget.userLocation,
      500,
      getUserLanguage(context),
    );

    return List<ListTile>.generate(placeSuggestions.predictions.length, (int index) {
      final addressSuggestion = placeSuggestions.predictions[index].description;

      return ListTile(
          title: Text(addressSuggestion), onTap: () async => await onTapSuggestion(addressSuggestion, controller));
    });
  }



  GoogleMap mapWidget() {
    return GoogleMap(
      onMapCreated: (controller) => mapController = controller,
      initialCameraPosition: CameraPosition(
        target: widget.userLocation,
        zoom: widget.isSelecting ? 18.0 : 14.0,
      ),
      zoomControlsEnabled: false,
      markers: widget.markers,
      onTap: widget.isSelecting && !isFetchingLocation
          ? (location) async {
              onTapMapWhenSelecting(location);
            }
          : (location) {
              widget.onTapMap!(null, false);
            },
    );
  }

  void onTapMapWhenSelecting(LatLng location) {
    setMarkers(location);
    toggleFetchingLocation();
    setTextOnSearchBar(LatLng(location.latitude, location.longitude));
    widget.onSelectNewLocation!(currentAddress, location);
    toggleFetchingLocation();
  }
}
