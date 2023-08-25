// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/res/resources.dart';

class ApiEntity<T extends BaseEntity> extends BaseEntity {
  T? entity;

  ApiEntity({this.entity});
  String getDisplayMessage(Resources resources) {
    return resources.isLocalEn ? message ?? '' : messageAR ?? '';
  }

  @override
  List<Object?> get props => [isSuccess, message, messageAR];
}
