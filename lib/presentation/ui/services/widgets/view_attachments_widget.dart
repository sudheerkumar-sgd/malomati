import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/attachment_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/item_list_attachment.dart';

import '../../../../res/drawables/background_box_decoration.dart';

class ViewAttachmentsWidget extends StatelessWidget {
  final List<AttachmentEntity> data;
  const ViewAttachmentsWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp100, horizontal: resources.dimen.dp20),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(
            horizontal: resources.dimen.dp20, vertical: resources.dimen.dp10),
        child: Column(
          children: [
            Text(context.string.viewAttachments,
                style: context.textFontWeight600),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            data.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: resources.dimen.dp40),
                    child: Text(
                      context.string.thereAreNoAttachment,
                      style: context.textFontWeight400
                          .onColor(resources.color.viewBgColor),
                    ),
                  )
                : Column(
                    children: List.generate(data.length,
                        (index) => ItemListAttachment(data: data[index])),
                  ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp40,
                      vertical: context.resources.dimen.dp7),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.bgGradientStart,
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
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
          ],
        ),
      ),
    );
  }
}
