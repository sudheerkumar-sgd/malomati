// ignore_for_file: must_be_immutable
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/base_entity.dart';

class LeaveTypeEntity extends BaseEntity {
  String? name;
  String? nameAr;
  int? id;
  String? hoursOrDays;

  LeaveTypeEntity();

  @override
  List<Object?> get props => [id, name, hoursOrDays];
  @override
  String toString() {
    return isLocalEn ? name ?? '' : nameAr ?? (name ?? '');
  }
}

class WorkingDaysEntity extends BaseEntity {
  String? noOfDays;

  WorkingDaysEntity();

  @override
  List<Object?> get props => [noOfDays];
}
