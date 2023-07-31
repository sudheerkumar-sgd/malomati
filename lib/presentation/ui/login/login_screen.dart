import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/bloc/login/login_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/text_input_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../config/app_routes.dart';
import '../../../injection_container.dart';
import '../widgets/custom_bg_widgets.dart';
import '../widgets/image_widget.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final loginBloc = sl<LoginBloc>();
  final _nameTextController = TextEditingController();
  final _pwdTextController = TextEditingController();
  final ValueNotifier<bool> isRememberd = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    image: AssetImage(DrawableAssets.loginCoveImage),
                  ),
                ),
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    print(state);
                    if (state is OnLoading) {
                      Dialogs.loader(context);
                    } else if (state is OnLoginSuccess) {
                      if (state.loginEntity.isSuccess ?? false) {
                        authorizationToken =
                            'bearer ${state.loginEntity.entity?.token ?? ''}';
                        context.settingDB
                            .put(authorizationTokenKey, authorizationToken);
                        loginBloc.isManger(requestParams: {
                          "username": _nameTextController.text
                        });
                      } else {
                        Navigator.pop(context);
                        Dialogs.showInfoDialog(
                            context, "Fail", state.loginEntity.message ?? '');
                      }
                    } else if (state is OnIsManagerSuccess) {
                      Navigator.pop(context);
                      Dialogs.showInfoDialog(
                          context, "success", '${state.loginEntity.isSuccess}');
                    } else if (state is OnLoginError) {
                      Navigator.pop(context);
                    }
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      margin:
                          EdgeInsets.only(top: context.resources.dimen.dp300),
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
                                            : DrawableAssets.icLangEn)
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
                                  height: context.resources.dimen.dp50,
                                ),
                                Center(
                                  child: Text(
                                    context.string
                                        .manager_amp_employee_self_service_of_uaq_government,
                                    style: context.textFontWeight700.onFontSize(
                                        context.resources.dimen.dp17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp15,
                                ),
                                TextInputWidget(
                                        height: context.resources.dimen.dp40,
                                        textController: _nameTextController,
                                        hintText: context.string.username,
                                        focusedBorderColor:
                                            context.resources.color.viewBgColor,
                                        enabledBorderColor:
                                            context.resources.color.viewBgColor,
                                        boarderWidth:
                                            context.resources.dimen.dp1,
                                        boarderRadius:
                                            context.resources.dimen.dp10,
                                        textStyle: context.textFontWeight400
                                            .onFontSize(
                                                context.resources.dimen.dp13))
                                    .textInputFiled,
                                SizedBox(height: context.resources.dimen.dp15),
                                TextInputWidget(
                                        height: context.resources.dimen.dp40,
                                        textController: _pwdTextController,
                                        textInputType:
                                            TextInputType.visiblePassword,
                                        hintText: context.string.password,
                                        focusedBorderColor:
                                            context.resources.color.viewBgColor,
                                        enabledBorderColor:
                                            context.resources.color.viewBgColor,
                                        boarderWidth:
                                            context.resources.dimen.dp1,
                                        boarderRadius:
                                            context.resources.dimen.dp10,
                                        textStyle: context.textFontWeight400
                                            .onFontSize(
                                                context.resources.dimen.dp13))
                                    .textInputFiled,
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: ValueListenableBuilder(
                                    valueListenable: isRememberd,
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
                                                isRememberd.value =
                                                    isChecked ?? false;
                                              }),
                                          Text(
                                            context.string.rememberMe,
                                            style: context.textFontWeight400
                                                .onColor(context.resources.color
                                                    .textColorLight)
                                                .onFontSize(context
                                                    .resources.dimen.dp12),
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
                                    Map<String, dynamic> requestParams = {
                                      "username": _nameTextController.text,
                                      "password": _pwdTextController.text,
                                    };
                                    loginBloc.doLogin(
                                        requestParams: requestParams);
                                  },
                                  child: CustomBgWidgets().roundedCornerWidget(
                                      Center(
                                        child: Text(
                                          context.string.login,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontSize(
                                                  context.resources.dimen.dp17),
                                        ),
                                      ),
                                      BackgroundBoxDecoration(
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
                                      context.resources.dimen.dp40),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp10,
                                ),
                                Text(
                                  context.string.or,
                                  style: context.textFontWeight400
                                      .onColor(context
                                          .resources.color.textColorLight)
                                      .onFontSize(context.resources.dimen.dp12),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp10,
                                ),
                                GestureDetector(
                                  onTap: () => {},
                                  child: CustomBgWidgets().roundedCornerWidget(
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            context.string.loginWith,
                                            style: context.textFontWeight600
                                                .onColor(context
                                                    .resources.color.textColor)
                                                .onFontSize(context
                                                    .resources.dimen.dp17),
                                          ),
                                          SizedBox(
                                            width: context.resources.dimen.dp10,
                                          ),
                                          ImageWidget(
                                                  path:
                                                      DrawableAssets.icUaePass)
                                              .loadImage,
                                        ],
                                      ),
                                      BackgroundBoxDecoration(
                                              boxColor: context
                                                  .resources.color.colorWhite,
                                              boarderWidth: 0,
                                              radious:
                                                  context.resources.dimen.dp10,
                                              shadowColor: context.resources
                                                  .color.textColorLight,
                                              shadowBlurRadius:
                                                  context.resources.dimen.dp1,
                                              shadowOffset: const Offset(1, 2))
                                          .roundedCornerBoxWithShadow,
                                      context.resources.dimen.dp40),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
