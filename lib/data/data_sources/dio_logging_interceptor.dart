// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:malomati/core/constants/constants.dart';
import '../../config/flavor_config.dart';

class DioLoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (authorizationToken.isNotEmpty) {
      options.headers.addAll({
        HttpHeaders.authorizationHeader: authorizationToken,
      });
    }
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}");
      print('Headers:');
      options.headers.forEach((k, v) => print('$k: $v'));
      print('queryParameters:');
      options.queryParameters.forEach((k, v) => print('$k: $v'));
      if (options.data != null) {
        print('Body: ${options.data}');
      }
      print("--> END ${options.method.toUpperCase()}");
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "<-- ${response.statusCode} ${(response.requestOptions.baseUrl + response.requestOptions.path)}");
      print('Headers:');
      response.headers.forEach((k, v) => print('$k: $v'));
      print('Response: ${response.data}');
      print('<-- END HTTP');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (FlavorConfig.instance.flavor == Flavor.DEVELOPMENT) {
      print(
          "<-- ${err.message} ${err.response?.requestOptions.baseUrl}${err.response?.requestOptions.path}");
      print("${err.response?.data}");
      print('<-- End error');
    }
    super.onError(err, handler);
  }
}
