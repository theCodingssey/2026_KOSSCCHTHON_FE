import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/people_checklist_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/ice_link_app_bar.dart';

class PeopleChecklist extends GetView<PeopleChecklistController> {
  const PeopleChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IceLinkAppBar(title: '참가자 명단 확인하기'),
      body: SafeArea(
        // 화면이 넓을 때(maxWidth 520 이상) 중앙 정렬을 위해 Center 추가
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              // 전체를 아우르는 Column
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. 스크롤이 가능한 상단/중단 영역 (Expanded로 남은 공간 모두 차지)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RoomPinCard(pin: controller.roomPin),
                        const SizedBox(height: 22),
                        Obx(
                          () => _ParticipantList(
                            participants: controller.participants.toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. 하단에 고정되는 버튼 영역 (스크롤 밖으로 빼냄)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Obx(
                    () => FilledButton.icon(
                      onPressed: controller.isStarting.value
                          ? null
                          : controller.startIceBreaking,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(
                        controller.isStarting.value ? '시작 중...' : '시작하기!',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomPinCard extends StatelessWidget {
  const _RoomPinCard({required this.pin});

  final String pin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '참가용 핀',
            style: TextStyle(
              color: AppTheme.iceAccent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            pin,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantList extends StatelessWidget {
  const _ParticipantList({required this.participants});

  final List<String> participants;

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
          Row(
            children: [
              const Expanded(
                child: Text(
                  '참가자 명단',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                '${participants.length}명',
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (int i = 0; i < participants.length; i += 1) ...[
            _ParticipantTile(index: i, name: participants[i]),
            if (i != participants.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({required this.index, required this.name});

  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F8FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.primaryBlue,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const Icon(Icons.cancel, color: Colors.red),
        ],
      ),
    );
  }
}
