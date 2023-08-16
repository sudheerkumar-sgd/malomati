part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {}

class Init extends AttendanceState {
  @override
  List<Object?> get props => [];
}

class OnAttendanceDataLoading extends AttendanceState {
  @override
  List<Object?> get props => [];
}

class OnAttendanceSuccess extends AttendanceState {
  final ApiEntity<AttendanceListEntity> attendanceEntity;

  OnAttendanceSuccess({required this.attendanceEntity});
  @override
  List<Object?> get props => [attendanceEntity];
}

class OnAttendanceSubmitSuccess extends AttendanceState {
  final String attendanceSubmitResponse;

  OnAttendanceSubmitSuccess({required this.attendanceSubmitResponse});
  @override
  List<Object?> get props => [attendanceSubmitResponse];
}

class OnAttendanceApiError extends AttendanceState {
  final String message;

  OnAttendanceApiError({required this.message});
  @override
  List<Object?> get props => [message];
}
