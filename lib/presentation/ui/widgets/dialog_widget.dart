import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class DialogWidget extends StatelessWidget {
  final Widget child;
  const DialogWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ImageWidget(
                      path: context.resources.isRedTheme
                          ? DrawableAssets.icClose
                          : DrawableAssets.icCloseBlue,
                      padding: EdgeInsets.only(
                          left: context.resources.dimen.dp20,
                          top: context.resources.dimen.dp10,
                          right: context.resources.dimen.dp10,
                          bottom: context.resources.dimen.dp5))
                  .loadImageWithMoreTapArea,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
