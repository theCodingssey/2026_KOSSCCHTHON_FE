import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/views/home_page.dart';

class IceBreakingCompletePage extends StatelessWidget {
  const IceBreakingCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.celebration_rounded,
                    color: AppTheme.primaryBlue,
                    size: 92,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '수고하셨습니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '아이스 브레이킹이 종료되었습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {
                      Get.offAll(
                        () => const HomePage(),
                        binding: BindingsBuilder(() {
                          Get.put(HomeController());
                        }),
                      );
                    },
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('메인으로 가기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
