import 'package:malomati/domain/entities/favorite_entity.dart';

import '../core/constants/constants.dart';
import '../res/drawables/drawable_assets.dart';

class ConstantConfig {
  final services = [
    FavoriteEntity(
        name: 'HR Approvals',
        nameAR: 'HR Approvals',
        iconPath: DrawableAssets.icHrApprovals),
    FavoriteEntity(
        name: 'Finance Approvals',
        nameAR: 'Finance Approvals',
        iconPath: DrawableAssets.icFinanceApprovals),
    FavoriteEntity(
        name: 'Annual Leaves',
        nameAR: 'Annual Leaves',
        iconPath: DrawableAssets.icAnualleaves),
    FavoriteEntity(
        name: 'Permission',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icServicePermission),
    FavoriteEntity(
        name: 'Sick Leaves',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icSickleaves),
    FavoriteEntity(
        name: 'Mission Leaves',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icMissionleaves),
    FavoriteEntity(
        name: 'Other Leaves',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icServiceLeave),
    FavoriteEntity(
        name: 'Attendance',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icServiceAttendance),
    FavoriteEntity(
        name: 'Initiatives',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icInitiatives),
    FavoriteEntity(
        name: 'Certificates',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icServiceCertificate),
    FavoriteEntity(
        name: 'Thank You',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icServiceThankyou),
    FavoriteEntity(
        name: 'Payslip', nameAR: 'Leaves', iconPath: DrawableAssets.icPayslip),
    FavoriteEntity(
        name: 'Advance Salary',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icAdvancesalary),
    FavoriteEntity(
        name: 'Overtime',
        nameAR: 'Leaves',
        iconPath: DrawableAssets.icOvertime),
    FavoriteEntity(
        name: 'Badge', nameAR: 'Leaves', iconPath: DrawableAssets.icBadge),
    FavoriteEntity(
        name: 'My Team', nameAR: 'My Team', iconPath: DrawableAssets.icMyteam),
  ];
  final dashboardFavorites = [
    {
      'name': 'Leaves',
      'nameAR': 'Leaves',
      'iconPath': DrawableAssets.icServiceLeave
    },
    {
      'name': 'Permission',
      'nameAR': 'Leaves',
      'iconPath': DrawableAssets.icServicePermission
    },
    {
      'name': 'Attendance',
      'nameAR': 'Leaves',
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
}
