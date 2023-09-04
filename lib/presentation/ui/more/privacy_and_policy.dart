import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/more/ar_privacy_policy.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import '../widgets/back_app_bar.dart';
import 'en_privacy_policy.dart';

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
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.privacyAndPolicy),
              SizedBox(
                height: context.resources.dimen.dp20,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(
                    context.resources.fontSize.dp15,
                  ),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.colorWhite,
                          radious: context.resources.dimen.dp10)
                      .roundedCornerBox,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isLocalEn
                            ? const EnPrivacyPolicy()
                            : const ArPrivacyPolicy()
                      ],
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
