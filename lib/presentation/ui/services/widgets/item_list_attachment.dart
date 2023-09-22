import 'package:flutter/material.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/domain/entities/attachment_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/show_attachment_dialog.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemListAttachment extends StatelessWidget {
  final AttachmentEntity data;
  const ItemListAttachment({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return ShowAttachmentDialog(data: data);
            });
      },
      child: Container(
        padding: EdgeInsets.all(context.resources.dimen.dp5),
        margin: EdgeInsets.only(bottom: context.resources.dimen.dp10),
        decoration: BackgroundBoxDecoration(
                boxColor: context.resources.color.colorLightBg,
                radious: context.resources.dimen.dp15)
            .roundedCornerBox,
        child: Row(
          children: [
            SizedBox(
              width: context.resources.dimen.dp5,
            ),
            ImageWidget(
                    path: DrawableAssets.icAttachment,
                    backgroundTint: context.resources.iconBgColor)
                .loadImage,
            SizedBox(
              width: context.resources.dimen.dp10,
            ),
            Expanded(
              child: Text(
                data.fileName ?? '',
                textAlign: TextAlign.left,
                style: context.textFontWeight400
                    .onFontSize(context.resources.fontSize.dp13)
                    .onFontFamily(fontFamily: fontFamilyEN),
              ),
            )
          ],
        ),
      ),
    );
  }
}
