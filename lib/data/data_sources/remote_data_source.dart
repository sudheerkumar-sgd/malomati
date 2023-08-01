import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/data/model/api_response_model.dart';
import 'package:malomati/data/model/login_model.dart';
import 'package:malomati/data/model/profile_model.dart';
import '../../config/constant_config.dart';

abstract class RemoteDataSource {
  Future<ApiResponse<LoginModel>> login(
      {required apiPath, required Map<String, dynamic> requestParams});
  Future<ApiResponse<ProfileModel>> getProfile(
      {required Map<String, dynamic> requestParams});
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;
  final ConstantConfig constantConfig;

  RemoteDataSourceImpl({
    required this.dio,
    required this.constantConfig,
  });

  @override
  Future<ApiResponse<LoginModel>> login(
      {required apiPath, required Map<String, dynamic> requestParams}) async {
    var response = await dio.post(
      apiPath,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      data: jsonEncode(requestParams),
    );

    if (response.statusCode == 200) {
      var apiResponse = ApiResponse<LoginModel>.fromJson(
          response.data, (p0) => LoginModel.fromJson(response.data));
      return apiResponse;
    } else {
      throw DioException(requestOptions: RequestOptions());
    }
  }

  @override
  Future<ApiResponse<ProfileModel>> getProfile(
      {required Map<String, dynamic> requestParams}) async {
    var response = await dio.get(
      'Profile',
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      }),
      queryParameters: requestParams,
    );

    if (response.statusCode == 200) {
      var apiResponse = ApiResponse<ProfileModel>.fromJson(
          response.data, (p0) => ProfileModel.fromJson(response.data));
      return apiResponse;
    } else {
      throw DioException(requestOptions: RequestOptions());
    }
  }
}
