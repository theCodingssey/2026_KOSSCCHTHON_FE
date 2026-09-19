import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/join_room_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';

class TeamBuildingWaitPage extends GetView<JoinRoomController> {
  const TeamBuildingWaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '팀 빌딩 대기'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppTheme.ink,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      children: [
                        SizedBox(
                          width: 42,
                          height: 42,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: AppTheme.iceAccent,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          '팀 빌딩 중입니다...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.12,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '주최자가 시작하면\n팀 번호가 자동으로 표시됩니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.isWaitingForTeam.value
                          ? '팀 배정 결과를 확인하는 중'
                          : '팀 배정 완료',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
