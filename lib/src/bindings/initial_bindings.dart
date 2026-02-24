import 'package:get/get.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';


class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PreferenceManagerImpl(),
      fenix: true,
    );
  //   Get.lazyPut(
  //     () => AuthRemoteDatasourceImpl(),
  //     fenix: true,
  //   );
  //   Get.lazyPut(
  //     () => LocationRemoteDatasourceImpl(),
  //     fenix: true,
  //   );
  //
  //   Get.putAsync<AuthService>(
  //     () async => await AuthService(
  //       prefManager: PreferenceManagerImpl.to,
  //       remoteDatasource: AuthRemoteDatasourceImpl.to,
  //     ).init(),
  //     permanent: true,
  //   );
  //   Get.lazyPut(
  //     () => LocationService(
  //       prefManager: PreferenceManagerImpl.to,
  //       remoteDatasource: LocationRemoteDatasourceImpl.to,
  //     ),
  //     fenix: true,
  //   );
  //   Get.lazyPut(
  //     () => AuthService(
  //       prefManager: PreferenceManagerImpl.to,
  //       remoteDatasource: AuthRemoteDatasourceImpl.to,
  //     ),
  //     fenix: true,
  //   );
  //   Get.lazyPut(
  //     () => SocketService(),
  //     fenix: true,
  //   );
  //   Get.lazyPut(
  //     () => FirebaseService(),
  //     fenix: true,
  //   );
  //   Get.lazyPut(
  //     () => PermissionService(
  //       firebaseService: FirebaseService.to,
  //       locationService: LocationService.to,
  //       socketService: SocketService.to,
  //     ),
  //     fenix: true,
  //   );
  //   ChatListBinding().dependencies();
  //   ChatBinding().dependencies();
  //   PreferenceBinding().dependencies();
  }
}
