import 'package:alerta_criminal/core/utils/language_util.dart';
import 'package:alerta_criminal/core/utils/location_util.dart';
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
  final void Function(LatLng location)? onSelectNewLocation;
  final void Function(String? id, bool show)? onTapMap;

  @override
  ConsumerState<MapWidget> createState() {
    return _MapWidgetState();
  }
}

class _MapWidgetState extends ConsumerState<MapWidget> {
  late Future<void> futureCrims;

  late GoogleMapController mapController;
  final searchBarController = TextEditingController();
  var enteredAddress = "";

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setMarkers(Set<Marker> markers) {
    setState(() {
      widget.markers = markers;
    });
  }

  @override
  void dispose() {
    searchBarController.dispose();
    mapController.dispose();
    super.dispose();
  }

  void setupSearchBar() async {
    searchBarController.text = await getAddressByLatLng(
        widget.userLocation.latitude, widget.userLocation.longitude);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isSelecting) {
      setupSearchBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: widget.userLocation,
            zoom: widget.isSelecting ? 14.0 : 11.0,
          ),
          zoomControlsEnabled: false,
          markers: widget.markers,
          onTap: widget.isSelecting
              ? (location) {
                  setMarkers(
                    {
                      Marker(
                        markerId: const MarkerId("m1"),
                        position: location,
                      ),
                    },
                  );
                  widget.onSelectNewLocation!(location);
                }
              : (location) {
                  widget.onTapMap!(null, false);
                },
        ),
        if (widget.isSelecting)
          Positioned(
            top: 4,
            left: 4,
            right: 4,
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16)),
                  controller: controller,
                  onTap: controller.openView,
                  onChanged: (_) => controller.openView,
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder:
                  (BuildContext context, SearchController controller) async {
                final enteredAddress = controller.text;
                if (enteredAddress.isEmpty) {
                  return const Iterable.empty();
                }
                final placeSuggestions = await getPlaceSuggestions(controller.text, widget.userLocation, 500, getUserLanguage(context));
                return List<ListTile>.generate(placeSuggestions.predictions.length, (int index) {
                  final addressSuggestion = placeSuggestions.predictions[index].description;
                  return ListTile(
                    title: Text(addressSuggestion),
                    onTap: () async {
                        final location = await getLatLngByAddress(addressSuggestion);
                        setMarkers(
                          {
                            Marker(
                              markerId: const MarkerId("m1"),
                              position: location,
                            ),
                          },
                        );
                        widget.onSelectNewLocation!(location);
                        mapController.animateCamera(CameraUpdate.newLatLng(location));
                        setState(() {
                          controller.closeView(addressSuggestion);
                        });
                    },
                  );
                });
              },
            ),
          ),
      ],
    );
  }
}
