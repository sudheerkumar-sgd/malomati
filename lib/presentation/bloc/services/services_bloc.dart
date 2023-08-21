import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/data/model/leave_submit_response_model.dart';
import 'package:malomati/domain/entities/api_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/domain/use_case/services_usecase.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/leave_submit_response_entity.dart';

part 'services_state.dart';

class ServicesBloc extends Cubit<ServicesState> {
  final ServicesUseCase servicesUseCase;
  ServicesBloc({required this.servicesUseCase}) : super(Init());

  Future<void> getLeaveTypes(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result =
        await servicesUseCase.getLeaveTypes(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnLeaveTypesSuccess(leaveTypeEntity: r.leaveTypeList)));
  }

  Future<void> submitLeaveRequest(
      {required Map<String, dynamic> requestParams}) async {
    emit(OnServicesLoading());

    final result =
        await servicesUseCase.submitLeaveRequest(requestParams: requestParams);
    emit(result.fold((l) => OnServicesError(message: _getErrorMessage(l)),
        (r) => OnLeaveSubmittedSuccess(leaveSubmitResponse: r)));
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).errorMessage;
      default:
        return 'An unknown error has occured';
    }
  }
}
