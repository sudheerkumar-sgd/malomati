import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:malomati/core/di/register_blocs.dart';
import 'package:malomati/core/di/register_repositories.dart';
import 'package:malomati/core/di/register_use_cases.dart';
import 'package:malomati/core/managers/dashboard_leave_balances.dart';
import 'package:malomati/core/managers/location_access_manager.dart';
import 'package:malomati/core/network/network_info.dart';
import 'package:malomati/data/data_sources/dio_logging_interceptor.dart';
import 'package:malomati/data/data_sources/remote_data_source.dart';

import 'config/constant_config.dart';
import 'config/flavor_config.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.baseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    return dio;
  });

  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(dio: sl()));

  registerRepositories(sl);
  registerUseCases(sl);
  registerBlocs(sl);

  sl.registerFactory(() => ConstantConfig());
  sl.registerLazySingleton(() => DashboardLeaveBalances());
  sl.registerLazySingleton(() => LocationAccessManager(attendanceBloc: sl()));
}
