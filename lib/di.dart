import 'package:ai_journal_app/features/journals/domain/repositories/journal_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'common/controllers/app_controller.dart';
import 'common/network/dio_client.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/presentation/controllers/login_controller.dart';
import 'features/auth/presentation/controllers/signup_controller.dart';
import 'features/journals/data/repositories/journal_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> initDependency() async {
  // Controllers
  Get.lazyPut(() => AppController());
  Get.lazyPut(() => LoginController(getIt<LoginUseCase>()), fenix: true);
  Get.lazyPut(() => SignUpController(getIt<SignupUseCase>()), fenix: true);

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignupUseCase(getIt<AuthRepository>()));

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance));
  getIt.registerLazySingleton<JournalRepository>(() => JournalRepositoryImpl(dioClient: getIt<DioClient>()));

  // Dio
  getIt.registerLazySingleton<DioClient>(() => DioClient());
}
