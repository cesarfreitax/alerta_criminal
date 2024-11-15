import 'package:alerta_criminal/core/di/dependency_injection.dart';
import 'package:alerta_criminal/core/providers/crims_notifier.dart';
import 'package:alerta_criminal/core/providers/location_notifier.dart';
import 'package:alerta_criminal/features/main/screens/main_screen.dart';
import 'package:alerta_criminal/firebase_options.dart';
import 'package:alerta_criminal/theme/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
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
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  DependencyInjection().setup();
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    var locationFuture = ref.read(locationProvider.notifier).fetchLocation();
    var crimesFuture = ref.read(crimsProvider.notifier).getCrims();

    await Future.wait([locationFuture, crimesFuture]);

    FlutterNativeSplash.remove();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox();
    }

    return MaterialApp(
      title: 'Alerta Criminal',
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScreen(),
    );
  }
}
