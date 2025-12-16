import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/domain/entities/attendance_list_entity.dart';
import 'package:malomati/domain/entities/attendance_user_details_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';
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

  Future<void> getAttendance(
      {required Map<String, dynamic> requestParams,
      bool returnValue = false}) async {
    //emit(OnAttendanceDataLoading());
    final result = await attendanceUseCase.getAttendanceReport(
        requestParams: requestParams);
    _attendanceReport.sink.add(result.fold((l) => ApiEntity(), (r) => r));
    if (returnValue) {
      emit(result.fold(
          (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
          (r) => OnAttendanceSuccess(attendanceEntity: r)));
    }
  }

  Future<AttendanceState> getAttendanceByID(
      {required Map<String, dynamic> requestParams,
      bool returnValue = false}) async {
    //emit(OnAttendanceDataLoading());
    final result = await attendanceUseCase.getAttendanceReport(
        requestParams: requestParams);
    //_attendanceReport.sink.add(result.fold((l) => ApiEntity(), (r) => r));

    return (result.fold(
        (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
        (r) => OnAttendanceSuccess(attendanceEntity: r)));
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

  Future<AttendanceState> getUserDetails(
      {String apiUrl = attendanceUserDetailsApiUrl,
      required Map<String, dynamic> requestParams,
      bool showLoading = false,
      bool emitResult = true}) async {
    if (showLoading) {
      emit(OnAttendanceDataLoading());
    }

    final result = await attendanceUseCase.getUserDetails(apiUrl,
        requestParams: requestParams);
    if (emitResult) {
      emit(result.fold(
          (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
          (r) => OnUserDetailsSuccess(attendanceUserDetailsEntity: r)));
    }
    return (result.fold(
        (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
        (r) => OnUserDetailsSuccess(attendanceUserDetailsEntity: r)));
  }

  Future<AttendanceState> setUserDetails(
      {String apiUrl = setUserPunchAccessApiUrl,
      required Map<String, dynamic> requestParams,
      bool showLoading = false,
      bool emitResult = true}) async {
    if (showLoading) {
      emit(OnAttendanceDataLoading());
    }

    final result = await attendanceUseCase.getUserDetails(apiUrl,
        requestParams: requestParams);
    if (emitResult) {
      emit(result.fold(
          (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
          (r) => OnUserDetailsSuccess(attendanceUserDetailsEntity: r)));
    }
    return (result.fold(
        (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
        (r) => OnUserDetailsSuccess(attendanceUserDetailsEntity: r)));
  }

  Future<AttendanceState> submitOfficialInReason(
      {required Map<String, dynamic> requestParams}) async {
    final result = await attendanceUseCase.submitOfficialInReason(
        requestParams: requestParams);
    return (result.fold(
        (l) => OnAttendanceApiError(message: _getErrorMessage(l)),
        (r) => OnApiResponse(apiEntity: r)));
  }

  Future<List<AttendanceEntity>> getDoorAttendanceReport({
    required String apiUrl,
  }) async {
    emit(OnAttendanceDataLoading());

    final result = await attendanceUseCase.getAttendanceDetails(
        apiUrl: '$attendanceDoorDetailsApiUrl$apiUrl', requestParams: {});
    return (result.fold((l) => [], (r) => r.entity?.attendanceList ?? []));
  }

  Future<List<AttendanceEntity>> getTAAttendanceReport({
    required String apiUrl,
  }) async {
    emit(OnAttendanceDataLoading());
    final result = await attendanceUseCase.getAttendanceDetails(
        apiUrl: '$attendanceDetailsApiUrl$apiUrl', requestParams: {});
    return (result.fold((l) => [], (r) => r.entity?.attendanceList ?? []));
  }

  Future<List<AttendanceEntity>> getLateDoorReport({
    required String apiUrl,
  }) async {
    final result = await Future.wait([
      getDoorAttendanceReport(
        apiUrl: apiUrl,
      ),
      getTAAttendanceReport(
        apiUrl: apiUrl,
      )
    ]);
    return combineAcsAndTa(acs: result[0], ta: result[1]);
  }

  List<AttendanceEntity> combineAcsAndTa({
    required List<AttendanceEntity> acs,
    required List<AttendanceEntity> ta,
  }) {
    final Map<String, AttendanceEntity> result = {};

    void process(
      List<AttendanceEntity> list,
      int accessType,
    ) {
      for (final e in list) {
        final userId = e.userid;
        final username = e.username;
        final type = e.entryexittype;
        final time =
            getDateTimeByString('dd/MM/yyyy HH:mm:ss', e.eventdatetime ?? '');

        result.putIfAbsent(
            userId ?? '',
            () => AttendanceEntity()
              ..userid = userId
              ..username = username);

        final record = result[userId]!;

        if (type == '0') {
          // IN → earliest
          if (accessType == 0 &&
              (record.acsEventIn == null ||
                  time.isBefore(getDateTimeByString(
                      'dd/MM/yyyy HH:mm:ss', record.eventdatetime ?? '')))) {
            record.acsEventIn = e.eventdatetime;
          } else if (accessType == 1 &&
              (record.taEventIn == null ||
                  time.isBefore(getDateTimeByString(
                      'dd/MM/yyyy HH:mm:ss', record.eventdatetime ?? '')))) {
            record.taEventIn = e.eventdatetime;
          }
        }
        // else if (type == '1') {
        //   // OUT → latest
        //   if ((accessType == 0 && record.acsEventOut == null) ||
        //       time.isBefore(getDateTimeByString(
        //           'dd/MM/yyyy HH:mm:ss', record.eventdatetime ?? ''))) {
        //     record.acsEventOut = e.eventdatetime;
        //   } else if (record.taeventOut == null ||
        //       time.isBefore(getDateTimeByString(
        //           'dd/MM/yyyy HH:mm:ss', record.eventdatetime ?? ''))) {
        //     record.taeventOut = e.eventdatetime;
        //   }
        // }
      }
    }

    process(acs, 0);
    process(ta, 1);

    return filterTaVsAcsIn(result.values.toList());
  }

  List<AttendanceEntity> filterTaVsAcsIn(
    List<AttendanceEntity> combinedList,
  ) {
    return combinedList
        .map((e) {
          final taIn = e.taEventIn;
          final acsIn = e.acsEventIn;

          if (taIn == null || acsIn == null) return e;

          final taTime = getDateTimeByString('dd/MM/yyyy HH:mm:ss', taIn);
          final acsTime = getDateTimeByString('dd/MM/yyyy HH:mm:ss', acsIn);

          final diffMinutes = acsTime.difference(taTime).inMinutes.abs();

          e.taToAcsInDiff = diffMinutes;

          return e;
        })
        .where((e) => e.taToAcsInDiff > 10)
        .toList();
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
