import 'package:dartz/dartz.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';

/// Authentication + profile API boundary.
abstract class AuthRepository {
  Future<Either<Failure, ApiEntity<LoginEntity>>> login(
      {required String apiPath, required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<ProfileEntity>>> getProfile(
      {required Map<String, dynamic> requestParams});
}
