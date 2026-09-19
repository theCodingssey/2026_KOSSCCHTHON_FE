import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/create_room_controller.dart';
import '../../../core/theme/app_theme.dart';

class CreateRoomPage extends GetView<CreateRoomController> {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('방 생성하기'), centerTitle: false),
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
                    title: '팀 구성 방식을 정하세요',
                    subtitle: '팀별 인원과 주최자 질문을 설정하면 참가용 핀이 생성됩니다.',
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    '팀별 인원',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Row(
                      children: [
                        for (final count in [2, 3, 4, 5, 6])
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: count == 6 ? 0 : 8,
                              ),
                              child: _CountButton(
                                count: count,
                                selected:
                                    controller.teamMemberCount.value == count,
                                onTap: () =>
                                    controller.setTeamMemberCount(count),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AiQuestionCard(question: controller.aiQuestion),
                  const SizedBox(height: 22),
                  TextField(
                    controller: controller.customQuestionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: '주최자 추가 질문',
                      hintText: '예: 해커톤에서 어떤 부분이 가장 자신있나요?',
                      prefixIcon: Icon(Icons.question_answer_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: controller.createRoomPin,
                    icon: const Icon(Icons.pin_rounded),
                    label: const Text('방 핀 생성하기'),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final pin = controller.roomPin.value;
                    if (pin == null) {
                      return const SizedBox.shrink();
                    }

                    return _RoomPinCard(
                      pin: pin,
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

class _CountButton extends StatelessWidget {
  const _CountButton({
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.primaryBlue : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppTheme.primaryBlue : const Color(0xFFD0D5DD),
            ),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: selected ? Colors.white : AppTheme.ink,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _AiQuestionCard extends StatelessWidget {
  const _AiQuestionCard({required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI 기본 질문',
            style: TextStyle(
              color: AppTheme.iceAccent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.22,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomPinCard extends StatelessWidget {
  const _RoomPinCard({required this.pin, required this.onPressed});

  final String pin;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Column(
        children: [
          const Text(
            '참가용 핀',
            style: TextStyle(
              color: Color(0xFF667085),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pin,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
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
