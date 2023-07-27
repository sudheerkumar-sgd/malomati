import 'package:dio/dio.dart';
import '../../config/constant_config.dart';

abstract class RemoteDataSource {
  
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  final ConstantConfig constantConfig;

  RemoteDataSourceImpl({
    required this.dio,
    required this.constantConfig,
  });

}
