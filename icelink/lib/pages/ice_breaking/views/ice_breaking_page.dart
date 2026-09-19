import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/ice_breaking_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';

class IceBreakingPage extends GetView<IceBreakingController> {
  const IceBreakingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '아이스 브레이킹'),
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
                        Icon(
                          Icons.groups_2_rounded,
                          color: AppTheme.iceAccent,
                          size: 58,
                        ),
                        SizedBox(height: 18),
                        Text(
                          '아이스 브레이킹 중...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.08,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '팀원들이 서로 이야기할 수\n있도록 진행해주세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: controller.finishIceBreaking,
                    icon: const Icon(Icons.done_all_rounded),
                    label: const Text(
                        '추가 질문 제시 후 아이스 브레이킹 마치기!',
                      style: TextStyle(
                        fontSize: 15,
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
