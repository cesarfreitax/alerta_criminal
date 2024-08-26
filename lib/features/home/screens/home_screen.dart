import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/utils/string_util.dart';
import 'package:alerta_criminal/features/home/widgets/crime_details_widget.dart';
import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/providers/crims_notifier.dart';
import '../../../core/utils/location_util.dart';
import '../../../data/models/crime_model.dart';
import '../widgets/add_new_crim_bottom_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> futureCrims;
  LatLng? userLocation;
  var isShowingCrimeDetails = false;
  var selectedCrimeId = "";

  @override
  void initState() {
    super.initState();
    futureCrims = ref.read(crimsProvider.notifier).getCrims();
    setLocation();
  }

  void setLocation() async {
    final locationData = await getLocation();

    if (locationData == null) {
      return;
    }

    setState(() {
      userLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  Set<Marker> getMarkers(List<CrimeModel> crimes) {
    return crimes
        .map(
          (crime) => Marker(
              markerId: MarkerId(crime.id),
              position: LatLng(crime.lat, crime.lng),
              onTap: () {
                toggleCrimeDetails(crime.id, true);
              }),
        )
        .toSet();
  }

  void toggleCrimeDetails(String? id, bool show) {
    setState(() {
      isShowingCrimeDetails = show;
    });

    if (show) {
      selectedCrimeId = id!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CrimeModel> crims = ref.watch(crimsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(getStrings(context).map),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: DependencyInjection.authService.signOut,
          )
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: futureCrims,
            builder: (context, snapshot) {
              return userLocation != null
                  ? MapWidget(
                      markers: getMarkers(crims),
                      userLocation: userLocation!,
                      isSelecting: false,
                onTapMap: toggleCrimeDetails
              )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                AddNewCrimBottomSheet().show(context,
                    DependencyInjection.crimUseCase.add, userLocation!);
              },
              child: const Icon(Icons.add),
            ),
          ),
          if (isShowingCrimeDetails)
            Align(alignment: Alignment.topCenter,
              child: CrimeDetailsWidget(
                crime: ref.read(crimsProvider.notifier).getCrim(selectedCrimeId),
              ),
            ),
        ],
      ),
    );
  }
}
