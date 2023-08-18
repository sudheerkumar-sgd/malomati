// ignore_for_file: must_be_immutable
import 'package:malomati/domain/entities/base_entity.dart';

class LeaveTypeEntity extends BaseEntity {
  String? name;
  int? id;
  String? hoursOrDays;

  LeaveTypeEntity();

  @override
  List<Object?> get props => [id, name, hoursOrDays];
  @override
  String toString() {
    return name ?? '';
  }
}
