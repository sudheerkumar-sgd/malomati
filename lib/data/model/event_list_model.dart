import 'package:malomati/data/model/base_model.dart';
import 'package:malomati/data/model/event_model.dart';
import 'package:malomati/domain/entities/base_entity.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/domain/entities/events_list_entity.dart';
import '../../domain/entities/attendance_entity.dart';

// ignore: must_be_immutable
class EventListModel extends BaseModel {
  List<EventsEntity> eventsList = [];

  EventListModel();

  factory EventListModel.fromJson(Map<String, dynamic> json) {
    var birthdayListJson = [];
    var anniversaryListJson = [];
    var newJoineeListJson = [];
    if (json['BirthdayList'] != null) {
      birthdayListJson = json['BirthdayList'] as List;
    }
    if (json['AnniversaryList'] != null) {
      anniversaryListJson = json['AnniversaryList'] as List;
    }
    if (json['NewJoineeList'] != null) {
      newJoineeListJson = json['NewJoineeList'] as List;
    }

    final birthdayList = birthdayListJson
        .map((birthday) => EventModel.fromJson(birthday).toEventsEntity())
        .toList();
    final anniversaryList = anniversaryListJson
        .map((anniversary) => EventModel.fromJson(anniversary).toEventsEntity())
        .toList();
    final newJoineeList = newJoineeListJson
        .map((newJoinee) => EventModel.fromJson(newJoinee).toEventsEntity())
        .toList();
    var eventListModel = EventListModel();
    eventListModel.eventsList.addAll(birthdayList);
    eventListModel.eventsList.addAll(anniversaryList);
    eventListModel.eventsList.addAll(newJoineeList);
    if (eventListModel.eventsList.isEmpty) {
      eventListModel.eventsList.add(EventsEntity());
    }
    return eventListModel;
  }

  @override
  Map<String, dynamic> toJson() => {};

  @override
  List<Object?> get props => [eventsList];

  @override
  BaseEntity toEntity<T>() {
    return AttendanceEntity();
  }
}

extension SourceModelExtension on EventListModel {
  EventsListEntity toEventsListEntity() {
    EventsListEntity eventsListEntity = EventsListEntity();
    eventsListEntity.eventsList = eventsList;
    return eventsListEntity;
  }
}
