import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/delegation_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/delegation_create_widget.dart';
import 'package:malomati/presentation/ui/widgets/back_app_bar.dart';
import 'package:page_transition/page_transition.dart';

class UpdateDelegationScreen extends StatelessWidget {
  static start(BuildContext context, DelegationItemEntity delegationItem) {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: UpdateDelegationScreen(
            delegationItem: delegationItem,
          )),
    );
  }

  final DelegationItemEntity delegationItem;
  const UpdateDelegationScreen({required this.delegationItem, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.resources.color.appScaffoldBg,
      body: Container(
        margin: EdgeInsets.symmetric(
            vertical: context.resources.dimen.dp20,
            horizontal: context.resources.dimen.dp25),
        child: Column(
          children: [
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            BackAppBarWidget(title: context.string.vacationRules),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            Expanded(
                child: DelegationCreateWidget(
              delegationItem: delegationItem,
            )),
          ],
        ),
      ),
    );
  }
}
