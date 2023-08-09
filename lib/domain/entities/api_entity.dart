// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class ApiEntity<T extends BaseEntity> extends BaseEntity {
  bool? isSuccess;
  String? message;
  String? messageAR;
  T? entity;

  ApiEntity({this.isSuccess, this.message, this.messageAR, this.entity});
  @override
  List<Object?> get props => [isSuccess, message, messageAR];
}
