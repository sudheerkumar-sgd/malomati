import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/response_entity.dart';

class ResponseModel extends BaseModel {
  ResponseModel();
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel();
  }
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  ResponseEntity toEntity<BaseEntity>() {
    return ResponseEntity();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
