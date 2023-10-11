// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class WeatherEntity extends BaseEntity {
  var temperature;
  var weathercode;

  WeatherEntity({this.temperature, this.weathercode});

  @override
  List<Object?> get props => [
        temperature,
        weathercode,
      ];
}
