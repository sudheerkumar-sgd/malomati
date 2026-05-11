import 'package:flutter/material.dart';
import 'package:flutter_app_badge_control/flutter_app_badge_control.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/core/managers/dashboard_leave_balances.dart';
import 'package:malomati/domain/entities/dashboard_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/domain/entities/weather_entity.dart';
import 'package:malomati/features/home/presentation/bloc/home_bloc.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';

/// Applies [HomeBloc] emissions to global session config and local notifiers.
/// Keeps side-effect logic out of the widget build method.
class HomeSessionSideEffects {
  HomeSessionSideEffects._();

  static void applyFromHomeState(
    BuildContext context,
    HomeState state, {
    required ValueNotifier<DashboardEntity> dashboardEntity,
    required ValueNotifier<List<EventsEntity>> eventsListEntity,
    required ValueNotifier<List<FavoriteEntity>> favoriteEntity,
    required ValueNotifier<WeatherEntity> weatherEntity,
  }) {
    if (state is OnLoading) {
      Dialogs.loader(context);
      return;
    }
    if (state is OnDashboardSuccess) {
      final entity = state.dashboardEntity.entity ?? DashboardEntity();
      dashboardEntity.value = entity;
      sl<DashboardLeaveBalances>().update(
        annual: '${entity.aNNUALACCRUAL ?? '0'} ${context.string.days}',
        sick: '${entity.sICKACCRUAL ?? '0'} ${context.string.days}',
        permission:
            '${entity.pERMISSIONACCRUAL ?? '0'} ${context.string.hours}',
      );
      ConstantConfig.cancelInvoiceUsers =
          state.dashboardEntity.entity?.cANCELINVOICEUSERS ?? '';
      return;
    }
    if (state is OnEventsSuccess) {
      eventsListEntity.value =
          state.eventsListEntity.entity?.eventsList ?? [];
      return;
    }
    if (state is OnFavoriteSuccess) {
      favoriteEntity.value = [];
      favoriteEntity.value = state.favoriteEntity;
      return;
    }
    if (state is OnRequestsCountSuccess) {
      ConstantConfig.hrApprovalCount = state.requestsCountEntity.hRCOUNT ?? 0;
      ConstantConfig.financePOApprovalCount =
          state.requestsCountEntity.pOCOUNT ?? 0;
      ConstantConfig.financePRApprovalCount =
          state.requestsCountEntity.pRCOUNT ?? 0;
      ConstantConfig.financeINVApprovalCount =
          state.requestsCountEntity.iNVCOUNT ?? 0;
      ConstantConfig.requestsApprovalCount =
          state.requestsCountEntity.requestsApprovalCount ?? 0;
      ConstantConfig.requestsRejectCount =
          state.requestsCountEntity.requestsRejectCount ?? 0;
      ConstantConfig.requestsPendingCount =
          state.requestsCountEntity.requestsPendingCount ?? 0;
      ConstantConfig.isApprovalCountChange.value =
          !(ConstantConfig.isApprovalCountChange.value);
      FlutterAppBadgeControl.isAppBadgeSupported().then((value) =>
          FlutterAppBadgeControl.updateBadgeCount(
              ConstantConfig.hrApprovalCount +
                  ConstantConfig.financePOApprovalCount +
                  ConstantConfig.financePRApprovalCount +
                  ConstantConfig.financeINVApprovalCount));
      return;
    }
    if (state is OnNotificationsListSuccess) {
      final openedNotifications =
          context.userDB.get(openedNotificationsKey, defaultValue: '');
      final list = state.notificationsList
          .where((element) =>
              !openedNotifications.contains('${element.nOTIFICATIONID}'))
          .toList();
      ConstantConfig.notificationsCount = list.length;
      ConstantConfig.isApprovalCountChange.value =
          !(ConstantConfig.isApprovalCountChange.value);
      return;
    }
    if (state is OnWeatherReportSuccess) {
      context.userDB.put(lastTemperature, state.weatherEntity.temperature);
      context.userDB.put(lastWeathercode, state.weatherEntity.weathercode);
      context.userDB.put(lastWeatherCheckDate, DateTime.now());
      weatherEntity.value = state.weatherEntity;
      return;
    }
    if (state is OnApiError) {
      printLog(message: state.message);
    }
  }
}
