import 'package:flutter/material.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';

import '../core/constants/constants.dart';
import '../res/drawables/drawable_assets.dart';

class ConstantConfig {
  final services = [
    FavoriteEntity(
        id: 1,
        name: 'HR Approvals',
        nameAR: 'موافقات الموارد البشرية',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        id: 2,
        name: 'Finance Approvals',
        nameAR: 'موافقات المالية',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        id: 3,
        name: 'Annual Leaves',
        nameAR: 'الإجازة الدورية',
        iconPath: DrawableAssets.icAnualleaves),
    FavoriteEntity(
        id: 4,
        name: 'Permission',
        nameAR: 'إذن خروج',
        iconPath: DrawableAssets.icServicePermission),
    FavoriteEntity(
        id: 5,
        name: 'Sick Leaves',
        nameAR: 'اجازة مرضية',
        iconPath: DrawableAssets.icSickleaves),
    FavoriteEntity(
        id: 6,
        name: 'Mission Leaves',
        nameAR: 'اجازة مهمة رسمية',
        iconPath: DrawableAssets.icMissionleaves),
    FavoriteEntity(
        id: 7,
        name: 'Other Leaves',
        nameAR: 'الإجازات اخرى',
        iconPath: DrawableAssets.icServiceLeave),
    FavoriteEntity(
        id: 8,
        name: 'Initiatives',
        nameAR: 'المبادرات',
        iconPath: DrawableAssets.icInitiatives),
    FavoriteEntity(
        id: 9,
        name: 'Certificates',
        nameAR: 'شهادة الراتب',
        iconPath: DrawableAssets.icServiceCertificate),
    FavoriteEntity(
        id: 10,
        name: 'Thank You',
        nameAR: 'شكراً لك',
        iconPath: DrawableAssets.icServiceThankyou),
    FavoriteEntity(
        id: 11,
        name: 'Payslip',
        nameAR: 'كشف الراتب',
        iconPath: DrawableAssets.icPayslip),
    FavoriteEntity(
        id: 12,
        name: 'Advance Salary',
        nameAR: 'راتب الإجازة',
        iconPath: DrawableAssets.icAdvancesalary),
    FavoriteEntity(
        id: 13,
        name: 'Overtime',
        nameAR: 'العمل الإضافي',
        iconPath: DrawableAssets.icOvertime),
    FavoriteEntity(
        id: 14,
        name: 'Badge',
        nameAR: 'بطاقة العمل',
        iconPath: DrawableAssets.icBadge),
    FavoriteEntity(
        id: 15,
        name: 'Delete Leave',
        nameAR: 'حذف الإجازة',
        iconPath: DrawableAssets.icDeleteLeave),
    FavoriteEntity(
        id: 16,
        name: 'Warning',
        nameAR: 'التحذير',
        iconPath: DrawableAssets.icWarning),
    FavoriteEntity(
        id: 19,
        name: 'View Warning',
        nameAR: 'مشاهدة التحذير',
        iconPath: DrawableAssets.icViewWarning),
    FavoriteEntity(
        id: 17,
        name: 'Holidays',
        nameAR: 'العطلات',
        iconPath: DrawableAssets.icEvent),
    FavoriteEntity(
        id: 18,
        name: 'My Team',
        nameAR: 'فريقي',
        iconPath: DrawableAssets.icMyteam),
  ];
  final managerServices = [
    FavoriteEntity(
        id: 1,
        name: 'HR Approvals',
        nameAR: 'موافقات الموارد البشرية',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        id: 2,
        name: 'Finance Approvals',
        nameAR: 'موافقات المالية',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        id: 18,
        name: 'My Team',
        nameAR: 'فريقي',
        iconPath: DrawableAssets.icMyteam),
    FavoriteEntity(
        id: 16,
        name: 'Warning',
        nameAR: 'التحذير',
        iconPath: DrawableAssets.icWarning),
  ];
  final guestServices = [
    FavoriteEntity(
        id: 31, name: 'Jobs', nameAR: 'وظائف', iconPath: DrawableAssets.icJobs),
    FavoriteEntity(
        id: 17,
        name: 'Holidays',
        nameAR: 'العطلات',
        iconPath: DrawableAssets.icEvent),
    FavoriteEntity(
        id: 32,
        name: 'UAQ Apps',
        nameAR: 'تطبيقات',
        iconPath: DrawableAssets.icApps),
  ];

