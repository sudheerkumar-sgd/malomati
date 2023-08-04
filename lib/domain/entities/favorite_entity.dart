// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class FavoriteEntity extends BaseEntity {
  String? name;
  String? iconPath;

  FavoriteEntity({this.name, this.iconPath});

  FavoriteEntity.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] as String;
    iconPath = json['iconPath'] as String;
  }
  @override
  List<Object?> get props => [name, iconPath];
}

extension SourceModelExtension on FavoriteEntity {
  FavoriteEntity get toFavoriteEntity =>
      FavoriteEntity(name: name, iconPath: iconPath);
}
