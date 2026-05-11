import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';
import 'package:malomati/domain/repository/auth_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';

import '../../core/error/failures.dart';

class LoginUseCase extends BaseUseCase {
  final AuthRepository authRepository;
  LoginUseCase({required this.authRepository});

  Future<Either<Failure, ApiEntity<LoginEntity>>> doLogin(
      {required apiPath, required Map<String, dynamic> requestParams}) async {
    return await authRepository.login(
        apiPath: apiPath, requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<ProfileEntity>>> getProfile(
      {required Map<String, dynamic> requestParams}) async {
    return await authRepository.getProfile(requestParams: requestParams);
  }
}
