import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/domain/entities/requests_count_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import 'package:malomati/domain/use_case/services_usecase.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/finance_approval_entity.dart';
import '../../../domain/entities/hrapproval_details_entity.dart';
import '../../../domain/entities/leave_details_entity.dart';
import '../../../domain/entities/leave_submit_response_entity.dart';
import '../../../domain/entities/warning_list_entity.dart';

part 'services_state.dart';

class ServicesBloc extends Cubit<ServicesState> {
  final ServicesUseCase servicesUseCase;
  ServicesBloc({required this.servicesUseCase}) : super(Init());

  Future<void> getLeaveTypes(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result =
        await servicesUseCase.getLeaveTypes(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnLeaveTypesSuccess(leaveTypeEntity: r.leaveTypeList)));
  }

  Future<void> submitLeaveRequest(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result =
        await servicesUseCase.submitLeaveRequest(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnLeaveSubmittedSuccess(leaveSubmitResponse: r)));
  }

  Future<void> getEmployeesByDepartment(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result = await servicesUseCase.getEmployeesByDepartment(
        requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnEmployeesSuccess(employeesList: r)));
  }

  Future<void> getEmployeesByManager(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result = await servicesUseCase.getEmployeesByManager(
        requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnEmployeesSuccess(employeesList: r)));
  }

  Future<void> submitServicesRequest(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result = await servicesUseCase.submitServicesRequest(
        apiUrl: apiUrl, requestParams: requestParams);
    emit(result.fold(
        (l) => OnServicesError(message: _getErrorMessage(l)),
        (r) =>
            OnServicesRequestSubmitSuccess(servicesRequestSuccessResponse: r)));
  }

  Future<void> getLeaves(
      {required String apiUrl,
      required Map<String, dynamic> requestParams}) async {
    final result = await servicesUseCase.getLeaves(
        apiUrl: apiUrl, requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnLeavesSuccess(leavesList: r)));
  }

  Future<void> getHrApprovalsList(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result =
        await servicesUseCase.getHrApprovalsList(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnHrApprovalsListSuccess(hrApprovalsList: r)));
  }

  Future<void> getHrApprovalDetails(
      {required Map<String, dynamic> requestParams}) async {
    final result = await servicesUseCase.getHrApprovalDetails(
        requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnHrApprovalsDetailsSuccess(hrApprovalDetails: r)));
  }

  Future<void> getFinanceApprovalList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result = await servicesUseCase.getFinanceApprovalList(
        apiUrl: apiUrl, requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnFinanceApprovalsListSuccess(financeApprovalsList: r)));
  }

  Future<void> getFinanceItemDetailsList(
      {required apiUrl, required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result = await servicesUseCase.getFinanceItemDetailsList(
        apiUrl: apiUrl, requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnHrApprovalsDetailsSuccess(hrApprovalDetails: r)));
  }

  Future<void> getPayslipDetails(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result =
        await servicesUseCase.getPayslipDetails(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnPayslipDetailsSuccess(payslipEntity: r)));
  }

  Future<void> getWorkingDays(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await servicesUseCase.getWorkingDays(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnWorkingDaysSuccess(workingDaysEntity: r)));
  }

  Future<void> submitHrApproval(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result =
        await servicesUseCase.submitHrApproval(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnsubmitHrApprovalSuccess(apiEntity: r)));
  }

  Future<void> getThankyouList(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result =
        await servicesUseCase.getThankyouList(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnThankyouListSuccess(thankYouList: r)));
  }

  Future<void> getHolidayEvents(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result =
        await servicesUseCase.getHolidaysList(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnHolidayEventsSuccess(holidayEvents: r)));
  }

  Future<void> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await servicesUseCase.getRequestsCount(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnRequestsCountSuccess(requestsCountEntity: r)));
  }

  Future<void> sendPushNotifications(
      {required Map<String, dynamic> requestParams,
      bool showLoader = false}) async {
    if (showLoader) {
      emit(OnServicesLoading());
      final result = await servicesUseCase.sendPushNotifications(
          requestParams: requestParams);
      emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
          (r) => OnFCMSuccess(response: r)));
    } else {
      servicesUseCase.sendPushNotifications(requestParams: requestParams);
    }
  }

  Future<void> submitJobEmailRequest(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());
    final result = await servicesUseCase.submitJobEmailRequest(
        requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnJobEmailSubmitSuccess(jobEmailSubmitSuccess: r)));
  }

  Future<void> getWarningList(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await servicesUseCase.getWarningList(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnWarningListSuccess(warningList: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
