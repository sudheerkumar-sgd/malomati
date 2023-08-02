import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/custom_bg_widgets.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemDashboardService extends StatelessWidget {
  ItemDashboardService(
      {required this.title, required this.iconPath, super.key});
  String title;
  String iconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBgWidgets().roundedCornerWidget(
            padding: EdgeInsets.all(context.resources.dimen.dp15),
            widget: ImageWidget(
              path: iconPath,
              width: 30,
              height: 30,
            ).loadImage,
            boxDecoration: BackgroundBoxDecoration(
                    boxColor: title == favoriteAdd
                        ? context.resources.color.colorF5C3C3
                        : context.resources.color.colorWhite)
                .circularBox),
        SizedBox(
          height: context.resources.dimen.dp10,
        ),
        Text(
          title == favoriteAdd ? '' : title,
          textAlign: TextAlign.center,
          style: context.textFontWeight400
              .onColor(context.resources.color.textColor)
              .onFontSize(context.resources.dimen.dp12),
        ),
      ],
    );
  }
}
