import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:malomati/core/common/common.dart';
import '../../../../core/common/log.dart';
import '../../../../res/drawables/background_box_decoration.dart';
import '../../utils/dialogs.dart';
import '../../widgets/alert_dialog_widget.dart';
import 'package:mime/mime.dart';

enum UploadOptions { takephoto, image, file }

class DialogUploadAttachmentWidget extends StatelessWidget {
  const DialogUploadAttachmentWidget({super.key});

  _getFile(BuildContext context, UploadOptions selectedOption) async {
    String filePath = '';
    String fileName = '';
    String? mimeType;
    if (selectedOption == UploadOptions.file) {
      final picked = await FilePicker.pickFile(
          type: FileType.custom, allowedExtensions: ['pdf']);
      if (picked != null) {
        fileName = picked.name;
        filePath = picked.path ?? '';
        mimeType = lookupMimeType(filePath.isNotEmpty ? filePath : fileName);
      }
    } else {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: selectedOption == UploadOptions.takephoto
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
        );
        fileName = pickedFile?.name ?? '';
        filePath = pickedFile?.path ?? '';
      } catch (e) {
        printLog(message: e.toString());
      }
    }
    if (filePath.isNotEmpty &&
        (selectedOption != UploadOptions.file ||
            mimeType == 'application/pdf')) {
      File file = File(filePath);
      printLog(message: '${file.lengthSync()}');
      if (file.lengthSync() <= maxUploadFilesize) {
        final bytes = file.readAsBytesSync();
        final data = {
          'fileName': fileName,
          'fileNamebase64data': base64Encode(bytes),
        };
        if (context.mounted) {
          Navigator.pop(context, data);
        }
      } else if (context.mounted) {
        Dialogs.showInfoDialog(
            context, PopupType.fail, "Upload file should not be more then 1mb");
      }
    } else {
      printLog(message: 'message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _getFile(context, UploadOptions.takephoto);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp30,
                vertical: context.resources.dimen.dp5),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Text(
              'Take Photo',
              textAlign: TextAlign.center,
              style: context.textFontWeight600,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _getFile(context, UploadOptions.image);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp30,
                vertical: context.resources.dimen.dp5),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Text(
              'Upload Image',
              textAlign: TextAlign.center,
              style: context.textFontWeight600,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _getFile(context, UploadOptions.file);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp30,
                vertical: context.resources.dimen.dp5),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Text(
              'Upload File',
              textAlign: TextAlign.center,
              style: context.textFontWeight600,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: context.resources.dimen.dp30,
                top: context.resources.dimen.dp5,
                right: context.resources.dimen.dp30,
                bottom: context.resources.dimen.dp20),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Text(
              'Cancel',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.textFontWeight600
                  .onColor(context.resources.color.colorBlue356DCE),
            ),
          ),
        ),
      ],
    );
  }
}
