import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/services/advance_salary_screen.dart';
import 'package:malomati/presentation/ui/services/badge_screen.dart';
import 'package:malomati/presentation/ui/services/certificates_screen.dart';
import 'package:malomati/presentation/ui/services/finance_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/hr_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/leaves_screen.dart';
import 'package:malomati/presentation/ui/services/overtime_screen.dart';
import 'package:malomati/presentation/ui/services/payslips_screen.dart';
import 'package:malomati/presentation/ui/services/thankyou_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../domain/entities/favorite_entity.dart';
import '../../../injection_container.dart';
import '../services/initiatives_screen.dart';
import '../services/myteam_screen.dart';
import '../widgets/services_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static onServiceClick(BuildContext context, FavoriteEntity favoriteEntity) {
    Widget? screenWidget = InitiativesScreen();
    if ((favoriteEntity.name ?? '').toLowerCase().contains('leave') ||
        (favoriteEntity.name ?? '').toLowerCase().contains('permission')) {
      screenWidget = LeavesScreen(
        leaveType: LeaveType.values.firstWhere(
            ((element) => element.name == (favoriteEntity.name ?? ''))),
      );
    } else if ((favoriteEntity.name ?? '')
        .toLowerCase()
        .contains('initiatives')) {
      screenWidget = InitiativesScreen();
    } else if ((favoriteEntity.name ?? '')
        .toLowerCase()
        .contains('certificate')) {
      screenWidget = CertificatesScreen();
    } else if ((favoriteEntity.name ?? '').toLowerCase().contains('thank')) {
      screenWidget = ThankyouScreen();
    } else if ((favoriteEntity.name ?? '')
        .toLowerCase()
        .contains('advance salary')) {
      screenWidget = AdvanceSalaryScreen();
    } else if ((favoriteEntity.name ?? '').toLowerCase().contains('overtime')) {
      screenWidget = OvertimeScreen();
    } else if ((favoriteEntity.name ?? '').toLowerCase().contains('badge')) {
      screenWidget = BadgeScreen();
    } else if ((favoriteEntity.name ?? '').toLowerCase().contains('my team')) {
      screenWidget = MyTeamScreen();
    } else if ((favoriteEntity.name ?? '').toLowerCase().contains('payslip')) {
      screenWidget = PayslipsScreen();
    } else if ((favoriteEntity.name ?? '')
        .toLowerCase()
        .contains('hr approvals')) {
      screenWidget = HrApprovalsScreen();
    } else if ((favoriteEntity.name ?? '')
        .toLowerCase()
        .contains('finance approvals')) {
      screenWidget = FinanceApprovalsScreen();
    }

    Navigator.push(
      context,
      PageTransition(type: PageTransitionType.rightToLeft, child: screenWidget),
    );
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
                child: ServicesAppBarWidget(title: context.string.selfService)),
            ServicesList(
              services: sl<ConstantConfig>().getServicesByManager(
                  isManager:
                      context.userDB.get(isMaangerKey, defaultValue: false)),
              callback: onServiceClick,
            ),
          ],
        ),
      ),
    );
  }
}
