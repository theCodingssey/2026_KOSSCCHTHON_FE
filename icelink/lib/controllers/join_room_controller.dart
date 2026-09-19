import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/team_question/views/team_question_page.dart';
import 'team_question_controller.dart';

class JoinRoomController extends GetxController {
  final pinController = TextEditingController();
  final selectedAnswers = <int, String>{}.obs;
  final selectedHobby = RxnString();
  final teamNumber = RxnInt();

  final questions = List<String>.generate(6, (index) => '문제 ${index + 1}');
  final answerOptions = const ['매우맞다', '맞다', '보통', '아니다', '매우아니다'];
  final hobbies = const ['게임', '여행', '음식', '스포츠', '영화'];

  bool get isSurveyComplete {
    return pinController.text.trim().isNotEmpty &&
        selectedAnswers.length == questions.length &&
        selectedHobby.value != null;
  }

  @override
  void onInit() {
    super.onInit();
    pinController.addListener(update);
  }

  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }

  void selectAnswer(int questionIndex, String answer) {
    selectedAnswers[questionIndex] = answer;
  }

  void selectHobby(String hobby) {
    selectedHobby.value = hobby;
  }

  void generateTeamNumber() {
    if (!isSurveyComplete) {
      Get.snackbar('아직 덜 골랐어요', '핀, 6개 설문, 취미를 모두 선택해주세요.');
      return;
    }

    teamNumber.value = 5;
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
