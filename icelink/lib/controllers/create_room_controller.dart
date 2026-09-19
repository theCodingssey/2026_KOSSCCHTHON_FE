import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/services/ice_link_api_service.dart';
import '../pages/people_checklist/views/people_checklist.dart';
import 'people_checklist_controller.dart';

class CreateRoomController extends GetxController {
  final teamMemberCountController = TextEditingController();
  final customQuestionController = TextEditingController();
  final roomPin = RxnString();
  final customQuestions = <String>[].obs;
  final isCreatingRoom = false.obs;

  final tipBoxText =
      '아이스 브레이킹 질문은\nIceLink가 직접 생성합니다!\n추가하고 싶은 질문이 있다면\n작성해주세요!';

  @override
  void onClose() {
    teamMemberCountController.dispose();
    customQuestionController.dispose();
    super.onClose();
  }

  int? get teamMemberCount {
    return int.tryParse(teamMemberCountController.text.trim());
  }

  IceLinkApiService get _api => Get.find<IceLinkApiService>();

  Future<void> createRoomPin() async {
    final count = teamMemberCount;
    if (count == null || count < 2 || count > 10) {
      Get.snackbar('팀별 인원 확인', '팀별 인원은 2~10 사이 숫자로 입력해주세요.');
      return;
    }

    isCreatingRoom.value = true;
    try {
      if (_api.isConfigured && !Get.testMode) {
        final room = await _api.createRoom(
          title: 'ICELINK 아이스브레이킹',
          situation: '처음 만난 참가자들이 자연스럽게 대화할 수 있는 아이스브레이킹 자리',
          teamSize: count,
          finalQuestions: customQuestions.take(5).toList(),
        );
        roomPin.value = room.stringValue('code', fallback: 'ICE-2026');
      } else {
        roomPin.value = 'ICE-2026';
      }
    } catch (_) {
      Get.snackbar('방 생성 실패', '서버에 방 생성 요청을 보내지 못했습니다.');
    } finally {
      isCreatingRoom.value = false;
    }
  }

  void addCustomQuestion() {
    final question = customQuestionController.text.trim();
    if (question.isEmpty) {
      Get.snackbar('질문을 입력해주세요', '추가할 질문 내용을 먼저 작성해주세요.');
      return;
    }

    customQuestions.add(question);
    customQuestionController.clear();
    if (!Get.testMode) {
      Get.snackbar('추가되었습니다!', '주최자 질문이 목록에 추가되었습니다.');
    }
  }

  void removeCustomQuestion(int index) {
    if (index < 0 || index >= customQuestions.length) {
      return;
    }

    customQuestions.removeAt(index);
  }

  void goToPeopleChecklist() {
    Get.to(
      () => const PeopleChecklist(),
      binding: BindingsBuilder(() {
        Get.put(
          PeopleChecklistController(roomPin: roomPin.value ?? 'ICE-2026'),
        );
      }),
    );
  }
}
