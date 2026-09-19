import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../core/theme/app_theme.dart';
import '../data/services/api_service.dart';
import '../modules/login/views/login_page.dart';

class IceLinkApp extends StatelessWidget {
  const IceLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ICELINK',
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(ApiService(), permanent: true);
        Get.put(LoginController());
      }),
      home: const LoginPage(),
      theme: AppTheme.light,
    );
  }
}
