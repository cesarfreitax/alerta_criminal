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
    super.dispose();
    searchBarController.dispose();
  }

  void setupSearchBar() async {
    searchBarController.text = await getAddress(
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
    return Stack(
      children: [
        if (widget.isSelecting)
          Positioned(
            top: 8,
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: SearchBar(
                controller: searchBarController,
              ),
            ),
          ),
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
      ],
    );
  }
}
