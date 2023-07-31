import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

const String messageConnectionFailure = 'No Network Available';

class ServerFailure extends Failure {
  final String errorMessage;

  ServerFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'ServerFailure{errorMessage: $errorMessage}';
  }
}

class ConnectionFailure extends Failure {
  final String errorMessage = messageConnectionFailure;

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'ConnectionFailure{errorMessage: $errorMessage}';
  }
}
