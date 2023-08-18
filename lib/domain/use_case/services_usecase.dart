import 'package:dartz/dartz.dart';
import 'package:malomati/domain/entities/leave_type_list_entity.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import '../../core/error/failures.dart';

class ServicesUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  ServicesUseCase({required this.apisRepository});

  Future<Either<Failure, LeaveTypeListEntity>> getLeaveTypes(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getLeaveTypes(requestParams: requestParams);
  }

  Future<Either<Failure, bool>> submitLeaveRequest(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitLeaveRequest(
        requestParams: requestParams);
  }
}
