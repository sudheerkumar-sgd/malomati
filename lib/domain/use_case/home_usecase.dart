import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';

import '../../core/error/failures.dart';

class HomeUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  HomeUseCase({required this.apisRepository});

  Future<Either<Failure, ApiEntity<AttendanceEntity>>> getAttendance(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getAttendance(requestParams: requestParams);
  }
}
