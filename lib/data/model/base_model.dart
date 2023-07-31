import 'package:equatable/equatable.dart';
import 'package:malomati/domain/entities/base_entity.dart';

abstract class BaseModel extends Equatable {
  Map<String, dynamic> toJson();
  BaseEntity toEntity<T>();
}
