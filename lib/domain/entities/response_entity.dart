// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class ResponseEntity extends BaseEntity {
  ResponseEntity();

  @override
  List<Object?> get props => [isSuccess, message, messageAR];
}
