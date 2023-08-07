// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class FavoriteEntity extends BaseEntity {
  String? name;
  String? nameAR;
  String? iconPath;

  FavoriteEntity({this.name, this.nameAR, this.iconPath});

  FavoriteEntity.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] as String;
    nameAR = json['nameAR'] as String;
    iconPath = json['iconPath'] as String;
  }
  @override
  List<Object?> get props => [name, nameAR, iconPath];
}

extension SourceModelExtension on FavoriteEntity {
  FavoriteEntity get toFavoriteEntity =>
      FavoriteEntity(name: name, nameAR: nameAR, iconPath: iconPath);
}
