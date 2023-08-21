import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/widgets/services_list.dart';
import 'package:malomati/presentation/ui/services/leaves_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../domain/entities/favorite_entity.dart';
import '../../../injection_container.dart';
import '../widgets/services_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static onServiceClick(BuildContext context, FavoriteEntity favoriteEntity) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: LeavesScreen(
          leaveType: LeaveType.values.firstWhere(
              ((element) => element.name == (favoriteEntity.name ?? ''))),
        ),
      ),
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
