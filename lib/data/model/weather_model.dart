// ignore_for_file: must_be_immutable

import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/weather_entity.dart';

class WeatherModel extends BaseModel {
  var temperature;
  var weathercode;

  WeatherModel();

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    var weatherModel = WeatherModel();
    weatherModel.temperature = json['temperature'];
    weatherModel.weathercode = json['weathercode'];
    return weatherModel;
  }

  @override
  List<Object?> get props => [
        temperature,
        weathercode,
      ];

  @override
  BaseEntity toEntity<T>() {
    return EmployeeEntity();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

extension SourceModelExtension on WeatherModel {
  WeatherEntity toWeatherEntity() {
    var weatherEntity = WeatherEntity();
    weatherEntity.temperature = temperature;
    weatherEntity.weathercode = weathercode;
    return weatherEntity;
  }
}
