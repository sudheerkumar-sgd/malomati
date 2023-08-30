import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/entities/name_id_entity.dart';
import 'package:malomati/domain/use_case/services_usecase.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/leave_submit_response_entity.dart';

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

  Future<void> getLeaves({required Map<String, dynamic> requestParams}) async {
    final result =
        await servicesUseCase.getLeaves(requestParams: requestParams);
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
        (r) => OnHrApprovalsListSuccess(hrApprovalsList: r)));
  }

  Future<void> submitHrApproval(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await servicesUseCase.submitHrApproval(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnsubmitHrApprovalSuccess(apiEntity: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
