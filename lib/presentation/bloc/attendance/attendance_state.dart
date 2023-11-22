part of 'attendance_bloc.dart';

abstract class AttendanceState {}

class Init extends AttendanceState {
  List<Object?> get props => [];
}

class OnAttendanceDataLoading extends AttendanceState {
  List<Object?> get props => [];
}

class OnAttendanceSuccess extends AttendanceState {
  final ApiEntity<AttendanceListEntity> attendanceEntity;

  OnAttendanceSuccess({required this.attendanceEntity});
  List<Object?> get props => [attendanceEntity];
}

class OnAttendanceSubmitSuccess extends AttendanceState {
  final String attendanceSubmitResponse;

  OnAttendanceSubmitSuccess({required this.attendanceSubmitResponse});
  List<Object?> get props => [attendanceSubmitResponse];
}

class OnUserDetailsSuccess extends AttendanceState {
  final ApiEntity<AttendanceUserDetailsEntity> attendanceUserDetailsEntity;

  OnUserDetailsSuccess({required this.attendanceUserDetailsEntity});
  List<Object?> get props => [attendanceUserDetailsEntity];
}

class OnAttendanceApiError extends AttendanceState {
  final String message;

  OnAttendanceApiError({required this.message});
  List<Object?> get props => [message];
}
