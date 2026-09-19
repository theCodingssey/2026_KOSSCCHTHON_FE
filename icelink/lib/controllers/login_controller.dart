import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/login_session.dart';
import '../data/services/ice_link_api_service.dart';
import '../data/services/session_storage_service.dart';
import '../pages/home/views/home_page.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final name = ''.obs;
  final isSubmitting = false.obs;
  final isRestoringSession = false.obs;

  bool get canSubmit => name.value.trim().isNotEmpty && !isSubmitting.value;

  IceLinkApiService get _api => Get.find<IceLinkApiService>();
  SessionStorageService get _storage => Get.find<SessionStorageService>();

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

  @override
  void onReady() {
    super.onReady();
    _restoreSession();
  }

  Future<void> login() async {
    final trimmedName = name.value.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    isSubmitting.value = true;
    try {
      final session = await _createSession(trimmedName);
      _openHome(session);
    } catch (error) {
      Get.snackbar('로그인 실패', _errorMessage(error));
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<LoginSession> _createSession(String trimmedName) async {
    if (!_api.isConfigured || Get.testMode) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      return LoginSession.create(trimmedName);
    }

    final session = await _api.registerUser(trimmedName);
    final userKey = session.userKey;
    if (userKey != null && userKey.isNotEmpty) {
      await _storage.saveUserKey(userKey);
      _api.setUserKey(userKey);
    }

    return session;
  }

  Future<void> _restoreSession() async {
    if (!_api.isConfigured || Get.testMode || isRestoringSession.value) {
      return;
    }

    isRestoringSession.value = true;
    try {
      final userKey = await _storage.readUserKey();
      if (userKey == null || userKey.isEmpty) {
        return;
      }

      _api.setUserKey(userKey);
      final me = await _api.fetchMe();
      _openHome(
        LoginSession(
          name: me.stringValue('name', fallback: '사용자'),
          userKey: userKey,
        ),
      );
    } catch (_) {
      await _storage.clearUserKey();
      _api.clearUserKey();
    } finally {
      isRestoringSession.value = false;
    }
  }

  void _openHome(LoginSession session) {
    Get.offAll(
      () => const HomePage(),
      binding: BindingsBuilder(() {
        Get.put(HomeController(session: session));
      }),
    );
  }

  String _errorMessage(Object error) {
    final problem = _problemDetail(error);
    final code = problem?['code'];
    if (code == 'USER_KEY_CONFLICT') {
      return '다른 이름을 입력해 주세요.';
    }
    if (problem != null) {
      return problem.stringValue('detail', fallback: '서버 요청에 실패했습니다.');
    }
    return '서버 요청에 실패했습니다.';
  }

  Map<String, dynamic>? _problemDetail(Object error) {
    if (error is! DioException) {
      return null;
    }

    final response = error.response?.data;
    if (response is Map<String, dynamic>) {
      return response;
    }
    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }
    return null;
  }
}
