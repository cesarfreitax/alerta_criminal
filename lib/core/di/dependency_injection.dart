import 'package:alerta_criminal/core/services/auth_service.dart';
import 'package:alerta_criminal/core/services/string_service.dart';
import 'package:alerta_criminal/data/repositories/user_data_repository_impl.dart';
import 'package:alerta_criminal/domain/repositories/user_data_repository.dart';
import 'package:alerta_criminal/domain/use_cases/user_data_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final firebaseAuthInstance = FirebaseAuth.instance;
final getIt = GetIt.instance;

class DependencyInjection {
    static final GetIt getIt = GetIt.instance;
    static UserDataUseCase get userDataUseCase => getIt<UserDataUseCase>();
    static AuthService get authService => getIt<AuthService>();
    static StringService get strings => getIt<StringService>();

    void setup() {
        getIt.registerLazySingleton<UserDataRepository>(() => UserDataRepositoryImpl());
        getIt.registerLazySingleton<UserDataUseCase>(
                () => UserDataUseCase(getIt<UserDataRepository>())
        );

        getIt.registerLazySingleton<FirebaseAuth>(() => firebaseAuthInstance);
        getIt.registerLazySingleton<AuthService>(() => AuthService(getIt<FirebaseAuth>()));
    }
}

