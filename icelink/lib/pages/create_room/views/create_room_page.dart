import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controllers/create_room_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';

class CreateRoomPage extends GetView<CreateRoomController> {
  const CreateRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '팀 구성 및 질문 추가'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '팀별 인원',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.teamMemberCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: '팀별 인원',
                      hintText: '예: 6명 (숫자만 작성하세요)',
                      prefixIcon: Icon(Icons.groups_rounded),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AiQuestionCard(question: controller.tipBoxText),
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
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: controller.addCustomQuestion,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('질문 추가하기'),
                  ),
                  const SizedBox(height: 18),
                  Obx(() {
                    if (controller.customQuestions.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return _CustomQuestionList(
                      questions: controller.customQuestions,
                      onRemove: controller.removeCustomQuestion,
                    );
                  }),
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
                      onPressed: controller.goToPeopleChecklist,
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

class _CustomQuestionList extends StatelessWidget {
  const _CustomQuestionList({required this.questions, required this.onRemove});

  final List<String> questions;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '추가된 질문',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < questions.length; i += 1) ...[
            _CustomQuestionTile(
              index: i,
              question: questions[i],
              onRemove: () => onRemove(i),
            ),
            if (i != questions.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _CustomQuestionTile extends StatelessWidget {
  const _CustomQuestionTile({
    required this.index,
    required this.question,
    required this.onRemove,
  });

  final int index;
  final String question;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              question,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            tooltip: '질문 삭제',
            icon: const Icon(Icons.close_rounded),
            visualDensity: VisualDensity.compact,
          ),
        ],
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
            'Tip!',
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
            label: const Text('참가자 명단 확인하기'),
          ),
        ],
      ),
    );
  }
}
