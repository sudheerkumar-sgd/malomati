import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/base_entity.dart';

// ignore: must_be_immutable
class NameIdEntity extends BaseEntity {
  final String? id;
  final String? name;
  final String? nameAR;
  NameIdEntity(this.id, this.name, {this.nameAR});
  @override
  String toString() {
    return isLocalEn ? name ?? '' : (nameAR ?? name ?? '');
  }

  @override
  List<Object?> get props => [id];
}

// ignore: must_be_immutable
class ListEntity extends BaseEntity {
  List<dynamic> list = [];

  ListEntity();
  @override
  List<Object?> get props => [list];
}
