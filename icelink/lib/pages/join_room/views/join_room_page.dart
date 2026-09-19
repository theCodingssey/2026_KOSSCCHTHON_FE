import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/join_room_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';

class JoinRoomPage extends GetView<JoinRoomController> {
  const JoinRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '방 참가하기'),
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
                    title: '방 핀과 설문을 입력하세요!',
                    subtitle: '성격 질문에 답하고 취미를 하나 선택해주세요.',
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
                          _HobbyChip(
                            label: hobby,
                            icon: _hobbyIcon(hobby),
                            selected: controller.selectedHobby.value == hobby,
                            onTap: () => controller.selectHobby(hobby),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => FilledButton.icon(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : controller.generateTeamNumber,
                      icon: const Icon(Icons.groups_rounded),
                      label: Text(
                        controller.isSubmitting.value ? '제출 중...' : '팀 번호 생성하기',
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
            () => _AnswerScale(
              options: controller.answerOptions,
              selectedAnswer: controller.selectedAnswers[questionIndex],
              onSelected: (answer) =>
                  controller.selectAnswer(questionIndex, answer),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerScale extends StatelessWidget {
  const _AnswerScale({
    required this.options,
    required this.selectedAnswer,
    required this.onSelected,
  });

  final List<String> options;
  final String? selectedAnswer;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < options.length; i += 1)
              _AnswerCircle(
                label: options[i],
                selected: selectedAnswer == options[i],
                color: _answerColor(i),
                onTap: () => onSelected(options[i]),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: Text(
                '매우 맞음',
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '매우 아님',
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _answerColor(int index) {
    if (index < 2) {
      return AppTheme.primaryBlue;
    }
    if (index == 2) {
      return const Color(0xFFB8BDC7);
    }
    return const Color(0xFF7A4A15);
  }
}

class _AnswerCircle extends StatelessWidget {
  const _AnswerCircle({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      selected: selected,
      child: Tooltip(
        message: label,
        child: InkResponse(
          onTap: onTap,
          radius: 26,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? color : Colors.white,
              border: Border.all(color: color, width: selected ? 6 : 2.5),
            ),
            child: selected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                : null,
          ),
        ),
      ),
    );
  }
}

class _HobbyChip extends StatelessWidget {
  const _HobbyChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      key: ValueKey('hobby-$label'),
      avatar: Icon(
        icon,
        size: 18,
        color: selected ? Colors.white : AppTheme.primaryBlue,
      ),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryBlue,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppTheme.ink,
        fontWeight: FontWeight.w800,
      ),
      side: const BorderSide(color: Color(0xFFD0D5DD)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

IconData _hobbyIcon(String hobby) {
  return switch (hobby) {
    '게임' => Icons.sports_esports_rounded,
    '여행' => Icons.flight_takeoff_rounded,
    '음식' => Icons.restaurant_rounded,
    '스포츠' => Icons.sports_soccer_rounded,
    '영화' => Icons.movie_rounded,
    _ => Icons.interests_rounded,
  };
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
