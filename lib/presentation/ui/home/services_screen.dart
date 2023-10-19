import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/guest/guest_jobs_screen.dart';
import 'package:malomati/presentation/ui/guest/uaq_apps_screen.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/services/advance_salary_screen.dart';
import 'package:malomati/presentation/ui/services/badge_screen.dart';
import 'package:malomati/presentation/ui/services/certificates_screen.dart';
import 'package:malomati/presentation/ui/services/create_warning_screen.dart';
import 'package:malomati/presentation/ui/services/delete_leave_screen.dart';
import 'package:malomati/presentation/ui/services/holidays_screen.dart';
import 'package:malomati/presentation/ui/services/finance_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/hr_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/leaves_screen.dart';
import 'package:malomati/presentation/ui/services/overtime_screen.dart';
import 'package:malomati/presentation/ui/services/payslips_screen.dart';
import 'package:malomati/presentation/ui/services/thankyou_screen.dart';
import 'package:malomati/presentation/ui/services/view_warnings_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../domain/entities/favorite_entity.dart';
import '../../../injection_container.dart';
import '../services/initiatives_screen.dart';
import '../services/myteam_screen.dart';
import '../widgets/guest_services_app_bar.dart';
import '../widgets/services_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static onServiceClick(BuildContext context, FavoriteEntity favoriteEntity) {
    Widget? screenWidget;
    switch (favoriteEntity.id) {
      case 1:
        {
          screenWidget = HrApprovalsScreen();
        }
      case 2:
        {
          screenWidget = FinanceApprovalsScreen();
        }
      case 3 || 4 || 5 || 6 || 7:
        {
          screenWidget = LeavesScreen(
            leaveType: LeaveType.values.firstWhere(
                ((element) => element.name == (favoriteEntity.name ?? ''))),
          );
        }
      case 8:
        {
          screenWidget = InitiativesScreen();
        }
      case 9:
        {
          screenWidget = CertificatesScreen();
        }
      case 10:
        {
          screenWidget = ThankyouScreen();
        }
      case 11:
        {
          screenWidget = PayslipsScreen();
        }
      case 12:
        {
          screenWidget = AdvanceSalaryScreen();
        }
      case 13:
        {
          screenWidget = OvertimeScreen();
        }
      case 14:
        {
          screenWidget = BadgeScreen();
        }
      case 15:
        {
          screenWidget = DeleteLeaveScreen();
        }
      case 16:
        {
          screenWidget = CreateWarningScreen();
        }
      case 17:
        {
          screenWidget = HolidaysScreen();
        }
      case 18:
        {
          screenWidget = MyTeamScreen();
        }
      case 19:
        {
          screenWidget = ViewWarningsScreen();
        }
      case 31:
        {
          screenWidget = GuestJobsScreen();
        }
      case 32:
        {
          screenWidget = const UAQAppsScreen();
        }
    }
    if (screenWidget != null) {
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: screenWidget),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              services: sl<ConstantConfig>().getServicesByManager(
                  isManager:
                      context.userDB.get(isMaangerKey, defaultValue: false),
                  isGuest: context.userDB.get(isGuestKey, defaultValue: false)),
              callback: onServiceClick,
            ),
          ],
        ),
      ),
    );
  }
}
