// ignore_for_file: must_be_immutable

import 'package:malomati/domain/entities/base_entity.dart';

class LoginEntity extends BaseEntity {
  String? oracleLoginId;
  String? iSMANAGER;
  String? fullNameAR;
  String? fullNameUS;
  String? departmentId;
  String? jobName;
  String? jobNameAr;

  LoginEntity();
  @override
  List<Object?> get props => [
        oracleLoginId,
        fullNameAR,
        fullNameUS,
        iSMANAGER,
        departmentId,
        jobName,
        jobNameAr
      ];
}
