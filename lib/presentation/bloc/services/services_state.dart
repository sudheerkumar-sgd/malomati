part of 'services_bloc.dart';

abstract class ServicesState {}

class Init extends ServicesState {}

class OnServicesLoading extends ServicesState {}

class OnLeaveTypesSuccess extends ServicesState {
  final List<LeaveTypeEntity> leaveTypeEntity;

  OnLeaveTypesSuccess({required this.leaveTypeEntity});
}

class OnLeaveSubmittedSuccess extends ServicesState {
  final ApiEntity<LeaveSubmitResponseEntity> leaveSubmitResponse;

  OnLeaveSubmittedSuccess({required this.leaveSubmitResponse});
}

class OnInitiativeSuccess extends ServicesState {
  final ApiEntity<LeaveSubmitResponseEntity> initiativeSubmitResponse;

  OnInitiativeSuccess({required this.initiativeSubmitResponse});
}

class OnServicesRequestSubmitSuccess extends ServicesState {
  final ApiEntity<LeaveSubmitResponseEntity> servicesRequestSuccessResponse;

  OnServicesRequestSubmitSuccess(
      {required this.servicesRequestSuccessResponse});
}

class OnEmployeesSuccess extends ServicesState {
  final List<EmployeeEntity> employeesList;

  OnEmployeesSuccess({required this.employeesList});
}

class OnLeavesSuccess extends ServicesState {
  final List<NameIdEntity> leavesList;

  OnLeavesSuccess({required this.leavesList});
}

class OnHrApprovalsListSuccess extends ServicesState {
  final List<HrApprovalEntity> hrApprovalsList;

  OnHrApprovalsListSuccess({required this.hrApprovalsList});
}

class OnHrApprovalsDetailsSuccess extends ServicesState {
  final HrapprovalDetailsEntity hrApprovalDetails;

  OnHrApprovalsDetailsSuccess({required this.hrApprovalDetails});
}

class OnFinanceApprovalsListSuccess extends ServicesState {
  final List<FinanceApprovalEntity> financeApprovalsList;

  OnFinanceApprovalsListSuccess({required this.financeApprovalsList});
}

class OnPayslipDetailsSuccess extends ServicesState {
  final PayslipEntity payslipEntity;

  OnPayslipDetailsSuccess({required this.payslipEntity});
}

class OnWorkingDaysSuccess extends ServicesState {
  final WorkingDaysEntity workingDaysEntity;

  OnWorkingDaysSuccess({required this.workingDaysEntity});
}

class OnsubmitHrApprovalSuccess extends ServicesState {
  final ApiEntity apiEntity;

  OnsubmitHrApprovalSuccess({required this.apiEntity});
}

class OnThankyouListSuccess extends ServicesState {
  final List<ThankyouEntity> thankYouList;

  OnThankyouListSuccess({required this.thankYouList});
}

class OnServicesError extends ServicesState {
  final String message;

  OnServicesError({required this.message});
}
