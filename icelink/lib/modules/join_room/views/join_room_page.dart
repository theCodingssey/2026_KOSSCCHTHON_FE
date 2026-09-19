import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/join_room_controller.dart';
import '../../../core/theme/app_theme.dart';

class JoinRoomPage extends GetView<JoinRoomController> {
  const JoinRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('방 참가하기'), centerTitle: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _PageHeader(
                    title: '방 핀과 설문을 입력하세요',
                    subtitle: '성격 질문 6개와 취미 하나를 고르면 팀 번호가 생성됩니다.',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.pinController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: '방 핀',
                      hintText: '예: ICE-2026',
                      prefixIcon: Icon(Icons.pin_rounded),
                    ),
                  ),
                  const SizedBox(height: 22),
                  for (int i = 0; i < controller.questions.length; i += 1) ...[
                    _QuestionBlock(questionIndex: i),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 4),
                  const Text(
                    '취미 선택',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final hobby in controller.hobbies)
                          _SelectableChip(
                            label: hobby,
                            selected: controller.selectedHobby.value == hobby,
                            onTap: () => controller.selectHobby(hobby),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: controller.generateTeamNumber,
                    icon: const Icon(Icons.groups_rounded),
                    label: const Text('팀 번호 생성하기'),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final teamNumber = controller.teamNumber.value;
                    if (teamNumber == null) {
                      return const SizedBox.shrink();
                    }

                    return _TeamNumberCard(
                      teamNumber: teamNumber,
                      onPressed: controller.goToQuestionPage,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionBlock extends GetView<JoinRoomController> {
  const _QuestionBlock({required this.questionIndex});

  final int questionIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.questions[questionIndex],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in controller.answerOptions)
                  _SelectableChip(
                    label: option,
                    selected:
                        controller.selectedAnswers[questionIndex] == option,
                    onTap: () => controller.selectAnswer(questionIndex, option),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamNumberCard extends StatelessWidget {
  const _TeamNumberCard({required this.teamNumber, required this.onPressed});

  final int teamNumber;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            '당신의 팀 번호',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$teamNumber',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 58,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('질문 페이지로 이동'),
          ),
        ],
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.ink,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppTheme.ink,
        fontWeight: FontWeight.w800,
      ),
      side: const BorderSide(color: Color(0xFFD0D5DD)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            height: 1.08,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF667085),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
