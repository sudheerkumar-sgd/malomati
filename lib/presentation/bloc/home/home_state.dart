part of 'home_bloc.dart';

abstract class HomeState extends Equatable {}

class Init extends HomeState {
  @override
  List<Object?> get props => [];
}

class OnLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

// class OnAttendanceSuccess extends HomeState {
//   final ApiEntity<AttendanceListEntity> attendanceEntity;

//   OnAttendanceSuccess({required this.attendanceEntity});
//   @override
//   List<Object?> get props => [attendanceEntity];
// }

class OnDashboardSuccess extends HomeState {
  final ApiEntity<DashboardEntity> dashboardEntity;

  OnDashboardSuccess({required this.dashboardEntity});
  @override
  List<Object?> get props => [dashboardEntity];
}

class OnEventsSuccess extends HomeState {
  final ApiEntity<EventsListEntity> eventsListEntity;

  OnEventsSuccess({required this.eventsListEntity});
  @override
  List<Object?> get props => [eventsListEntity];
}

class OnFavoriteSuccess extends HomeState {
  final List<FavoriteEntity> favoriteEntity;

  OnFavoriteSuccess({required this.favoriteEntity});
  @override
  List<Object?> get props => [favoriteEntity];
}

class OnRequestsCountSuccess extends HomeState {
  final RequestsCountEntity requestsCountEntity;

  OnRequestsCountSuccess({required this.requestsCountEntity});

  @override
  List<Object?> get props => [requestsCountEntity];
}

class OnNotificationsListSuccess extends HomeState {
  final List<FinanceApprovalEntity> notificationsList;

  OnNotificationsListSuccess({required this.notificationsList});
  @override
  List<Object?> get props => [notificationsList];
}

class OnApiError extends HomeState {
  final String message;

  OnApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
