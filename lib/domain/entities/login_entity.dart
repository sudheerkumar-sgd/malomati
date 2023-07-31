import 'package:malomati/domain/entities/base_entity.dart';

class LoginEntity extends BaseEntity {
  final String? token;

  LoginEntity({required this.token, t});
  @override
  List<Object?> get props => [
        token,
      ];
}
