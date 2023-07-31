import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';

import '../../core/error/failures.dart';
import '../entities/login_entity.dart';

abstract class ApisRepository {
  Future<Either<Failure, ApiEntity<LoginEntity>>> login(
      {required String apiPath, required Map<String, dynamic> requestParams});
}
