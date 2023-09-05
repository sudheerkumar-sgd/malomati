import 'dart:convert';
import 'dart:typed_data';

import 'package:malomati/core/common/log.dart';
import 'package:malomati/domain/entities/attachment_entity.dart';

class AttachmentModel {
  String? fileName;
  Uint8List? fileData;

  AttachmentModel();

  AttachmentModel.fromJson(Map<String, dynamic> json) {
    //final json = jsonDecode(json2);
    fileName = json['FILE_NAME'];
    try {
      printLog(message: '${json['FILE_DATA']}');
      fileData =
          base64.decode('${json['FILE_DATA']}'.replaceAll(RegExp(r'\s+'), ''));
    } catch (exception) {
      printLog(message: exception.toString());
    }
  }
}

extension SourceModelExtension on AttachmentModel {
  AttachmentEntity toAttachmentEntity() {
    var attachmentEntity = AttachmentEntity();
    attachmentEntity.fileName = fileName;
    attachmentEntity.fileData = fileData;
    return attachmentEntity;
  }
}
