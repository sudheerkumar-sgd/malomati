// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/bloc/login/login_bloc.dart';
import 'package:malomati/presentation/ui/widgets/back_app_bar.dart';

import '../../../core/common/common_utils.dart';
import '../../../injection_container.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/resources.dart';

class UserProfileScreen extends StatelessWidget {
  late Resources resources;
  final _loginBloc = sl<LoginBloc>();
  UserProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    _loginBloc.getProfile(requestParams: {
      'USER_NAME':
          context.userDB.get(userNameKey, defaultValue: 'MOOZA.BINYEEM')
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: resources.color.appScaffoldBg,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: resources.dimen.dp20, horizontal: resources.dimen.dp25),
          child: Column(
            children: [
              SizedBox(
                height: resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.profile),
              SizedBox(
                height: resources.dimen.dp25,
              ),
              BlocBuilder<LoginBloc, LoginState>(
                  bloc: _loginBloc,
                  builder: (context, state) {
                    if (state is OnLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is OnProfileSuccess) {
                      var profileEntity = state.profileEntity.entity;
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: resources.dimen.dp15,
                                  vertical: resources.dimen.dp20),
                              decoration: BackgroundBoxDecoration(
                                      boxColor: resources.color.viewBgColor,
                                      radious: resources.dimen.dp10)
                                  .roundedCornerBox,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profileEntity?.getFullName(
                                            resources.isLocalEn) ??
                                        '',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.dimen.dp17)
                                        .onColor(resources.color.colorWhite),
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp15,
                                  ),
                                  Text(
                                    '${context.string.employeeID}: ${profileEntity?.EMPLOYEE_NUMBER ?? ''}',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.dimen.dp14)
                                        .onColor(resources.color.colorWhite),
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                  Text(
                                    '${context.string.designation}: ${profileEntity?.getJobName(resources.isLocalEn)}',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.dimen.dp14)
                                        .onColor(resources.color.colorWhite),
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                  Text(
                                    '${context.string.emailID}: ${profileEntity?.EMAIL_ADDRESS}',
                                    style: context.textFontWeight400
                                        .onFontSize(resources.dimen.dp14)
                                        .onColor(resources.color.colorWhite),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp30,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.departmentName,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.getDepartmentName(
                                                    resources.isLocalEn) ??
                                                '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.maritalStatus,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.getMaritalStatus(
                                                    resources.isLocalEn) ??
                                                '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.dob,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.DATE_OF_BIRTH ?? '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.mobile,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.PHONE_NUMBER ?? '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.joiningDate,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.HIRE_DATE ?? '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.managerName,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.getManager(
                                                    resources.isLocalEn) ??
                                                '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.yearOfService,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.YEARS_OF_SERVICE ??
                                                '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            context.string.basicSalary,
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            profileEntity?.BASIC_SALARY ?? '',
                                            style: context.textFontWeight400
                                                .onFontSize(
                                                    resources.dimen.dp13)
                                                .onColor(resources
                                                    .color.textColor212B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp15,
                                    ),
                                    Container(
                                      color:
                                          context.resources.color.colorD6D6D6,
                                      height: 0.5,
                                    ),
                                    SizedBox(
                                      height: context.resources.dimen.dp5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp30,
                            ),
                            InkWell(
                              onTap: () {
                                logout(context);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: resources.dimen.dp60),
                                padding: EdgeInsets.all(resources.dimen.dp5),
                                decoration: BackgroundBoxDecoration(
                                  boxColor: resources.color.viewBgColor,
                                  radious: context.resources.dimen.dp20,
                                ).roundedCornerBox,
                                alignment: Alignment.center,
                                child: Text(
                                  context.string.logout,
                                  style: context.textFontWeight400
                                      .onColor(resources.color.colorWhite)
                                      .onFontSize(context.resources.dimen.dp17),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp30,
                            ),
                          ],
                        ),
                      );
                    } else if (state is OnLoginError) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: context.textFontWeight600
                                .onFontSize(context.resources.dimen.dp15),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: context.textFontWeight600
                                .onFontSize(context.resources.dimen.dp15),
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