  final dashboardFavorites = [
    {
      'id': 3,
      'name': 'Annual Leaves',
      'nameAR': 'الإجازة الدورية',
      'iconPath': DrawableAssets.icAnualleaves
    },
    {
      'id': 4,
      'name': 'Permission',
      'nameAR': 'إذن خروج',
      'iconPath': DrawableAssets.icServicePermission
    },
    {
      'id': 10,
      'name': 'Thank You',
      'nameAR': 'شكراً لك',
      'iconPath': DrawableAssets.icServiceThankyou
    },
    {
      'id': 0,
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
    {
      'id': 0,
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
    {
      'id': 0,
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
  ];

  List<FavoriteEntity> getServicesByManager(
      {required bool isManager, bool isGuest = false}) {
    if (isGuest) {
      return guestServices;
    }
    return isManager
        ? services
        : services
            .where((element) => !managerServices.contains(element))
            .toList();
  }

  final leaveTypes = {
    "LeaveTypeList": [
      {
        "NAME": "Annual Leave",
        "NAME_AR": "الأجازة الدورية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 61,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Compassionate Leave",
        "NAME_AR": "إجازة حداد",
        "ABSENCE_ATTENDANCE_TYPE_ID": 62,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Escort Leave International",
        "NAME_AR": "أجازة مرافقة دولية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 2062,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Escort Leave National",
        "NAME_AR": "إجازة مرافقة محلية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 64,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exam Leave",
        "NAME_AR": "إجازة امتحان",
        "ABSENCE_ATTENDANCE_TYPE_ID": 66,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exam day leave",
        "NAME_AR": "إجازة يوم الامتحان",
        "ABSENCE_ATTENDANCE_TYPE_ID": 67,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exceptional Mission Leave",
        "NAME_AR": "أجازة مهمة رسمية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 68,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Hajj Leave",
        "NAME_AR": "إجازة الحج",
        "ABSENCE_ATTENDANCE_TYPE_ID": 69,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Maternity Leave",
        "NAME_AR": "إجازة أمومة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 70,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "National Service",
        "NAME_AR": "الخدمة الوطنية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 71,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Nursing Hours",
        "NAME_AR": "ساعات الإرضاع",
        "ABSENCE_ATTENDANCE_TYPE_ID": 72,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Occupational Injury",
        "NAME_AR": "إصابة عمل",
        "ABSENCE_ATTENDANCE_TYPE_ID": 73,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Overtime leave",
        "NAME_AR": "إجازة الأيام البديلة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 63,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Paternity Leave",
        "NAME_AR": "إجازة الأبوة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 74,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Permission",
        "NAME_AR": "إذن خروج",
        "ABSENCE_ATTENDANCE_TYPE_ID": 75,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Sick Leave",
        "NAME_AR": "إجازة مرضية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 76,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Sick Leave Extension",
        "NAME_AR": "تمديد لإجازة مرضية",
        "ABSENCE_ATTENDANCE_TYPE_ID": 77,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Spouse Escort Leave",
        "NAME_AR": "إجازة مرافقة الزوج",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1061,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Study Leave Full",
        "NAME_AR": "إجازة دراسة كاملة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1062,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Study Leave Partial Permission",
        "NAME_AR": "إجازة دراسة بإذن جزئي",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1063,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Uddah Leave",
        "NAME_AR": "إجازة العدّة",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1064,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Unauthorized Absence",
        "NAME_AR": "إنقطاع عن العمل ",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1066,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Unpaid Leave",
        "NAME_AR": "إجازة غير مدفوعة الاجر",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1065,
        "HOURS_OR_DAYS": "D"
      }
    ]
  };
  static ValueNotifier<bool> isApprovalCountChange = ValueNotifier(false);
  static int hrApprovalCount = 0;
  static int financePOApprovalCount = 0;
  static int financePRApprovalCount = 0;
  static int financeINVApprovalCount = 0;
  static int requestsApprovalCount = 0;
  static int requestsRejectCount = 0;
  static int requestsPendingCount = 0;
  static int notificationsCount = 0;
  static int badgeCount = 0;
  static ValueNotifier<Map<String, dynamic>?> onFCMMessageReceived =
      ValueNotifier(null);
  static const fcmServerApiKey =
      'AAAAW47t3kQ:APA91bFuEWK4MWc7bVSf24RYAdcBuSPIeu4CLhOV2qOp_UctljSHas5BvNngpFNf_OQVAOWXtuNSjNOdbOqWpXRUscryDK8sPqTGUnVk2qrtwVs21eOVr8mK9sDhcotgxKslSm6vB3LW';
}
