import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/guest/guest_jobs_screen.dart';
import 'package:malomati/presentation/ui/guest/uaq_apps_screen.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/services/advance_salary_screen.dart';
import 'package:malomati/presentation/ui/services/badge_screen.dart';
import 'package:malomati/presentation/ui/services/cancel_invoice_screen.dart';
import 'package:malomati/presentation/ui/services/certificates_screen.dart';
import 'package:malomati/presentation/ui/services/contract_renew_screen.dart';
import 'package:malomati/presentation/ui/services/create_warning_screen.dart';
import 'package:malomati/presentation/ui/services/delete_leave_screen.dart';
import 'package:malomati/presentation/ui/services/holidays_screen.dart';
import 'package:malomati/presentation/ui/services/finance_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/hr_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/leaves_screen.dart';
import 'package:malomati/presentation/ui/services/overtime_screen.dart';
import 'package:malomati/presentation/ui/services/payslips_screen.dart';
import 'package:malomati/presentation/ui/services/punch_in_access_screen.dart';
import 'package:malomati/presentation/ui/services/resignation_screen.dart';
import 'package:malomati/presentation/ui/services/thankyou_screen.dart';
import 'package:malomati/presentation/ui/services/training_certificate_screen.dart';
import 'package:malomati/presentation/ui/services/vacation_rules_screen.dart';
import 'package:malomati/presentation/ui/services/view_warnings_screen.dart';
import 'package:malomati/presentation/ui/services/widgets/remote_work_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../domain/entities/favorite_entity.dart';
import '../../../injection_container.dart';
import '../services/initiatives_screen.dart';
import '../services/myteam_screen.dart';
import '../widgets/guest_services_app_bar.dart';
import '../widgets/services_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static void onServiceClick(
      BuildContext context, FavoriteEntity favoriteEntity) {
    final screenWidget = _screenForService(favoriteEntity);
    if (screenWidget == null) return;
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft, child: screenWidget),
    );
  }

  static Widget? _screenForService(FavoriteEntity favoriteEntity) {
    final id = favoriteEntity.id;
    if (id == null) return null;

    switch (id) {
      case 1:
        return HrApprovalsScreen();
      case 2:
        return FinanceApprovalsScreen();
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
        return LeavesScreen(
          leaveType: LeaveType.values.firstWhere(
              (e) => e.name == (favoriteEntity.name ?? ''),
              orElse: () => LeaveType.otherLeave),
        );
      case 8:
        return InitiativesScreen();
      case 9:
        return CertificatesScreen();
      case 10:
        return ThankyouScreen();
      case 11:
        return PayslipsScreen();
      case 12:
        return AdvanceSalaryScreen();
      case 13:
        return OvertimeScreen();
      case 14:
        return BadgeScreen();
      case 15:
        return DeleteLeaveScreen();
      case 16:
        return CreateWarningScreen();
      case 17:
        return HolidaysScreen();
      case 18:
        return MyTeamScreen();
      case 19:
        return ViewWarningsScreen();
      case 20:
        return VacationRulesScreen();
      case 21:
        return CancelInvoiceScreen();
      case 22:
        return ContractRenewScreen();
      case 23:
        return ResignationScreen();
      case 24:
        return TrainingCertificateScreen();
      case 25:
        return RemoteWorkScreen();
      case 26:
        return PunchInAccessScreen();
      case 31:
        return GuestJobsScreen();
      case 32:
        return const UAQAppsScreen();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = sl<ConstantConfig>().getServicesByManager(
        isManager: context.userDB.get(isMaangerKey, defaultValue: false),
        isGuest: context.userDB.get(isGuestKey, defaultValue: false),
        userName: context.userDB.get(userNameKey, defaultValue: ''));
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Column(
          children: [
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp20,
                    horizontal: context.resources.dimen.dp25),
                child: context.userDB.get(isGuestKey, defaultValue: false)
                    ? GuestServicesAppBarWidget(title: context.string.welcome)
                    : ServicesAppBarWidget(title: context.string.selfService)),
            ServicesList(
              services: services,
              callback: onServiceClick,
            ),
          ],
        ),
      ),
    );
  }
}
