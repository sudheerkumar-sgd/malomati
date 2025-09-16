// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/services/widgets/dialog_upload_attachment.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/item_attachment.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class UploadFileWidget extends StatelessWidget {
  final ValueNotifier<bool> _isUploadChanged = ValueNotifier(false);
  final _uploadFiles = [];
  int uploadFileSize;
  Function(List<dynamic>) callback;

  UploadFileWidget(
      {required this.callback, this.uploadFileSize = 5, super.key});

  Future<void> _showSelectFileOptions(BuildContext context) async {
    Dialogs.showBottomSheetDialogTransperrent(
        context, const DialogUploadAttachmentWidget(), callback: (value) {
      if (value != null) {
        _uploadFiles.add(value);
        _isUploadChanged.value = !_isUploadChanged.value;
        callback(_uploadFiles);
      }
    });
  }

  void _onDeleteUpload(int id) {
    _uploadFiles.removeAt(id);
    _isUploadChanged.value = !_isUploadChanged.value;
    callback(_uploadFiles);
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.string.upload,
          style: context.textFontWeight400
              .onFontSize(context.resources.fontSize.dp12),
        ),
        SizedBox(
          height: context.resources.dimen.dp10,
        ),
        Row(
          children: [
            ValueListenableBuilder(
                valueListenable: _isUploadChanged,
                builder: (context, isChanged, widget) {
                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: context.resources.dimen.dp10,
                          top: context.resources.dimen.dp5,
                          right: context.resources.dimen.dp15,
                          bottom: context.resources.dimen.dp5),
                      decoration: BackgroundBoxDecoration(
                              boxColor: context.resources.color.colorWhite,
                              radious: context.resources.dimen.dp10)
                          .roundedCornerBox,
                      child: _uploadFiles.isNotEmpty
                          ? Wrap(
                              runSpacing: resources.dimen.dp10,
                              children: List.generate(
                                  _uploadFiles.length,
                                  (index) => ItemAttachment(
                                        id: index,
                                        name: _uploadFiles[index]['fileName'],
                                        callBack: _onDeleteUpload,
                                      )),
                            )
                          : InkWell(
                              onTap: () {
                                if (_uploadFiles.length >= uploadFileSize) {
                                  Dialogs.showInfoDialog(
                                      context,
                                      PopupType.fail,
                                      isLocalEn
                                          ? 'You can upload only $uploadFileSize file'
                                          : 'يمكنك تحميل ملف واحد فقط');
                                  return;
                                }
                                _showSelectFileOptions(context);
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: context.resources.dimen.dp5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      context.string.upload,
                                      style: context.textFontWeight400
                                          .onFontSize(
                                              context.resources.fontSize.dp12)
                                          .onColor(context
                                              .resources.color.colorD6D6D6)
                                          .onFontFamily(
                                              fontFamily: isLocalEn
                                                  ? fontFamilyEN
                                                  : fontFamilyAR)
                                          .copyWith(height: 1),
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.resources.dimen.dp10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: resources.dimen.dp8),
                                    child: ImageWidget(
                                            // width: 13,
                                            // height: 13,
                                            path: DrawableAssets.icUpload,
                                            backgroundTint:
                                                resources.color.viewBgColor)
                                        .loadImage,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                }),
            InkWell(
              onTap: () {
                if (_uploadFiles.length >= uploadFileSize) {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      isLocalEn
                          ? 'You can upload only $uploadFileSize file'
                          : 'يمكنك تحميل ملف واحد فقط');
                  return;
                }
                _showSelectFileOptions(context);
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: resources.isLocalEn ? resources.dimen.dp10 : 0,
                  right: resources.isLocalEn ? 0 : resources.dimen.dp10,
                ),
                child: ImageWidget(
                        path: DrawableAssets.icPlusCircle,
                        backgroundTint: resources.color.viewBgColor)
                    .loadImage,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
