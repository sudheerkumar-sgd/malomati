import 'package:equatable/equatable.dart';
import 'package:malomati/core/constants/constants.dart';

const String unknownErroeMessage = 'An unknown error has occured';

String _localized({
  required String en,
  required String ar,
}) =>
    isLocalEn ? en : ar;

/// Converts low-level exceptions (e.g. DioException dumps) into short,
/// user-facing messages. This intentionally strips stack/details/HTML.
String sanitizeFailureMessage(String raw) {
  var message = raw.trim();
  if (message.isEmpty) return unknownErroeMessage;

  // Strip common noisy blocks.
  message = message.replaceAll(RegExp(r'<[^>]+>'), ' ').trim(); // HTML tags
  message = message.replaceAll(RegExp(r'\s+'), ' ').trim();

  // Network/offline patterns.
  final lower = message.toLowerCase();
  if (lower.contains('socketexception') ||
      lower.contains('failed host lookup') ||
      lower.contains('connection refused') ||
      lower.contains('network is unreachable') ||
      lower.contains('no internet')) {
    return _localized(
      en: 'No internet connection. Please try again.',
      ar: 'لا يوجد اتصال بالإنترنت. يرجى المحاولة مرة أخرى.',
    );
  }

  if (lower.contains('timed out') ||
      lower.contains('timeout') ||
      lower.contains('connection timeout') ||
      lower.contains('receive timeout') ||
      lower.contains('send timeout')) {
    return _localized(
      en: 'Request timed out. Please try again.',
      ar: 'انتهت مهلة الطلب. يرجى المحاولة مرة أخرى.',
    );
  }

  // HTTP status-code mapping (works even if we only have the exception string).
  final statusMatch =
      RegExp(r'status code (of )?(\d{3})').firstMatch(lower) ??
          RegExp(r'http\s*status\s*code[:\s]*(\d{3})').firstMatch(lower);
  final codeStr = statusMatch?.group(statusMatch.groupCount);
  final code = int.tryParse(codeStr ?? '');
  if (code != null) {
    if (code == 401 || code == 403) {
      return _localized(
        en: 'Your session has expired. Please log in again.',
        ar: 'انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى.',
      );
    }
    if (code == 404) {
      return _localized(
        en: 'Service not found (404). Please try again later.',
        ar: 'الخدمة غير متوفرة (404). يرجى المحاولة لاحقاً.',
      );
    }
    if (code == 429) {
      return _localized(
        en: 'Too many requests. Please try again in a moment.',
        ar: 'طلبات كثيرة جداً. يرجى المحاولة بعد قليل.',
      );
    }
    if (code == 503) {
      return _localized(
        en: 'Service temporarily unavailable (503). Please try again later.',
        ar: 'الخدمة غير متاحة مؤقتاً (503). يرجى المحاولة لاحقاً.',
      );
    }
    if (code >= 500 && code <= 599) {
      return _localized(
        en: 'Server error ($code). Please try again later.',
        ar: 'خطأ في الخادم ($code). يرجى المحاولة لاحقاً.',
      );
    }
    if (code >= 400 && code <= 499) {
      return _localized(
        en: 'Request failed ($code). Please check and try again.',
        ar: 'فشل الطلب ($code). يرجى التحقق والمحاولة مرة أخرى.',
      );
    }
  }

  // DioException: keep only a short summary if possible.
  if (lower.contains('dioexception')) {
    return _localized(
      en: 'Something went wrong. Please try again.',
      ar: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
    );
  }

  // If the backend returns a message we can show, keep it short.
  if (message.length > 180) {
    return _localized(
      en: 'Something went wrong. Please try again.',
      ar: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
    );
  }

  return message;
}

abstract class Failure extends Equatable {
  String get errorMessage;
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'ServerFailure{errorMessage: $errorMessage}';
  }

  @override
  String get errorMessage => message.isNotEmpty
      ? sanitizeFailureMessage(message)
      : unknownErroeMessage;
}

class ConnectionFailure extends Failure {
  final String message =
      isLocalEn ? 'No Internet Connection' : 'يرجى التأكد من تشغيل Wi-Fi';

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'ConnectionFailure{message: $message}';
  }

  @override
  String get errorMessage => message;
}

class UnknownFailure extends Failure {
  final String message = 'An unknown error has occured';

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'ConnectionFailure{message: $message}';
  }

  @override
  String get errorMessage => message;
}

class Exception extends Failure {
  final String exception;
  Exception(this.exception);

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() {
    return 'Exception{exception: $exception}';
  }

  @override
  String get errorMessage =>
      exception.isNotEmpty
          ? sanitizeFailureMessage(exception)
          : unknownErroeMessage;
}
