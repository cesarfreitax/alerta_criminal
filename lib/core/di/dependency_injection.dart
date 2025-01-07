import 'package:alerta_criminal/core/services/auth_service.dart';
import 'package:alerta_criminal/core/services/string_service.dart';
import 'package:alerta_criminal/data/repositories/crim_repository_impl.dart';
import 'package:alerta_criminal/data/repositories/crime_commentary_repository_impl.dart';
import 'package:alerta_criminal/data/repositories/location_repository_impl.dart';
import 'package:alerta_criminal/data/repositories/user_data_repository_impl.dart';
import 'package:alerta_criminal/domain/repositories/crim_repository.dart';
import 'package:alerta_criminal/domain/repositories/crime_commentaries_repository.dart';
import 'package:alerta_criminal/domain/repositories/location_repository.dart';
import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';
import 'package:alerta_criminal/domain/use_cases/crim_use_case.dart';
import 'package:alerta_criminal/domain/use_cases/crime_commentaries_use_case.dart';
import 'package:alerta_criminal/domain/use_cases/location_use_case.dart';
import 'package:alerta_criminal/domain/use_cases/user_data_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
final firebaseAuthInstance = FirebaseAuth.instance;
final firebaseFirestoreInstance = FirebaseFirestore.instance;

class DependencyInjection {
    static final GetIt getIt = GetIt.instance;
    static UserDataUseCase get userDataUseCase => getIt<UserDataUseCase>();
    static AuthService get authService => getIt<AuthService>();
    static StringService get strings => getIt<StringService>();
    static CrimUseCase get crimUseCase => getIt<CrimUseCase>();
    static CrimeCommentariesUseCase get crimeCommentariesUseCase => getIt<CrimeCommentariesUseCase>();
    static LocationUseCase get locationUseCase => getIt<LocationUseCase>();

    void setup() {
        // User
        getIt.registerLazySingleton<UserDataRepository>(() => UserDataRepositoryImpl());
        getIt.registerLazySingleton<UserDataUseCase>(
                () => UserDataUseCase(getIt<UserDataRepository>())
        );

        // Auth
        getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuthInstance);
        getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<FirebaseAuth>()));

        // Firebase firestore
        getIt.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestoreInstance);

        // Crime
        getIt.registerLazySingleton<CrimRepository>(() => CrimRepositoryImpl(firebaseFirestoreInstance));
        getIt.registerLazySingleton<CrimUseCase>(() => CrimUseCase(getIt<CrimRepository>(), firebaseFirestoreInstance));

        // Crime commentary
        getIt.registerLazySingleton<CrimeCommentariesRepository>(() => CrimeCommentariesRepositoryImpl(firebaseFirestoreInstance));
        getIt.registerLazySingleton<CrimeCommentariesUseCase>(() => CrimeCommentariesUseCase(getIt<CrimeCommentariesRepository>(), firebaseFirestoreInstance));

        // Location
        getIt.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
        getIt.registerLazySingleton<LocationUseCase>(() => LocationUseCase(getIt<LocationRepository>()));
    }
}

