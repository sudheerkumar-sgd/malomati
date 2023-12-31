import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/api_entity.dart';
import '../../../domain/entities/favorite_entity.dart';
import '../../../domain/entities/finance_approval_entity.dart';
import '../../../domain/entities/requests_count_entity.dart';
import '../../../domain/use_case/home_usecase.dart';

part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  final HomeUseCase homeUseCase;
  HomeBloc({required this.homeUseCase}) : super(Init());

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

  Future<void> getEventsData({required String departmentId}) async {
    emit(OnLoading());
    Map<String, dynamic> requestParams = {
      'DEPARTMENT_ID': departmentId,
    };
    final result =
        await homeUseCase.getEventsData(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnEventsSuccess(eventsListEntity: r)));
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

  Future<void> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await homeUseCase.getRequestsCount(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnRequestsCountSuccess(requestsCountEntity: r)));
  }

  Future<void> getNotificationsList(
      {required Map<String, dynamic> requestParams}) async {
    final result =
        await homeUseCase.getNotificationsList(requestParams: requestParams);
    emit(result.fold((l) => OnApiError(message: _getErrorMessage(l)),
        (r) => OnNotificationsListSuccess(notificationsList: r)));
  }

  String _getErrorMessage(Failure failure) {
    return failure.errorMessage;
  }
}
