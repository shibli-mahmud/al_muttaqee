import 'dart:io';

import 'package:dio/dio.dart';
import 'package:islamic_app/src/core/config/build_config.dart';
import 'package:dio/dio.dart';
import 'package:islamic_app/src/core/network/dio_network_provider.dart';
import 'package:islamic_app/src/core/network/network_error_handler.dart';
import 'package:islamic_app/src/core/utils/exceptions/error_handlers.dart';
import 'package:islamic_app/src/core/utils/exceptions/exceptions.dart';


/// An abstract class representing a remote data source for network requests.
abstract class BaseRemoteDatasource {
  final baseUrl = BuildConfig.instance.envConfig.baseUrl;

  /// The Dio client used for making API requests with headers.
  Dio get dioClient => NetworkProvider.dioWithHeaderToken;

  /// The logger instance for logging network-related information.
  final logger = BuildConfig.instance.envConfig.logger;

  /// Makes an API request with error handling and response parsing.
  ///
  /// This method takes a generic API request and handles Dio exceptions as well as custom error handling.
  ///
  /// Returns a [Response] containing the parsed API response data.
  Future<Response<T>> callApi<T>(Future<Response<T>> api) async {
    try {
      Response<T> response = await api;
      // if (response.statusCode != HttpStatus.ok ||
      //     (response.data as Map<String, dynamic>)['statusCode'] !=
      //         HttpStatus.ok) {
      //   // TODO: Handle the response error.
      // }
      if (response.statusCode != HttpStatus.ok) {
        logger.i(response.toString());
        final message = (response.data as Map<String, dynamic>)["msg"];
        logger.i(message);
      }
      if (response.data is Map<String, dynamic>) {
        if ((response.data as Map<String, dynamic>)['statusCode'] !=
            HttpStatus.ok) {
          // TODO: Handle the response error.
        }
      }

      return response;
    } on DioException catch (dioError) {
      logger.e(
        "Throwing error from datasource: >>>>>>> $dioError ${dioError.response} ${dioError.message}",
      );
      Exception exception = handleNetworkError(dioError);
      throw exception;
    } catch (error) {
      logger.e("Generic error: >>>>>>> $error");

      if (error is BaseException) {
        rethrow;
      }

      throw handleError("$error");
    }
  }
}
