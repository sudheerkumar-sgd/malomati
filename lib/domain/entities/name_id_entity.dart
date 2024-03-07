import 'package:malomati/domain/entities/base_entity.dart';

// ignore: must_be_immutable
class NameIdEntity extends BaseEntity {
  final String? id;
  final String? name;
  NameIdEntity(this.id, this.name);
  @override
  String toString() {
    return name ?? '';
  }

  @override
  List<Object?> get props => [id, name];
}

// ignore: must_be_immutable
class ListEntity extends BaseEntity {
  List<dynamic> list = [];

  ListEntity();
  @override
  List<Object?> get props => [list];
}
