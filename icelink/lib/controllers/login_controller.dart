import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/login_session.dart';
import '../modules/home/views/home_page.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final name = ''.obs;
  final isSubmitting = false.obs;

  bool get canSubmit => name.value.trim().isNotEmpty && !isSubmitting.value;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      name.value = nameController.text;
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final trimmedName = name.value.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    isSubmitting.value = true;
    final session = LoginSession.create(trimmedName);

    // TODO: Send session.toRequest().toJson() with Dio after backend endpoint is fixed.
    await Future<void>.delayed(const Duration(milliseconds: 180));
    isSubmitting.value = false;

    Get.offAll(
      () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.put(HomeController(session: session));
      }),
    );
  }
}
