import 'package:equatable/equatable.dart';
import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/base_entity.dart';

// ignore: must_be_immutable
class ApiResponse<T extends BaseModel> extends Equatable {
  bool? isSuccess;
  String? message;
  String? messageAR;
  String? isManager;
  T? data;
  ApiResponse({this.isSuccess, this.message, this.messageAR, this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>)? create) {
    return ApiResponse<T>(
      isSuccess: json["IsSuccess"],
      message: json["Message"],
      messageAR: json["MessageAR"],
      data: create != null ? create(json) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "IsSuccess": this.isSuccess,
        "Message": this.message, 
        "MessageAR": this.messageAR,
        "data": this.data?.toJson(),
      };

  @override
  List<Object?> get props => [isSuccess, message, messageAR, data];
}

extension SourceModelExtension on ApiResponse {
  ApiEntity<T> toEntity<T extends BaseEntity>(T entity) {
    final apiEntity = ApiEntity<T>();
    apiEntity.isSuccess = isSuccess;
    apiEntity.message = message;
    apiEntity.messageAR = messageAR;
    apiEntity.entity = entity;
    return apiEntity;
  }

  ApiEntity toApiEntity() {
    final apiEntity = ApiEntity();
    apiEntity.isSuccess = isSuccess;
    apiEntity.message = message;
    apiEntity.messageAR = messageAR;
    return apiEntity;
  }

  ApiEntity<T> toEntity2<T extends BaseEntity>() {
    final apiEntity = ApiEntity<T>();
    apiEntity.isSuccess = isSuccess;
    apiEntity.message = message;
    apiEntity.messageAR = messageAR;
    apiEntity.entity = data?.toEntity();
    return apiEntity;
  }
}
