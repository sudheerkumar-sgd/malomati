import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/domain/entities/attendance_list_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import '../../../domain/entities/favorite_entity.dart';
import '../../../domain/use_case/home_usecase.dart';

part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;
  HomeBloc({required this.homeUseCase}) : super(Init());

  Future<void> getAttendance({required String dateRange}) async {
    emit(OnLoading());

    Map<String, dynamic> requestParams = {
      'date-range': dateRange,
    };
    final result =
        await homeUseCase.getAttendance(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnAttendanceSuccess(attendanceEntity: r)));
  }

  Future<void> getDashboardData({required String userName}) async {
    emit(OnLoading());
    Map<String, dynamic> requestParams = {
      'USER_NAME': userName,
    };
    final result =
        await homeUseCase.getDashboardData(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnDashboardSuccess(dashboardEntity: r)));
  }

  Future<void> getFavoritesdData({required Box userDB}) async {
    final result = await homeUseCase.getFavoritesData(userDB: userDB);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnFavoriteSuccess(favoriteEntity: r)));
  }

  Future<void> saveFavoritesdData(
      {required Box userDB, required FavoriteEntity favoriteEntity}) async {
    final result = await homeUseCase.saveFavoritesData(
        userDB: userDB, favoriteEntity: favoriteEntity);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnFavoriteSuccess(favoriteEntity: r)));
  }

  Future<void> removeFavoritesdData(
      {required Box userDB, required FavoriteEntity favoriteEntity}) async {
    final result = await homeUseCase.removeFavoritesData(
        userDB: userDB, favoriteEntity: favoriteEntity);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnFavoriteSuccess(favoriteEntity: r)));
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
