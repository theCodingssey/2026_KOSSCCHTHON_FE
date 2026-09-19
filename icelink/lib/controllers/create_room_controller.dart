import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/team_question/views/team_question_page.dart';
import 'team_question_controller.dart';

class CreateRoomController extends GetxController {
  final customQuestionController = TextEditingController();
  final teamMemberCount = 4.obs;
  final roomPin = RxnString();

  final aiQuestion = '처음 만난 팀원들과 자연스럽게 자기소개를 하고, 오늘 함께 만들고 싶은 분위기를 이야기해보세요.';

  @override
  void onClose() {
    customQuestionController.dispose();
    super.onClose();
  }

  void setTeamMemberCount(int count) {
    teamMemberCount.value = count;
  }

  void createRoomPin() {
    roomPin.value = 'ICE-2026';
  }

  void goToQuestionPage() {
    Get.to(
      () => const TeamQuestionPage(),
      binding: BindingsBuilder(() {
        Get.put(TeamQuestionController());
      }),
    );
  }
}
