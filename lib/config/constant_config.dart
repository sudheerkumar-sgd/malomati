import 'package:malomati/domain/entities/favorite_entity.dart';

import '../core/constants/constants.dart';
import '../res/drawables/drawable_assets.dart';

class ConstantConfig {
  final services = [
    FavoriteEntity(
        name: 'HR Approvals',
        nameAR: 'موافقات الموارد البشرية',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        name: 'Finance Approvals',
        nameAR: 'الموافقات المالية',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        name: 'Annual Leaves',
        nameAR: 'الإجازات السنوية',
        iconPath: DrawableAssets.icAnualleaves),
    FavoriteEntity(
        name: 'Permission',
        nameAR: 'إستئذان',
        iconPath: DrawableAssets.icServicePermission),
    FavoriteEntity(
        name: 'Sick Leaves',
        nameAR: 'الإجازات المرضية',
        iconPath: DrawableAssets.icSickleaves),
    FavoriteEntity(
        name: 'Mission Leaves',
        nameAR: 'Mission Leaves',
        iconPath: DrawableAssets.icMissionleaves),
    FavoriteEntity(
        name: 'Other Leaves',
        nameAR: 'Other Leaves',
        iconPath: DrawableAssets.icServiceLeave),
    FavoriteEntity(
        name: 'Attendance',
        nameAR: 'حضور',
        iconPath: DrawableAssets.icServiceAttendance),
    FavoriteEntity(
        name: 'Initiatives',
        nameAR: 'المبادرات',
        iconPath: DrawableAssets.icInitiatives),
    FavoriteEntity(
        name: 'Certificates',
        nameAR: 'شهادات',
        iconPath: DrawableAssets.icServiceCertificate),
    FavoriteEntity(
        name: 'Thank You',
        nameAR: 'شكراً لك',
        iconPath: DrawableAssets.icServiceThankyou),
    FavoriteEntity(
        name: 'Payslip',
        nameAR: 'كشف الراتب',
        iconPath: DrawableAssets.icPayslip),
    FavoriteEntity(
        name: 'Advance Salary',
        nameAR: 'راتب مقدما',
        iconPath: DrawableAssets.icAdvancesalary),
    FavoriteEntity(
        name: 'Overtime',
        nameAR: 'العمل الإضافي',
        iconPath: DrawableAssets.icOvertime),
    FavoriteEntity(
        name: 'Badge', nameAR: 'Badge', iconPath: DrawableAssets.icBadge),
    FavoriteEntity(
        name: 'My Team', nameAR: 'فريقي', iconPath: DrawableAssets.icMyteam),
  ];
  final managerServices = [
    FavoriteEntity(
        name: 'HR Approvals',
        nameAR: 'موافقات الموارد البشرية',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        name: 'Finance Approvals',
        nameAR: 'الموافقات المالية',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        name: 'My Team', nameAR: 'فريقي', iconPath: DrawableAssets.icMyteam),
  ];
  final dashboardFavorites = [
    {
      'name': 'Annual Leaves',
      'nameAR': 'الإجازات السنوية',
      'iconPath': DrawableAssets.icAnualleaves
    },
    {
      'name': 'Permission',
      'nameAR': 'إستئذان',
      'iconPath': DrawableAssets.icServicePermission
    },
    {
      'name': 'Attendance',
      'nameAR': 'حضور',
      'iconPath': DrawableAssets.icServiceAttendance
    },
    {
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
    {
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
    {
      'name': favoriteAdd,
      'nameAR': favoriteAddAR,
      'iconPath': DrawableAssets.icServiceAdd
    },
  ];

  List<FavoriteEntity> getServicesByManager({required bool isManager}) {
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
        "ABSENCE_ATTENDANCE_TYPE_ID": 61,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Compassionate Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 62,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Escort Leave International",
        "ABSENCE_ATTENDANCE_TYPE_ID": 2062,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Escort Leave National",
        "ABSENCE_ATTENDANCE_TYPE_ID": 64,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exam Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 66,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exam day leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 67,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Exceptional Mission Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 68,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Hajj Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 69,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Maternity Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 70,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "National Service",
        "ABSENCE_ATTENDANCE_TYPE_ID": 71,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Nursing Hours",
        "ABSENCE_ATTENDANCE_TYPE_ID": 72,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Occupational Injury",
        "ABSENCE_ATTENDANCE_TYPE_ID": 73,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Overtime leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 63,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Paternity Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 74,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Permission",
        "ABSENCE_ATTENDANCE_TYPE_ID": 75,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Sick Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 76,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Sick Leave Extension",
        "ABSENCE_ATTENDANCE_TYPE_ID": 77,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Spouse Escort Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1061,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Study Leave Full",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1062,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Study Leave Partial Permission",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1063,
        "HOURS_OR_DAYS": "H"
      },
      {
        "NAME": "Uddah Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1064,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Unauthorized Absence",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1066,
        "HOURS_OR_DAYS": "D"
      },
      {
        "NAME": "Unpaid Leave",
        "ABSENCE_ATTENDANCE_TYPE_ID": 1065,
        "HOURS_OR_DAYS": "D"
      }
    ]
  };
}
