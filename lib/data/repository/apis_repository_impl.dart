import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/data/data_sources/remote_data_source.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';

import '../../core/network/network_info.dart';
import '../../domain/repository/apis_repository.dart';

class ApisRepositoryImpl extends ApisRepository {
  final RemoteDataSource dataSource;
  final NetworkInfo networkInfo;
  ApisRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ApiEntity<LoginEntity>>> login(
      {required String apiPath,
      required Map<String, dynamic> requestParams}) async {
    var isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final apiResponse = await dataSource.login(
            apiPath: apiPath, requestParams: requestParams);
        final apiEntity =
            apiResponse.toEntity<LoginEntity>(apiResponse.data!.toLoginEntity);
        return Right(apiEntity);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? ''));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
