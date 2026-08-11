import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/data/model/attendance_model.dart';
import 'package:malomati/domain/entities/attendance_entity.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';

class LocationAccessManager {
  LocationAccessManager({required AttendanceBloc attendanceBloc})
      : _attendanceBloc = attendanceBloc;

  final AttendanceBloc _attendanceBloc;
  List<LocationAccessEntity> _locationAccessDepartments = [];

  Future<List<LocationAccessEntity>> loadLocationAccessDepartments({
    bool forceRefresh = false,
  }) async {
    final cacheKey = locationAccessDepartments;
    final box = Hive.box(appSettingsDb);
    try {
      final cached = (box.get(cacheKey, defaultValue: <dynamic>[]) as List)
          .map((e) =>
              LocationAccessModel.fromJson(e).toEntity<LocationAccessEntity>())
          .toList();

      if (!forceRefresh && cached.isNotEmpty) {
        _locationAccessDepartments = cached;
        return cached;
      }
    } catch (_) {}

    final fetched = await _fetchDepartments();
    _locationAccessDepartments = fetched;
    box.put(cacheKey, fetched.map((e) => e.toJson()).toList());
    return fetched;
  }

  Future<List<LocationAccessEntity>> _fetchDepartments() async {
    final locations = await _attendanceBloc.getLocationMasterDepartments();
    return locations;
  }

  Future<Map<String, dynamic>> getAllowedDepartmentByLocation(
      double lat, double long) async {
    final currentDepartment = getDepartmentByLocation(lat, long);
    if ((currentDepartment['name'] ?? '').isEmpty) {
      return {};
    }

    // Until access list is loaded, keep the previous behaviour.
    if (_locationAccessDepartments.isEmpty) {
      _locationAccessDepartments = await loadLocationAccessDepartments();
    }

    final allowedDepartments = _locationAccessDepartments
        .map((e) => e.code?.toLowerCase().trim() ?? '')
        .toSet();
    final departmentCode = '${currentDepartment['code'] ?? ''}'.toLowerCase();
    final departmentName = '${currentDepartment['name'] ?? ''}'.toLowerCase();
    return allowedDepartments.contains(departmentCode) ||
            allowedDepartments.contains(departmentName)
        ? currentDepartment
        : {};
  }
}
