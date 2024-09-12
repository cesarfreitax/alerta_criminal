import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/location_notifier.dart';
import 'package:alerta_criminal/core/providers/user_notifier.dart';
import 'package:alerta_criminal/core/widgets/login_warning_widget.dart';
import 'package:alerta_criminal/features/home/widgets/crime_details_widget.dart';
import 'package:alerta_criminal/features/home/widgets/map_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/providers/crims_notifier.dart';
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
  LatLng? userLocation;
  LatLng? userPreviousLocation;
  var isShowingCrimeDetails = false;
  var selectedCrimeId = "";
  List<CrimeModel> crims = [];
  User? user;

  @override
  void initState() {
    super.initState();
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

  void logout() {
    DependencyInjection.authService.signOut;
  }

  Widget mapWidget() {
    return userLocation != null
        ? MapWidget(
            markers: getMarkers(crims),
            userLocation: userLocation ?? const LatLng(37.4221, 122.0853),
            isSelecting: false,
            onTapMap: toggleCrimeDetails,
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget fabWidget() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () {
          AddNewCrimBottomSheet().show(
            context,
            DependencyInjection.crimUseCase.add,
            resetLocation
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget loginWarningWidget() {
    return const Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: LoginWarningWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    setProviders();
    userPreviousLocation ??= userLocation;
    return SafeArea(
      child: Stack(
        children: [
          mapWidget(),
          if (user != null) fabWidget(),
          if (isShowingCrimeDetails)
            Align(
              alignment: Alignment.topCenter,
              child: CrimeDetailsWidget(
                crime:
                    ref.read(crimsProvider.notifier).getCrim(selectedCrimeId),
              ),
            ),
          if (user == null) loginWarningWidget()
        ],
      ),
    );
  }

  void setProviders() {
    crims = ref.watch(crimsProvider);
    user = ref.watch(userProvider);
    userLocation = ref.watch(locationProvider);
  }

  void resetLocation() => ref.read(locationProvider.notifier).setLocation(userPreviousLocation!);

}
