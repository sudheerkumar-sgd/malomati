import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:malomati/data/repository/apis_repository_impl.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/home_usecase.dart';
import 'package:malomati/domain/use_case/login_usecase.dart';
import 'package:malomati/presentation/bloc/home/home_bloc.dart';
import 'package:malomati/presentation/bloc/login/login_bloc.dart';

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
  sl.registerFactory(
    () => LoginBloc(
      loginUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => HomeBloc(
      homeUseCase: sl(),
    ),
  );
  // Use Case
  sl.registerLazySingleton(() => LoginUseCase(apisRepository: sl()));
  sl.registerLazySingleton(() => HomeUseCase(apisRepository: sl()));
  // Repository
  sl.registerLazySingleton<ApisRepository>(
      () => ApisRepositoryImpl(dataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(dio: sl()));

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

  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerFactory(() => ConstantConfig());
}
