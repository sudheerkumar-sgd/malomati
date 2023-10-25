import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/attachment_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowAttachmentDialog extends StatelessWidget {
  final AttachmentEntity data;
  const ShowAttachmentDialog({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: context.resources.dimen.dp100,
          horizontal: context.resources.dimen.dp20),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ImageWidget(
                      path: DrawableAssets.getCloseDrawable(context),
                      padding: EdgeInsets.only(
                          left: context.resources.dimen.dp20,
                          top: context.resources.dimen.dp10,
                          right: context.resources.dimen.dp10,
                          bottom: context.resources.dimen.dp5))
                  .loadImageWithMoreTapArea,
            ),
          ),
          if (data.fileData != null && isImage(data.fileName ?? '')) ...{
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  left: context.resources.dimen.dp20,
                  top: context.resources.dimen.dp10,
                  right: context.resources.dimen.dp20,
                  bottom: context.resources.dimen.dp20),
              child: Image.memory(data.fileData!),
            ))
          },
          if (data.fileData != null && isPdf(data.fileName ?? '')) ...{
            Expanded(
              child: SfPdfViewer.memory(
                data.fileData!,
                canShowSignaturePadDialog: false,
                canShowHyperlinkDialog: false,
              ),
            )
          },
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
