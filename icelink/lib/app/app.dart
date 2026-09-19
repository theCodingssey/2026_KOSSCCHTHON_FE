import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../core/theme/app_theme.dart';
import '../data/services/ice_link_api_service.dart';
import '../data/services/api_service.dart';
import '../data/services/session_storage_service.dart';
import '../pages/login/views/login_page.dart';

class IceLinkApp extends StatelessWidget {
  const IceLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IceLink',
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        final apiService = Get.put(ApiService(), permanent: true);
        Get.put(IceLinkApiService(apiService), permanent: true);
        Get.put(SessionStorageService(), permanent: true);
        Get.put(LoginController());
      }),
      home: const LoginPage(),
      theme: AppTheme.light,
    );
  }
}
