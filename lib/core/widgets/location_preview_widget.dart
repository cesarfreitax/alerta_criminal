import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../theme/custom_colors.dart';
import '../util/location_util.dart';

class LocationPreviewWidget extends StatelessWidget {
  const LocationPreviewWidget({
    super.key,
    required this.location,
    this.onSetLocationOnMap,
  });

  final LatLng location;
  final void Function()? onSetLocationOnMap;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
          child: Image.network(
            getLocationImagePreview(
              location.latitude,
              location.longitude,
            ),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        if (onSetLocationOnMap != null)
          Positioned(
            bottom: 8,
            right: 8,
            child: CircleAvatar(
              child: IconButton(
                onPressed: onSetLocationOnMap,
                icon: Icon(
                  Icons.map_rounded,
                  color: CustomColors().blue,
                ),
              ),
            ),
          )
      ],
    );
  }
}
