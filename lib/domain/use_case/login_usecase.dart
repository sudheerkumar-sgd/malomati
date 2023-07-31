import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';

import '../../core/error/failures.dart';

class LoginUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  LoginUseCase({required this.apisRepository});

  Future<Either<Failure, ApiEntity<LoginEntity>>> doLogin(
      {required apiPath, required Map<String, dynamic> requestParams}) async {
    return await apisRepository.login(
        apiPath: apiPath, requestParams: requestParams);
  }
}
