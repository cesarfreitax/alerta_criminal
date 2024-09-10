import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/crims_notifier.dart';
import 'package:alerta_criminal/core/providers/location_notifier.dart';
import 'package:alerta_criminal/data/models/crime_model.dart';
import 'package:alerta_criminal/features/main/screens/main_screen.dart';
import 'package:alerta_criminal/firebase_options.dart';
import 'package:alerta_criminal/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  DependencyInjection().setup();

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isFetchingLocation = true;
    var isFetchingCrimes = true;

    ref.read(locationProvider.notifier).setLocation().whenComplete(() {
      isFetchingLocation = false;
      handleSplashLoading(isFetchingLocation, isFetchingCrimes);
    });
    ref.read(crimsProvider.notifier).getCrims().whenComplete(() {
      isFetchingCrimes = false;
      handleSplashLoading(isFetchingLocation, isFetchingCrimes);
    });

    return MaterialApp(
      title: 'Alerta Criminal',
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
    );
  }

  void handleSplashLoading(bool isFetchingLocation, bool isFetchingCrimes) {
    if (!isFetchingLocation && !isFetchingCrimes) {
      FlutterNativeSplash.remove();
    }
  }
}
