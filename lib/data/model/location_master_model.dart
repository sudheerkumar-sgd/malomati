import 'package:malomati/data/model/base_model.dart';

class LocationMasterModel extends BaseModel {
  final List<Map<String, dynamic>> locations;

  LocationMasterModel({this.locations = const []});

  factory LocationMasterModel.fromJson(Map<String, dynamic> json) {
    final locationMaster = json['location-master'];
    if (locationMaster is! List) {
      return LocationMasterModel();
    }

    return LocationMasterModel(
      locations: locationMaster
          .whereType<Map>()
          .map((e) => e.map((key, value) => MapEntry('$key', value)))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'location-master': locations,
    };
  }

  @override
  List<Object?> get props => [locations];

  @override
  dynamic toEntity<T>() => locations;
}
