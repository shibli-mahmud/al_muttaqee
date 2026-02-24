import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:islamic_app/src/core/base/base_view.dart';
import 'package:islamic_app/src/module/splash/controllers/splash_controller.dart';

class SplashView extends BaseView<SplashController>{
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Splash Screen"),
      ),
    );
  }


}