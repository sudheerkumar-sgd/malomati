import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/login_entity.dart';

class LoginModel extends BaseModel {
  String? oracleLoginId;
  String? fullNameAR;
  String? fullNameUS;

  LoginModel();

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var loginModel = LoginModel();
    loginModel.oracleLoginId = json['ORACLE_LOGIN'];
    loginModel.fullNameAR = json['FULL_NAME_AR'];
    loginModel.fullNameUS = json['FULL_NAME_US'];
    return loginModel;
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": oracleLoginId,
      };

  @override
  List<Object?> get props => [oracleLoginId];

  @override
  BaseEntity toEntity<T>() {
    return LoginEntity();
  }
}

extension SourceModelExtension on LoginModel {
  LoginEntity toLoginEntity() {
    var loginEntity = LoginEntity();
    loginEntity.oracleLoginId = oracleLoginId;
    loginEntity.fullNameUS = fullNameUS;
    loginEntity.fullNameAR = fullNameAR;
    return loginEntity;
  }
}
