import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/attendance_list_entity.dart';
import 'package:malomati/domain/use_case/attendance_usecase.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import 'package:rxdart/rxdart.dart';

part 'attendance_state.dart';

class AttendanceBloc extends Cubit<AttendanceState> {
  final AttendanceUseCase attendanceUseCase;
  AttendanceBloc({required this.attendanceUseCase}) : super(Init());

  final BehaviorSubject<ApiEntity<AttendanceListEntity>> _attendanceReport =
      BehaviorSubject<ApiEntity<AttendanceListEntity>>();
  final BehaviorSubject<ApiEntity<AttendanceListEntity>> _attendanceDetails =
      BehaviorSubject<ApiEntity<AttendanceListEntity>>();

  Future<void> getAttendance({required String dateRange}) async {
    emit(OnAttendanceDataLoading());

    Map<String, dynamic> requestParams = {
      'date-range': dateRange,
    };
    final result = await attendanceUseCase.getAttendanceReport(
        requestParams: requestParams);
    _attendanceReport.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    // emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
    //     (r) => OnAttendanceSuccess(attendanceEntity: r)));
  }

  Future<void> getAttendanceDetails({required String dateRange}) async {
    emit(OnAttendanceDataLoading());

    Map<String, dynamic> requestParams = {
      'date-range': dateRange,
    };
    final result = await attendanceUseCase.getAttendanceDetails(
        requestParams: requestParams);
    _attendanceDetails.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    // emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
    //     (r) => OnAttendanceSuccess(attendanceEntity: r)));
  }

  Stream<AttendanceEntity> get getAttendanceData =>
      Rx.combineLatest2(_attendanceReport.stream, _attendanceDetails.stream,
          (ApiEntity<AttendanceListEntity> attendanceReport,
              ApiEntity<AttendanceListEntity> attendanceDetails) {
        for (var attendance in attendanceReport.entity?.attendanceList ?? []) {
          for (var details in attendanceDetails.entity?.attendanceList ?? []) {
            attendance.gpsLatitude = details.gpsLatitude;
            attendance.gpsLongitude = details.gpsLongitude;
          }
        }
        return attendanceReport.entity?.attendanceList.firstOrNull ??
            AttendanceEntity();
      });
  Stream<List<AttendanceEntity>> get getAttendanceReport =>
      Rx.combineLatest2(_attendanceReport.stream, _attendanceDetails.stream,
          (ApiEntity<AttendanceListEntity> attendanceReport,
              ApiEntity<AttendanceListEntity> attendanceDetails) {
        for (var attendance in attendanceReport.entity?.attendanceList ?? []) {
          final details = attendanceDetails.entity?.attendanceList
              .firstWhereOrNull(
                  (element) => element.edate == attendance.processdate);
          attendance.gpsLatitude = details?.gpsLatitude;
          attendance.gpsLongitude = details?.gpsLongitude;
        }
        return (attendanceReport.entity?.attendanceList ?? [])
            .reversed
            .toList();
      });

  Future<void> submitAttendance(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnAttendanceDataLoading());

    final result = await attendanceUseCase.submitAttendanceDetails(
        requestParams: requestParams);
    emit(result.fold((l) => OnAttendanceApiError(message: _getErrorMessage(l)),
        (r) => OnAttendanceSubmitSuccess(attendanceSubmitResponse: r)));
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).errorMessage;
      default:
        return 'An unknown error has occured';
    }
  }
}
