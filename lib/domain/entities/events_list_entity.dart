// ignore_for_file: must_be_immutable
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';

class EventsListEntity extends BaseEntity {
  List<EventsEntity> eventsList = [];

  EventsListEntity();
  @override
  List<Object?> get props => [eventsList];
}
