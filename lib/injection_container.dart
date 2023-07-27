import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:malomati/data/repository/apis_repository_impl.dart';
import 'package:malomati/domain/repository/apis_repository.dart';

import 'config/constant_config.dart';
import 'config/flavor_config.dart';
import 'core/network/network_info.dart';
import 'data/data_sources/dio_logging_interceptor.dart';
import 'data/data_sources/remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc

  // Use Case

  // Repository
  sl.registerLazySingleton<ApisRepository>(
      () => ApisRepositoryImpl(dataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(dio: sl(), constantConfig: sl()));

  /**
   * ! Core
   */
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.baseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    return dio;
  });

  sl.registerLazySingleton(() => ConstantConfig());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
