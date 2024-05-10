// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/services/widgets/delegation_create_widget.dart';
import 'package:malomati/presentation/ui/services/widgets/delegation_list_widget.dart';
import 'package:malomati/presentation/ui/widgets/tab_buttons_widget.dart';
import 'package:malomati/res/resources.dart';
import '../widgets/back_app_bar.dart';

class VacationRulesScreen extends StatelessWidget {
  static const String route = '/VacationRulesScreen';
  VacationRulesScreen({super.key});
  late Resources resources;
  final ValueNotifier<int> onTabSelected = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    return SafeArea(
      child: Scaffold(
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
                height: resources.dimen.dp20,
              ),
              TabsButtonsWidget(buttons: [
                {
                  'name': context.string.create,
                },
                {
                  'name': context.string.view,
                },
              ], onTabSelected: onTabSelected),
              SizedBox(
                height: resources.dimen.dp20,
              ),
              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: onTabSelected,
                      builder: (context, index, child) {
                        return index == 0
                            ? DelegationCreateWidget()
                            : DelegationListWidget();
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
