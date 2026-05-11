import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/requests_count_entity.dart';
import 'package:malomati/domain/entities/weather_entity.dart';
import 'package:malomati/domain/repository/home_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class HomeUseCase extends BaseUseCase {
  final HomeRepository homeRepository;
  HomeUseCase({required this.homeRepository});

  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    return await homeRepository.getDashboardData(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<EventsListEntity>>> getEventsData(
      {required Map<String, dynamic> requestParams}) async {
    return await homeRepository.getEventsData(requestParams: requestParams);
  }

  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams}) async {
    return await homeRepository.getRequestsCount(requestParams: requestParams);
  }

  Future<Either<Failure, List<FinanceApprovalEntity>>> getNotificationsList(
      {required Map<String, dynamic> requestParams}) async {
    return await homeRepository.getNotificationsList(
        requestParams: requestParams);
  }

  Future<Either<Failure, WeatherEntity>> getWeatherReport(
      {required Map<String, dynamic> requestParams}) async {
    return await homeRepository.getWeatherReport(requestParams: requestParams);
  }

  Future<Either<Failure, List<FavoriteEntity>>> getFavoritesData(
      {required Box userDB}) async {
    try {
      var favoriteData = userDB.get(favoriteKey, defaultValue: []) as List;
      if (favoriteData.isEmpty) {
        userDB.put(favoriteKey, sl<ConstantConfig>().dashboardFavorites);
        favoriteData = sl<ConstantConfig>().dashboardFavorites;
      }
      final result = favoriteData
          .map((eventJson) =>
              FavoriteEntity.fromJson(eventJson).toFavoriteEntity)
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<FavoriteEntity>>> saveFavoritesData(
      {required Box userDB, required FavoriteEntity favoriteEntity}) async {
    try {
      var favoriteData = userDB.get(favoriteKey, defaultValue: []) as List;
      var favorites = favoriteData;
      var index =
          favorites.indexWhere((element) => element['name'] == favoriteAdd);
      favorites.removeAt(index);
      favorites.insert(index, {
        'id': favoriteEntity.id ?? 0,
        'name': '${favoriteEntity.name}',
        'nameAR': '${favoriteEntity.nameAR}',
        'iconPath': '${favoriteEntity.iconPath}',
      });
      userDB.put(favoriteKey, favorites);
      favoriteData = userDB.get(favoriteKey, defaultValue: []) as List;
      final result = favoriteData
          .map((eventJson) =>
              FavoriteEntity.fromJson(eventJson).toFavoriteEntity)
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<FavoriteEntity>>> removeFavoritesData(
      {required Box userDB, required FavoriteEntity favoriteEntity}) async {
    try {
      var favoriteData = userDB.get(favoriteKey, defaultValue: []) as List;
      var favorites = favoriteData;
      var index = favorites
          .indexWhere((element) => element['name'] == favoriteEntity.name);
      favorites.removeAt(index);
      favorites.insert(favoriteData.length, {
        'name': favoriteAdd,
        'nameAR': favoriteAddAR,
        'iconPath': DrawableAssets.icServiceAdd,
      });
      userDB.put(favoriteKey, favorites);
      favoriteData = userDB.get(favoriteKey, defaultValue: []) as List;
      final result = favoriteData
          .map((eventJson) =>
              FavoriteEntity.fromJson(eventJson).toFavoriteEntity)
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AccessToken>> getFCMAccessToken(
      {required Box userDB}) async {
    try {
      var accessTokenData = userDB.get(accessTokenDataKey, defaultValue: '');
      if (accessTokenData.isNotEmpty) {
        final json = jsonDecode(accessTokenData);
        final accessToken = AccessToken(
            json['type'], json['data'], DateTime.parse(json['expiry']));
        if (!accessToken.hasExpired) {
          ConstantConfig.fcmAccessTokenJson = accessToken;
          return Right(accessToken);
        }
      }
      final result = await homeRepository.getFCMAccessToken();
      return result.fold((l) => Left(ServerFailure(l.errorMessage)), (r) {
        ConstantConfig.fcmAccessTokenJson = r;
        userDB.put(accessTokenDataKey, jsonEncode(r.toJson()));
        return Right(r);
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
