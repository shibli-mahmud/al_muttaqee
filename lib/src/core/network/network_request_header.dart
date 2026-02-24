import 'package:dio/dio.dart';
import 'package:get/get.dart' as route;
import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  // final authService = AuthService.to;
  //
  // @override
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   getCustomHeaders().then((customHeaders) {
  //     options.headers.addAll(customHeaders);
  //     super.onRequest(options, handler);
  //   });
  // }
  //
  // Future<Map<String, String>> getCustomHeaders() async {
  //   var customHeaders = {'content-type': 'application/json'};
  //
  //   final token = authService.accessToken;
  //   // final token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjY4LjE1NDo4MDAwXC9hcGlcL2F1dGhcL2xvZ2luIiwiaWF0IjoxNzMwNzE3MTk3LCJleHAiOjE3MzA3MjA3OTcsIm5iZiI6MTczMDcxNzE5NywianRpIjoiOU43Q1doc0dmbmNWTmZDOCIsInN1YiI6MTE1LCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.lhq-ZXAoQrji992JkxYcqy4ceRTyYvRa1ECAR3QVOCw";
  //
  //   if (token.isNotEmpty) {
  //     customHeaders.addAll(
  //       {"Authorization": "Bearer ${token}"},
  //     );
  //   }
  //   customHeaders.addAll({
  //     "Accept-Language": L10n.selectedLocale.languageCode,
  //   });
  //
  //   return customHeaders;
  // }
  //
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   return super.onResponse(response, handler);
  // }
  //
  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   if (err.response?.statusCode == 401) {
  //     if (err.response?.realUri.path == '/api/${AppStrings.urlLogin}') {
  //       handler.next(err);
  //       return;
  //     }
  //     await authService.logout();
  //
  //     route.Get.offAllNamed(
  //       Routes.AUTH,
  //     );
  //   }
  //   handler.next(err);
  // }
  //
  // Future<Response<dynamic>> _retry(
  //   RequestOptions requestOptions,
  //   String token,
  // ) async {
  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: {
  //       "Authorization": "Bearer ${token}",
  //     },
  //   );
  //
  //   return Dio().request<dynamic>(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }
}
