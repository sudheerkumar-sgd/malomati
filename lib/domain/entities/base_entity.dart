// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class BaseEntity extends Equatable {
  bool? isSuccess;
  String? message;
  String? messageAR;


  @override
  List<Object?> get props => [isSuccess, message, messageAR];
}
