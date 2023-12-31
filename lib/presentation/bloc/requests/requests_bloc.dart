import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/attendance_list_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import '../../../domain/use_case/requests_usecase.dart';
import 'package:rxdart/rxdart.dart';

part 'requests_state.dart';

class RequestsBloc extends Cubit<RequestsState> {
  final RequestsUseCase requestsUseCase;
  RequestsBloc({required this.requestsUseCase}) : super(Init());

  final BehaviorSubject<ApiEntity<AttendanceListEntity>> _attendanceReport =
      BehaviorSubject<ApiEntity<AttendanceListEntity>>();
  final BehaviorSubject<ApiEntity<AttendanceListEntity>> _attendanceDetails =
      BehaviorSubject<ApiEntity<AttendanceListEntity>>();

  Future<void> getAttendance({required String dateRange}) async {
    emit(OnRequestsDataLoading());

    Map<String, dynamic> requestParams = {
      'date-range': dateRange,
    };
    final result =
        await requestsUseCase.getAttendanceReport(requestParams: requestParams);
    _attendanceReport.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    // emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
    //     (r) => OnAttendanceSuccess(attendanceEntity: r)));
  }

  Future<void> getAttendanceDetails({required String dateRange}) async {
    emit(OnRequestsDataLoading());

    Map<String, dynamic> requestParams = {
      'date-range': dateRange,
    };
    final result = await requestsUseCase.getAttendanceDetails(
        requestParams: requestParams);
    _attendanceDetails.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    // emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
    //     (r) => OnAttendanceSuccess(attendanceEntity: r)));
  }

  Stream<List<AttendanceEntity>> get getAttendanceReport =>
      Rx.combineLatest2(_attendanceReport.stream, _attendanceDetails.stream,
          (ApiEntity<AttendanceListEntity> attendanceReport,
              ApiEntity<AttendanceListEntity> attendanceDetails) {
        for (var attendance in attendanceReport.entity?.attendanceList ?? []) {
          for (var details in attendanceDetails.entity?.attendanceList ?? []) {
            attendance.gpsLatitude = details.gpsLatitude;
            attendance.gpsLongitude = details.gpsLongitude;
          }
        }
        return (attendanceReport.entity?.attendanceList ?? [])
            .reversed
            .toList();
      });

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
