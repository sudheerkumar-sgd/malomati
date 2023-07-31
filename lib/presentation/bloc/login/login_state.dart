part of 'login_bloc.dart';

abstract class LoginState extends Equatable {}

class Init extends LoginState {
  @override
  List<Object?> get props => [];
}

class OnLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class OnLoginSuccess extends LoginState {
  final ApiEntity<LoginEntity> loginEntity;

  OnLoginSuccess({required this.loginEntity});
  @override
  List<Object?> get props => [loginEntity];
}

class OnIsManagerSuccess extends LoginState {
  final ApiEntity<LoginEntity> loginEntity;

  OnIsManagerSuccess({required this.loginEntity});
  @override
  List<Object?> get props => [loginEntity];
}

class OnLoginError extends LoginState {
  final String message;

  OnLoginError({required this.message});
  @override
  List<Object?> get props => [message];
}
