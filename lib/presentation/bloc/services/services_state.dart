part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {}

class Init extends ServicesState {
  @override
  List<Object?> get props => [];
}

class OnServicesLoading extends ServicesState {
  @override
  List<Object?> get props => [];
}

class OnLeaveTypesSuccess extends ServicesState {
  final List<LeaveTypeEntity> leaveTypeEntity;

  OnLeaveTypesSuccess({required this.leaveTypeEntity});
  @override
  List<Object?> get props => [leaveTypeEntity];
}

class OnLeaveSubmittedSuccess extends ServicesState {
  final ApiEntity<LeaveSubmitResponseEntity> leaveSubmitResponse;

  OnLeaveSubmittedSuccess({required this.leaveSubmitResponse});
  @override
  List<Object?> get props => [leaveSubmitResponse];
}

class OnInitiativeSuccess extends ServicesState {
  final ApiEntity<LeaveSubmitResponseEntity> initiativeSubmitResponse;

  OnInitiativeSuccess({required this.initiativeSubmitResponse});
  @override
  List<Object?> get props => [initiativeSubmitResponse];
}

class OnServicesError extends ServicesState {
  final String message;

  OnServicesError({required this.message});
  @override
  List<Object?> get props => [message];
}