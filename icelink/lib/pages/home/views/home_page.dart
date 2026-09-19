import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/constants/app_constants.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = controller.session?.name;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 640;
            final iconSize = isCompact ? 190.0 : 250.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: isCompact ? 12 : 56),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image.asset(
                          'assets/IceLink_icon.png',
                          width: iconSize,
                          height: iconSize,
                        ),
                      ),
                      const Text(
                        AppConstants.appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      if (userName != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          '$userName 님, 반가워요',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      SizedBox(height: isCompact ? 44 : 80),
                      FilledButton.icon(
                        onPressed: controller.openJoinRoom,
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('방 참가하기'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: controller.openCreateRoom,
                        icon: const Icon(Icons.add_circle_rounded),
                        label: const Text('방 생성하기'),
                      ),
                      if (controller.canUseDebugRoomClear) ...[
                        const SizedBox(height: 12),
                        Obx(
                          () => TextButton.icon(
                            onPressed: controller.isClearingActiveRoom.value
                                ? null
                                : controller.clearActiveRoomForDebug,
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: Text(
                              controller.isClearingActiveRoom.value
                                  ? '진행 중인 방 정리 중...'
                                  : '디버그: 진행 중인 방 종료',
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
