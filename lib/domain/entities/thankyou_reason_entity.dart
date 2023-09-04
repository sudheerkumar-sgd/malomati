// ignore_for_file: must_be_immutable

import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/base_entity.dart';

class ThankyouReasonEntity extends BaseEntity {
  String? lOOKUP_CODE;
  String? mEANING;
  String? attribute8;

  ThankyouReasonEntity();

  @override
  List<Object?> get props => [lOOKUP_CODE, mEANING, attribute8];
  @override
  String toString() {
    return isLocalEn ? mEANING ?? '' : attribute8 ?? '';
  }
}
