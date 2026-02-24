
import 'package:al_muttaqee/src/core/config/build_config.dart';
import 'package:al_muttaqee/src/core/utils/exceptions/exceptions.dart';

Exception handleError(String error) {
  final logger = BuildConfig.instance.envConfig.logger;
  logger.e("Generic exception: $error");

  return ApplicationException(message: error);
}
