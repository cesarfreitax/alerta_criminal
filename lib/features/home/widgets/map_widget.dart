import 'package:alerta_criminal/core/utils/location_util.dart';
import 'package:alerta_criminal/domain/entities/crim_entity.dart';
import 'package:alerta_criminal/features/home/widgets/add_new_crim_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() {
    return _MapWidgetState();
  }
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? userLocation;
  var isFetchingLocation = false;

  void setLocation() async {
    final locationData = await LocationUtil().getLocation();

    if (locationData == null) {
      return;
    }

    setState(() {
      userLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  List<CrimEntity> crims = [];

  void addNewCrim(CrimEntity crim) {
    setState(() {
      crims.add(crim);
    });
  }

  late GoogleMapController mapController;

  final LatLng center = const LatLng(45.521563, -122.677433);

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    setLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        userLocation == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: userLocation!,
                  zoom: 11.0,
                ),
                zoomControlsEnabled: false,
                markers: crims.map((crim) => Marker(
                  markerId: MarkerId(crim.id),
                  position: crim.location
                  )
                ).toSet(),
              ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              AddNewCrimBottomSheet().show(context, addNewCrim, userLocation!);
            },
            child: const Icon(Icons.add),
          ),
        )
      ],
    );
  }
}
