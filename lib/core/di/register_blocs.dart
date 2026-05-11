import 'package:get_it/get_it.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/bloc/login/login_bloc.dart';
import 'package:malomati/presentation/bloc/requests/requests_bloc.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';

void registerBlocs(GetIt sl) {
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory(() => AttendanceBloc(attendanceUseCase: sl()));
  sl.registerFactory(() => ServicesBloc(servicesUseCase: sl()));
  sl.registerFactory(() => HomeBloc(homeUseCase: sl()));
  sl.registerFactory(() => RequestsBloc(requestsUseCase: sl()));
}
