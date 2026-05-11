import 'package:malomati/domain/repository/attendance_repository.dart';
import 'package:malomati/domain/repository/auth_repository.dart';
import 'package:malomati/domain/repository/home_repository.dart';
import 'package:malomati/domain/repository/services_repository.dart';

export 'attendance_repository.dart';
export 'auth_repository.dart';
export 'home_repository.dart';
export 'services_repository.dart';

/// Composite API repository implemented by [ApisRepositoryImpl].
///
/// Prefer injecting feature-scoped repositories ([HomeRepository], etc.)
/// in new code.
abstract class ApisRepository
    implements AuthRepository, HomeRepository, AttendanceRepository, ServicesRepository {}
