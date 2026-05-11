import 'package:get_it/get_it.dart';
import 'package:malomati/domain/use_case/attendance_usecase.dart';
import 'package:malomati/domain/use_case/home_usecase.dart';
import 'package:malomati/domain/use_case/login_usecase.dart';
import 'package:malomati/domain/use_case/requests_usecase.dart';
import 'package:malomati/domain/use_case/services_usecase.dart';

void registerUseCases(GetIt sl) {
  sl.registerLazySingleton(
      () => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(
      () => AttendanceUseCase(attendanceRepository: sl()));
  sl.registerLazySingleton(() => HomeUseCase(homeRepository: sl()));
  sl.registerLazySingleton(
      () => RequestsUseCase(servicesRepository: sl()));
  sl.registerLazySingleton(
      () => ServicesUseCase(servicesRepository: sl()));
}
