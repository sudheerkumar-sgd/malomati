// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

import 'attachment_entity.dart';
import 'hr_approval_entity.dart';

class HrapprovalDetailsEntity extends BaseEntity {
  List<HrApprovalEntity> notificationDetails = [];
  List<AttachmentEntity> attachements = [];

  HrapprovalDetailsEntity();
  @override
  List<Object?> get props => [notificationDetails];
}
