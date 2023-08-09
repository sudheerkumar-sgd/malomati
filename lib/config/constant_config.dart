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
}
