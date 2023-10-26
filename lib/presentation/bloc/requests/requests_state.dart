part of 'requests_bloc.dart';

abstract class RequestsState extends Equatable {}

class Init extends RequestsState {
  @override
  List<Object?> get props => [];
}

class OnRequestsDataLoading extends RequestsState {
  @override
  List<Object?> get props => [];
}

class OnRequestListSuccess extends RequestsState {
  final List<FinanceApprovalEntity> requestsList;

  OnRequestListSuccess({required this.requestsList});
  @override
  List<Object?> get props => [requestsList];
}

class OnRequestDetailsSuccess extends RequestsState {
  final RequestDetailsEntity requestlDetails;

  OnRequestDetailsSuccess({required this.requestlDetails});
  @override
  List<Object?> get props => [requestlDetails];
}

class OnsubmitHrApprovalSuccess extends RequestsState {
  final ApiEntity<LeaveSubmitResponseEntity> apiEntity;

  OnsubmitHrApprovalSuccess({required this.apiEntity});
  @override
  List<Object?> get props => [apiEntity];
}

class OnRequestsApiError extends RequestsState {
  final String message;

  OnRequestsApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
