import 'package:dio/dio.dart';
import 'package:al_muttaqee/src/core/config/build_config.dart';
import 'package:al_muttaqee/src/core/network/network_request_header.dart';

/// Provides configured Dio clients for HTTP requests.
class NetworkProvider {
  static Dio? _instance;

  static BaseOptions get _options => BaseOptions(
        baseUrl: BuildConfig.instance.envConfig.baseUrl,
        sendTimeout: const Duration(seconds: 60),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

  /// Dio instance without auth interceptors (public APIs).
  static Dio get httpDio {
    if (_instance == null) {
      _instance = Dio(_options);
      _instance!.interceptors.add(RequestHeaderInterceptor());
      _instance!.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          error: true,
        ),
      );
    } else {
      // Keep baseUrl in sync if BuildConfig was updated after first access.
      _instance!.options.baseUrl = BuildConfig.instance.envConfig.baseUrl;
    }
    return _instance!;
  }

  /// Alias used by features that need header interceptors (same client).
  static Dio get dioWithHeaderToken => httpDio;

  /// Alias for token-authenticated clients (no auth yet — same as httpDio).
  static Dio get tokenClient => httpDio;

  /// Creates a one-off Dio for a different absolute base URL (e.g. Places API).
  static Dio createClient({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        sendTimeout: const Duration(seconds: 60),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'content-type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(RequestHeaderInterceptor());
    return dio;
  }

  NetworkProvider.setContentType(String version) {
    _instance?.options.contentType = 'user_defined_content_type+$version';
  }

  NetworkProvider.setContentTypeApplicationJson() {
    _instance?.options.contentType = 'application/json';
  }
}
