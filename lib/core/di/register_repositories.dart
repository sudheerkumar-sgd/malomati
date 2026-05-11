import 'package:get_it/get_it.dart';
import 'package:malomati/data/repository/apis_repository_impl.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/repository/attendance_repository.dart';
import 'package:malomati/domain/repository/auth_repository.dart';
import 'package:malomati/domain/repository/home_repository.dart';
import 'package:malomati/domain/repository/services_repository.dart';

void registerRepositories(GetIt sl) {
  sl.registerLazySingleton<ApisRepository>(
      () => ApisRepositoryImpl(dataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<AuthRepository>(() => sl<ApisRepository>());
  sl.registerLazySingleton<HomeRepository>(() => sl<ApisRepository>());
  sl.registerLazySingleton<AttendanceRepository>(() => sl<ApisRepository>());
  sl.registerLazySingleton<ServicesRepository>(() => sl<ApisRepository>());
}
