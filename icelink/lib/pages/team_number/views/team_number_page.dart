import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/team_question_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';
import '../../team_question/views/team_question_page.dart';

class TeamNumberPage extends StatelessWidget {
  const TeamNumberPage({super.key, required this.teamNumber, this.teamId});

  final int teamNumber;
  final int? teamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '팀 번호 확인하기'),
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
                    child: Column(
                      children: [
                        const Text(
                          '당신의 팀 번호',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '$teamNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 82,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {
                      Get.to(
                        () => const TeamQuestionPage(),
                        binding: BindingsBuilder(() {
                          Get.put(TeamQuestionController(teamId: teamId));
                        }),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('질문 페이지로 이동'),
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
