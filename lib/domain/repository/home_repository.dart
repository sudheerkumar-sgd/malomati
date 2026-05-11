import 'package:dartz/dartz.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:malomati/core/error/failures.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import 'package:malomati/domain/entities/requests_count_entity.dart';
import 'package:malomati/domain/entities/weather_entity.dart';

import '../entities/finance_approval_entity.dart';

/// Dashboard, events, counts, weather, FCM token — home/dashboard feature.
abstract class HomeRepository {
  Future<Either<Failure, ApiEntity<DashboardEntity>>> getDashboardData(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, ApiEntity<EventsListEntity>>> getEventsData(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, RequestsCountEntity>> getRequestsCount(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, List<FinanceApprovalEntity>>> getNotificationsList(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, WeatherEntity>> getWeatherReport(
      {required Map<String, dynamic> requestParams});
  Future<Either<Failure, AccessToken>> getFCMAccessToken();
}
