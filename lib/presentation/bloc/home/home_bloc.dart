import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/use_case/home_usecase.dart';

part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;
  HomeBloc({required this.homeUseCase}) : super(Init());

  Future<void> getAttendance(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnLoading());

    final result =
        await homeUseCase.getAttendance(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnAttendanceSuccess(attendanceEntity: r)));
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
