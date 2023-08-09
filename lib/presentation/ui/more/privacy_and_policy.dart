import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import '../widgets/back_app_bar.dart';

class PrivacyAndPolicy extends StatelessWidget {
  static const String route = '/PrivacyAndPolicy';
  const PrivacyAndPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: context.resources.dimen.dp20,
              horizontal: context.resources.dimen.dp25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.privacyAndPolicy),
              SizedBox(
                height: context.resources.dimen.dp20,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.resources.dimen.dp15),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.colorWhite,
                        radious: context.resources.dimen.dp10)
                    .roundedCornerBox,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text',
                      style: context.textFontWeight400
                          .onFontSize(context.resources.dimen.dp11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
