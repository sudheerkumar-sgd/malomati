// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class LeaveDetailsEntity extends Equatable {
  String? id;
  String? nameUS;
  String? nameAR;
  @override
  String toString() {
    return nameUS ?? '';
  }

  @override
  List<Object?> get props => [id, nameUS, nameAR];
}
