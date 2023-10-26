import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import '../../../domain/entities/finance_approval_entity.dart';
import '../../../domain/entities/leave_submit_response_entity.dart';
import '../../../domain/entities/request_details_entity.dart';
import '../../../domain/use_case/requests_usecase.dart';

part 'requests_state.dart';

class RequestsBloc extends Cubit<RequestsState> {
  final RequestsUseCase requestsUseCase;
  RequestsBloc({required this.requestsUseCase}) : super(Init());

  Future<void> getRequestsList(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await requestsUseCase.getRequestsList(requestParams: requestParams);
    emit(result.fold((l) => OnRequestsApiError(message: _getErrorMessage(l)),
        (r) => OnRequestListSuccess(requestsList: r)));
  }

  Future<void> getRequestlDetails(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await requestsUseCase.getRequestlDetails(requestParams: requestParams);
    emit(result.fold((l) => OnRequestsApiError(message: _getErrorMessage(l)),
        (r) => OnRequestDetailsSuccess(requestlDetails: r)));
  }

  Future<void> submitHrApproval(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnRequestsDataLoading());
    final result =
        await requestsUseCase.submitHrApproval(requestParams: requestParams);
    emit(result.fold((l) => OnRequestsApiError(message: _getErrorMessage(l)),
        (r) => OnsubmitHrApprovalSuccess(apiEntity: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
