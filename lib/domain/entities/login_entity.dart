import 'package:malomati/domain/entities/base_entity.dart';

class LoginEntity extends BaseEntity {
  String? oracleLoginId;
  String? fullNameAR;
  String? fullNameUS;

  LoginEntity();
  @override
  List<Object?> get props => [oracleLoginId, fullNameAR, fullNameUS];
}
