import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/text_input_widget.dart';

import '../../../../res/drawables/background_box_decoration.dart';

class DialogRequestAnswerMoreInfo extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  DialogRequestAnswerMoreInfo({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(resources.dimen.dp15))),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: resources.dimen.dp20, vertical: resources.dimen.dp15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.string.returntext,
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp17),
            ),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            Align(
              alignment:
                  resources.isLocalEn ? Alignment.topLeft : Alignment.topRight,
              child: Text(
                context.string.question,
                style: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp12),
              ),
            ),
            SizedBox(
              height: resources.dimen.dp5,
            ),
            Form(
              key: _formKey,
              child: TextInputWidget(
                      maxLines: 3,
                      textController: controller,
                      textStyle: context.textFontWeight400
                          .onFontSize(resources.fontSize.dp12),
                      fillColor: resources.color.colorLightBg,
                      boarderRadius: resources.dimen.dp8,
                      errorMessage: context.string.question)
                  .textInputFiled,
            ),
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, controller.text);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp40,
                    vertical: context.resources.dimen.dp7),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.viewBgColorLight,
                        radious: context.resources.dimen.dp15)
                    .roundedCornerBox,
                child: Text(
                  context.string.ok,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp15)
                      .onColor(context.resources.color.colorWhite)
                      .copyWith(height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
