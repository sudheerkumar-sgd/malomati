import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/domain/entities/login_entity.dart';
import 'package:malomati/domain/entities/profile_entity.dart';
import 'package:malomati/domain/use_case/login_usecase.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';

part 'login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc({required this.loginUseCase}) : super(Init());

  Future<void> doLogin({required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());

    final result = await loginUseCase.doLogin(
        apiPath: 'Login', requestParams: requestParams);
    emit(result.fold((l) => OnLoginError(message: _getErrorMessage(l)),
        (r) => OnLoginSuccess(loginEntity: r)));
  }

  Future<void> isManger({required Map<String, dynamic> requestParams}) async {
    //emit(OnLoading());

    final result = await loginUseCase.doLogin(
        apiPath: 'IsManager', requestParams: requestParams);
    emit(result.fold((l) => OnLoginError(message: _getErrorMessage(l)),
        (r) => OnIsManagerSuccess(loginEntity: r)));
  }

  Future<void> getProfile({required Map<String, dynamic> requestParams}) async {
    //emit(OnLoading());

    final result = await loginUseCase.getProfile(requestParams: requestParams);
    emit(result.fold((l) => OnLoginError(message: _getErrorMessage(l)),
        (r) => OnProfileSuccess(profileEntity: r)));
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).errorMessage;
      default:
        return 'An unknown error has occured';
    }
  }
}
