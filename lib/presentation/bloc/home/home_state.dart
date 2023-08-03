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

class OnAttendanceSuccess extends HomeState {
  final ApiEntity<AttendanceEntity> attendanceEntity;

  OnAttendanceSuccess({required this.attendanceEntity});
  @override
  List<Object?> get props => [attendanceEntity];
}

class OnApiError extends HomeState {
  final String message;

  OnApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
