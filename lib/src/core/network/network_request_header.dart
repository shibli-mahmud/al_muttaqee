import 'package:dio/dio.dart';
import 'package:al_muttaqee/l10n/l10n.dart';

/// Adds default headers to every Dio request (content type + Accept-Language).
class RequestHeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'content-type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': L10n.selectedLocale.languageCode,
    });
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
