import 'package:dartz/dartz.dart';
import 'package:malomati/domain/repository/apis_repository.dart';
import 'package:malomati/domain/use_case/base_usecase.dart';
import '../../core/error/failures.dart';
import '../entities/api_entity.dart';
import '../entities/finance_approval_entity.dart';
import '../entities/leave_submit_response_entity.dart';
import '../entities/request_details_entity.dart';

class RequestsUseCase extends BaseUseCase {
  final ApisRepository apisRepository;
  RequestsUseCase({required this.apisRepository});

  Future<Either<Failure, List<FinanceApprovalEntity>>> getRequestsList(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getRequestsList(requestParams: requestParams);
  }

  Future<Either<Failure, RequestDetailsEntity>> getRequestlDetails(
      {required Map<String, dynamic> requestParams}) async {
    return await apisRepository.getRequestlDetails(
        requestParams: requestParams);
  }

  Future<Either<Failure, ApiEntity<LeaveSubmitResponseEntity>>>
      submitHrApproval({required Map<String, dynamic> requestParams}) async {
    return await apisRepository.submitHrApproval(requestParams: requestParams);
  }
}
