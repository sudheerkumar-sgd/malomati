import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';

import '../../domain/entities/login_entity.dart';

class LoginModel extends BaseModel {
  final String? token;

  LoginModel({
    required this.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json["Token"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "token": token,
      };

  @override
  List<Object?> get props => [token];

  @override
  BaseEntity toEntity<T>() {
    return LoginEntity(token: token);
  }
}

extension SourceModelExtension on LoginModel {
  LoginEntity get toLoginEntity => LoginEntity(
        token: '$token',
      );
}
