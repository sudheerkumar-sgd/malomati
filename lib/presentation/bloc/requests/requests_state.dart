part of 'requests_bloc.dart';

abstract class RequestsState extends Equatable {}

class Init extends RequestsState {
  @override
  List<Object?> get props => [];
}

class OnLoading extends RequestsState {
  @override
  List<Object?> get props => [];
}

class OnAttendanceSuccess extends RequestsState {
  final ApiEntity<AttendanceListEntity> attendanceEntity;

  OnAttendanceSuccess({required this.attendanceEntity});
  @override
  List<Object?> get props => [attendanceEntity];
}

class OnDashboardSuccess extends RequestsState {
  final ApiEntity<DashboardEntity> dashboardEntity;

  OnDashboardSuccess({required this.dashboardEntity});
  @override
  List<Object?> get props => [dashboardEntity];
}

class OnFavoriteSuccess extends RequestsState {
  final List<FavoriteEntity> favoriteEntity;

  OnFavoriteSuccess({required this.favoriteEntity});
  @override
  List<Object?> get props => [favoriteEntity];
}

class OnApiError extends RequestsState {
  final String message;

  OnApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
