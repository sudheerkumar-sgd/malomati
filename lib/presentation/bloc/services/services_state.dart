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

class OnServicesRequestSubmitSuccess extends ServicesState {
  final ApiEntity<LeaveSubmitResponseEntity> servicesRequestSuccessResponse;

  OnServicesRequestSubmitSuccess(
      {required this.servicesRequestSuccessResponse});
  @override
  List<Object?> get props => [servicesRequestSuccessResponse];
}

class OnEmployeesSuccess extends ServicesState {
  final List<EmployeeEntity> employeesList;

  OnEmployeesSuccess({required this.employeesList});
  @override
  List<Object?> get props => [employeesList];
}

class OnLeavesSuccess extends ServicesState {
  final List<NameIdEntity> leavesList;

  OnLeavesSuccess({required this.leavesList});
  @override
  List<Object?> get props => [leavesList];
}

class OnHrApprovalsListSuccess extends ServicesState {
  final List<HrApprovalEntity> hrApprovalsList;

  OnHrApprovalsListSuccess({required this.hrApprovalsList});
  @override
  List<Object?> get props => [hrApprovalsList];
}

class OnsubmitHrApprovalSuccess extends ServicesState {
  final ApiEntity apiEntity;

  OnsubmitHrApprovalSuccess({required this.apiEntity});
  @override
  List<Object?> get props => [apiEntity];
}

class OnServicesError extends ServicesState {
  final String message;

  OnServicesError({required this.message});
  @override
  List<Object?> get props => [message];
}
