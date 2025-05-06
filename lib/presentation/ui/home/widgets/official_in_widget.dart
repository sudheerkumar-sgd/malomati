// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class OfficialInWidgetWidget extends StatelessWidget {
  final String title;
  final Function(String?)? callBack;
  OfficialInWidgetWidget({required this.title, this.callBack, super.key});
  final ValueNotifier<String?> _selectedLeaveType =
      ValueNotifier<String?>(null);
  bool isOther = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 15.0, right: 15.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: ImageWidget(path: DrawableAssets.icCross).loadImage),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp20,
                vertical: context.resources.dimen.dp15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp17),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  DropDownWidget<String>(
                    list: [
                      context.string.visitingDepartment,
                      context.string.university,
                      context.string.training,
                      context.string.other,
                    ],
                    height: context.resources.dimen.dp27,
                    labelText: context.string.selectReason,
                    hintText: context.string.selectReason,
                    errorMessage: context.string.selectReason,
                    suffixIconPath: DrawableAssets.icChevronDown,
                    fillColor: context.resources.color.colorLightBg,
                    selectedValue: _selectedLeaveType.value,
                    callback: (value) {
                      isOther = value == context.string.other;
                      _selectedLeaveType.value = isOther ? '' : value;
                      _formKey.currentState?.validate();
                    },
                  ),
                  ValueListenableBuilder(
                      valueListenable: _selectedLeaveType,
                      builder: (context, value, child) {
                        return isOther
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: context.resources.dimen.dp25),
                                child: RightIconTextWidget(
                                  height: context.resources.dimen.dp27,
                                  labelText: context.string.specifyTheReason,
                                  hintText: context.string.specifyTheReason,
                                  maxLines: 4,
                                  minLength: 5,
                                  isEnabled: true,
                                  fillColor:
                                      context.resources.color.colorLightBg,
                                  fontFamily: fontFamilyEN,
                                  errorMessage: context.string.specifyTheReason,
                                  onChanged: (value) {
                                    _selectedLeaveType.value = value;
                                    _formKey.currentState?.validate();
                                  },
                                ),
                              )
                            : const SizedBox();
                      }),
                  SizedBox(
                    height: context.resources.dimen.dp25,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState?.validate() == false ||
                          _selectedLeaveType.value == null ||
                          (_selectedLeaveType.value ?? '').length < 5) {
                        return;
                      }
                      Navigator.pop(context);
                      callBack?.call(_selectedLeaveType.value);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp20,
                          vertical: context.resources.dimen.dp7),
                      decoration: BackgroundBoxDecoration(
                              boxColor:
                                  context.resources.color.viewBgColorLight,
                              radious: context.resources.dimen.dp15)
                          .roundedCornerBox,
                      child: Text(
                        context.string.submit,
                        style: context.textFontWeight400
                            .onFontSize(context.resources.fontSize.dp11)
                            .onColor(context.resources.color.colorWhite)
                            .copyWith(height: 1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
