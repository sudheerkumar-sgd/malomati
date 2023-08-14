import 'package:dartz/dartz.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../config/constant_config.dart';
import '../../core/constants/constants.dart';
import '../../core/error/failures.dart';
import '../../injection_container.dart';
import '../entities/attendance_list_entity.dart';
import '../entities/favorite_entity.dart';

class HomeUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  HomeUseCase({required this.apisRepository});

  Future<Either<Failure, ApiEntity<AttendanceListEntity>>> getAttendance(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getAttendance(requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getDashboardData(requestParams: requestParams);
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
        'name': favoriteEntity.name,
        'nameAR': favoriteEntity.nameAR,
        'iconPath': favoriteEntity.iconPath,
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
}
