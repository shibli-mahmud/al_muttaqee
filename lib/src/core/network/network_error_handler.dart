import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:islamic_app/l10n/app_localizations.dart';
import 'package:islamic_app/src/core/config/build_config.dart';
import 'package:islamic_app/src/core/utils/exceptions/exceptions.dart';


Exception handleNetworkError(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.cancel:
      return ApplicationException(
        message: "AppLocalizations.of(Get.context!)!.connectionCancelledError",
      );
    case DioExceptionType.connectionTimeout:
      return ApplicationException(
        message: "AppLocalizations.of(Get.context!)!.establishConnectionError",
      );
    case DioExceptionType.unknown:
      return NetworkException(
        message: "AppLocalizations.of(Get.context!)!.noInternetConnection",
      );
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return TimeoutException(
        message: "AppLocalizations.of(Get.context!)!.establishConnectionError",
      );
    case DioExceptionType.badCertificate:
      return ApplicationException(
        message: "AppLocalizations.of(Get.context!)!.invalidCertificate",
      );
    case DioExceptionType.badResponse:
      return _parseNetworkErrorResponse(dioError);
    default:
      return ApplicationException(
        message: "AppLocalizations.of(Get.context!)!.unknownError",
      );
  }
}

Exception _parseNetworkErrorResponse(DioException dioError) {
  final logger = BuildConfig.instance.envConfig.logger;

  int statusCode = dioError.response?.statusCode ?? -1;
  int? status;
  String? serverMessage;

  logger.e(statusCode);

  try {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      statusCode = dioError.response?.data["status"];
    }
    logger.i(dioError.stackTrace);
    logger.i(dioError.response?.data);
    status = dioError.response?.data["status"];
    serverMessage = dioError.response?.data["msg"] ?? dioError.response?.data["error"];
  } catch (e, s) {
    logger.i("$e");
    logger.i(s.toString());

    serverMessage = "AppLocalizations.of(Get.context!)!.somethingWentWrong";
  }

  switch (statusCode) {
    case HttpStatus.serviceUnavailable:
      return ServiceUnavailableException(
        message: "AppLocalizations.of(Get.context!)!.serviceUnavailable",
        status: status.toString(),
      );
    case HttpStatus.notFound:
      return NotFoundException(
        message: serverMessage ?? "",
        status: status.toString(),
      );
    case HttpStatus.unauthorized:
      return UnauthorizedException(
        message: serverMessage ?? "",
        status: status.toString(),
      );
    default:
      return ApiException(
        httpCode: statusCode,
        status: status.toString(),
        message: serverMessage ?? "AppLocalizations.of(Get.context!)!.somethingWentWrong",
      );
  }
}
