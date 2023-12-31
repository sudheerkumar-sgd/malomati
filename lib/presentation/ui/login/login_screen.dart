import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/presentation/bloc/login/login_bloc.dart';
import 'package:malomati/presentation/ui/home/main_screen.dart';
import 'package:malomati/presentation/ui/home/tour_screen.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/text_input_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../../../injection_container.dart';
import '../widgets/custom_bg_widgets.dart';
import '../widgets/image_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final loginBloc = sl<LoginBloc>();
  final _nameTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final ValueNotifier<bool> _isRememberd = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isShowPassword = ValueNotifier(false);

  void dispose() {
    loginBloc.close();
  }

  onShowHidePassword() {
    printLog(message: '${_isShowPassword.value}');
    _isShowPassword.value = !_isShowPassword.value;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    _isRememberd.value =
        context.userDB.get(isRememberdKey, defaultValue: false);
    if (_isRememberd.value) {
      _nameTextController.text =
          context.userDB.get(userNameKey, defaultValue: '');
    }
    _pwdTextController.text = context.userDB.get(passwordKey, defaultValue: '');
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<LoginBloc>(
        create: (context) => loginBloc,
        child: Center(
          child: Stack(
            children: <Widget>[
              const Align(
                alignment: Alignment.topCenter,
                child: Image(
                  width: double.infinity,
                  fit: BoxFit.fill,
                  image: AssetImage(DrawableAssets.loginCoveImage),
                ),
              ),
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is OnLoading) {
                    Dialogs.loader(context);
                  } else if (state is OnLoginSuccess) {
                    if (state.loginEntity.isSuccess ?? false) {
                      oracleLoginId =
                          state.loginEntity.entity?.oracleLoginId ?? '';
                      context.userDB.put(userFullNameUsKey,
                          state.loginEntity.entity?.fullNameUS ?? '');
                      context.userDB.put(userFullNameArKey,
                          state.loginEntity.entity?.fullNameAR ?? '');
                      context.userDB.put(oracleLoginIdKey, oracleLoginId);
                      context.userDB.put(departmentIdKey,
                          state.loginEntity.entity?.departmentId ?? '');
                      context.userDB.put(
                          isMaangerKey,
                          (state.loginEntity.entity?.iSMANAGER ?? '') == 'Y'
                              ? true
                              : false);
                      context.userDB.put(
                          userNameKey, _nameTextController.text.toUpperCase());
                      context.userDB.put(userJobNameEnKey,
                          state.loginEntity.entity?.jobName ?? '');
                      context.userDB.put(userJobNameArKey,
                          state.loginEntity.entity?.jobNameAr ?? '');
                      context.userDB.put(userJoiningDateEnKey,
                          state.loginEntity.entity?.hireDate ?? '');
                      context.userDB.put(userDateOfBirthKey,
                          state.loginEntity.entity?.dateOfBirth ?? '');
                      context.userDB.put(userJobIdEnKey,
                          state.loginEntity.entity?.employeeNumber ?? '');
                      context.userDB.put(userNationalityEnKey,
                          state.loginEntity.entity?.nationality ?? '');
                      context.userDB.put(userPersonIdKey,
                          state.loginEntity.entity?.persionID ?? '');
                      if (_isRememberd.value) {
                        context.userDB
                            .put(passwordKey, _pwdTextController.text);
                        context.userDB.put(isRememberdKey, _isRememberd.value);
                      } else {
                        context.userDB.delete(passwordKey);
                        context.userDB.delete(isRememberdKey);
                      }
                      FirebaseMessaging.instance.subscribeToTopic(
                          _nameTextController.text.toUpperCase());
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => context.userDB
                                      .get(appTourKey, defaultValue: false)
                                  ? const MainScreen()
                                  : TourScreen()),
                          (_) => false);
                    } else {
                      Navigator.pop(context);
                      Dialogs.showInfoDialog(context, PopupType.fail,
                          context.string.usernameOrPasswordIsWrong);
                    }
                  } else if (state is OnLoginError) {
                    Navigator.pop(context);
                    Dialogs.showInfoDialog(
                        context, PopupType.fail, state.message);
                  }
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      margin:
                          EdgeInsets.only(bottom: context.resources.dimen.dp10),
                      decoration: BackgroundBoxDecoration(
                              boxColor: context.resources.color.colorWhite,
                              radious: context.resources.dimen.dp30)
                          .topCornersBox,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => {
                                context.resources.setLocal(),
                              },
                              child: Container(
                                padding: EdgeInsets.all(
                                    context.resources.dimen.dp25),
                                child: ImageWidget(
                                        path: context.resources.isLocalEn
                                            ? DrawableAssets.icLangAr
                                            : DrawableAssets.icLangEn,
                                        backgroundTint:
                                            context.resources.iconBgColor)
                                    .loadImage,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: context.resources.dimen.dp50,
                                top: context.resources.dimen.dp10,
                                right: context.resources.dimen.dp50,
                                bottom: context.resources.dimen.dp30),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: context.resources.dimen.dp10,
                                ),
                                ImageWidget(path: DrawableAssets.icLogoTitle)
                                    .loadImage,
                                SizedBox(
                                  height: context.resources.dimen.dp30,
                                ),
                                Center(
                                  child: Text(
                                    context.string
                                        .manager_amp_employee_self_service_of_uaq_government,
                                    style: context.textFontWeight700.onFontSize(
                                        context.resources.fontSize.dp17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp15,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextInputWidget(
                                              height:
                                                  context.resources.dimen.dp40,
                                              textController:
                                                  _nameTextController,
                                              hintText: context.string.username,
                                              errorMessage:
                                                  context.string.username,
                                              focusedBorderColor: context
                                                  .resources.color.viewBgColor,
                                              enabledBorderColor: context
                                                  .resources.color.viewBgColor,
                                              boarderWidth:
                                                  context.resources.dimen.dp1,
                                              boarderRadius:
                                                  context.resources.dimen.dp10,
                                              textStyle: context
                                                  .textFontWeight400
                                                  .onFontSize(context
                                                      .resources.fontSize.dp13)
                                                  .onFontFamily(
                                                      fontFamily: fontFamilyEN))
                                          .textInputFiled,
                                      SizedBox(
                                          height: context.resources.dimen.dp10),
                                      ValueListenableBuilder(
                                          valueListenable: _isShowPassword,
                                          builder: (context, value, child) {
                                            return TextInputWidget(
                                                    height: context
                                                        .resources.dimen.dp40,
                                                    textController:
                                                        _pwdTextController,
                                                    textInputType: value
                                                        ? TextInputType.text
                                                        : TextInputType
                                                            .visiblePassword,
                                                    hintText:
                                                        context.string.password,
                                                    errorMessage:
                                                        context.string.password,
                                                    focusedBorderColor: context
                                                        .resources
                                                        .color
                                                        .viewBgColor,
                                                    enabledBorderColor: context
                                                        .resources
                                                        .color
                                                        .viewBgColor,
                                                    boarderWidth: context
                                                        .resources.dimen.dp1,
                                                    boarderRadius: context
                                                        .resources.dimen.dp10,
                                                    textStyle: context.textFontWeight400
                                                        .onFontSize(context
                                                            .resources
                                                            .fontSize
                                                            .dp13)
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamilyEN),
                                                    suffixIconPath: value
                                                        ? DrawableAssets.icHidePwd
                                                        : DrawableAssets.icShowPwd,
                                                    suffixIconClick: onShowHidePassword)
                                                .textInputFiled;
                                          }),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: ValueListenableBuilder(
                                    valueListenable: _isRememberd,
                                    builder: (context, value, child) {
                                      return Row(
                                        children: [
                                          Checkbox(
                                              visualDensity:
                                                  const VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -4),
                                              shape: const CircleBorder(),
                                              value: value,
                                              onChanged: (isChecked) {
                                                _isRememberd.value =
                                                    isChecked ?? false;
                                              }),
                                          InkWell(
                                            onTap: () {
                                              _isRememberd.value = !value;
                                            },
                                            child: Text(
                                              context.string.rememberMe,
                                              style: context.textFontWeight400
                                                  .onColor(context.resources
                                                      .color.textColorLight)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      Map<String, dynamic> requestParams = {
                                        "user_name".toUpperCase():
                                            _nameTextController.text
                                                .toUpperCase(),
                                        "password".toUpperCase():
                                            _pwdTextController.text,
                                      };
                                      loginBloc.doLogin(
                                          requestParams: requestParams);
                                    }
                                  },
                                  child: CustomBgWidgets().roundedCornerWidget(
                                      widget: Center(
                                        child: Text(
                                          context.string.login,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontSize(context
                                                  .resources.fontSize.dp17),
                                        ),
                                      ),
                                      boxDecoration: BackgroundBoxDecoration(
                                              boxColor: context
                                                  .resources.color.viewBgColor,
                                              radious:
                                                  context.resources.dimen.dp10,
                                              shadowColor: context.resources
                                                  .color.textColorLight,
                                              shadowBlurRadius:
                                                  context.resources.dimen.dp1,
                                              shadowOffset: const Offset(1, 2))
                                          .roundedCornerBoxWithShadow,
                                      height: context.resources.dimen.dp40),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp40,
                                ),
                                // Text(
                                //   context.string.or,
                                //   style: context.textFontWeight400
                                //       .onColor(context
                                //           .resources.color.textColorLight)
                                //       .onFontSize(
                                //           context.resources.fontSize.dp12),
                                // ),
                                // SizedBox(
                                //   height: context.resources.dimen.dp10,
                                // ),
                                // GestureDetector(
                                //   onTap: () => {},
                                //   child: CustomBgWidgets().roundedCornerWidget(
                                //       widget: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: [
                                //           Text(
                                //             context.string.loginWith,
                                //             style: context.textFontWeight600
                                //                 .onColor(context
                                //                     .resources.color.textColor)
                                //                 .onFontSize(context
                                //                     .resources.fontSize.dp17),
                                //           ),
                                //           SizedBox(
                                //             width: context.resources.dimen.dp10,
                                //           ),
                                //           ImageWidget(
                                //                   path:
                                //                       DrawableAssets.icUaePass)
                                //               .loadImage,
                                //         ],
                                //       ),
                                //       boxDecoration: BackgroundBoxDecoration(
                                //               boxColor: context
                                //                   .resources.color.colorWhite,
                                //               boarderWidth: 0,
                                //               radious:
                                //                   context.resources.dimen.dp10,
                                //               shadowColor: context.resources
                                //                   .color.textColorLight,
                                //               shadowBlurRadius:
                                //                   context.resources.dimen.dp1,
                                //               shadowOffset: const Offset(1, 2))
                                //           .roundedCornerBoxWithShadow,
                                //       height: context.resources.dimen.dp40),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
