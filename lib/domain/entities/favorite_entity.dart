// ignore_for_file: must_be_immutable

import 'package:get/utils.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/domain/entities/base_entity.dart';

class FavoriteEntity extends BaseEntity {
  int? id;
  String? name;
  String? nameAR;
  String? iconPath;

  FavoriteEntity({this.id, this.name, this.nameAR, this.iconPath});

  FavoriteEntity.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'] as String;
    nameAR = json['nameAR'] as String;
    iconPath = json['iconPath'] as String;
    id = json['id'] ?? _getIdByName(name ?? '');
  }
  @override
  List<Object?> get props => [id];

  int _getIdByName(String name) {
    var favoraiteEntity = ConstantConfig()
        .services
        .firstWhereOrNull((element) => element.name == name);
    return favoraiteEntity?.id ?? 0;
  }
}

extension SourceModelExtension on FavoriteEntity {
  FavoriteEntity get toFavoriteEntity =>
      FavoriteEntity(id: id, name: name, nameAR: nameAR, iconPath: iconPath);
}
