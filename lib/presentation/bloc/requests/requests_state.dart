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

class OnAttendanceSuccess extends RequestsState {
  final ApiEntity<AttendanceListEntity> attendanceEntity;

  OnAttendanceSuccess({required this.attendanceEntity});
  @override
  List<Object?> get props => [attendanceEntity];
}

class OnRequestsApiError extends RequestsState {
  final String message;

  OnRequestsApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
