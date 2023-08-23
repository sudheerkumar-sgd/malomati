import 'package:equatable/equatable.dart';

class NameIdEntity extends Equatable {
  final String? id;
  final String? name;
  const NameIdEntity(this.id, this.name);
  @override
  String toString() {
    return name ?? '';
  }

  @override
  List<Object?> get props => [id, name];
}
