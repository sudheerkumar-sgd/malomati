import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';

import '../../core/error/failures.dart';
import '../entities/login_entity.dart';

abstract class ApisRepository {
  Future<Either<Failure, ApiEntity<LoginEntity>>> login(
      {required String apiPath, required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<ProfileEntity>>> getProfile(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<AttendanceEntity>>> getAttendance(
      {required Map<String, dynamic> requestParams});
}
